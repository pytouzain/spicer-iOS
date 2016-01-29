//
//  SettingsViewController.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 19/02/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRSettingsViewController.h"
#import "SPRRequestHandler.h"

@interface SPRSettingsViewController ()

@property (nonatomic, weak) IBOutlet UITextView *feedbackText;
@property (weak, nonatomic) IBOutlet UILabel *spicenestTitleLabel;
@property (weak, nonatomic) IBOutlet UISlider *spicenestSlider;
@property (weak, nonatomic) IBOutlet UILabel *spicenestLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *signOutButton;
@property (weak, nonatomic) IBOutlet UILabel *communicationLabel;

@end

@implementation SPRSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = NSLocalizedString(@"Parameters", nil);
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : kSpicerColorDarkRed}];
    
    self.navigationItem.hidesBackButton = YES;
    
    UIImage *imageButtonRight = [[UIImage imageNamed:@"link"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:imageButtonRight
                                                                        style:UIBarButtonItemStylePlain target:self action:@selector(backToFantaisies)];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor grayColor]];
    
    [_spicenestSlider setValue:[[[NSUserDefaults standardUserDefaults] objectForKey:@"spiceness"] floatValue]];
    _spicenestLabel.text = [NSString stringWithFormat:@"%d", (int)_spicenestSlider.value];
    _spicenestTitleLabel.text = NSLocalizedString(@"Spiceness", nil);
    [_sendButton setTitle:NSLocalizedString(@"Send", nil) forState:UIControlStateNormal];
    [_signOutButton setTitle:NSLocalizedString(@"Sign Out", nil) forState:UIControlStateNormal];
    _communicationLabel.text = NSLocalizedString(@"Have an idea, suggestion or issue with Spicer? Contact us!", nil);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.viewModel changeSetting:SPRSettingTypeSpicenest withData:(int)_spicenestSlider.value];
}

- (void)backToFantaisies {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)signOut:(id)sender
{
    [[SPRRequestHandler sharedHandler] signOut];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)sendFeedback:(id)sender
{
    [self.viewModel sendFeedback:_feedbackText.text];
}

- (IBAction)spinestValueChanged:(UISlider *)sender {
    _spicenestLabel.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

#pragma mark - SPRSettingsViewModel Delegate Methods

- (void)sendFeedbackSuccess {
    _feedbackText.text = @"";
}

- (void)sendFeedbackFail {
    
}

#pragma mark - UITextView Delegate Methods

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

@end
