//
//  HomeViewController.m
//  Spicer
//
//  Created by Pierre-Yves on 16/02/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRHomeViewController.h"
#import "SPRLoginViewController.h"
#import "SPRLoginViewModel.h"
#import "SPRRegisterViewController.h"
#import "SPRRegisterViewModel.h"
#import "SPRFantaisiesViewController.h"
#import "SPRFantaisiesViewModel.h"

#import "SPRRequestHandler.h"

@interface SPRHomeViewController ()

@property (weak, nonatomic) IBOutlet UIButton *alreadyRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *spiceUpButton;
@property (weak, nonatomic) IBOutlet UILabel *betweenButtonsLabel;
@property (weak, nonatomic) IBOutlet UILabel *registrationLabel;

@property (strong, nonatomic) UIView *hidingView;

@end

@implementation SPRHomeViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewModel = [[SPRHomeViewModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInSuccess:) name:@"signInSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInFail:) name:@"signInFail" object:nil];
    
    self.hidingView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.hidingView setBackgroundColor:[UIColor whiteColor]];
    
    if (self.viewModel.currentUser) {
        [self.view addSubview:self.hidingView];
        [[SPRRequestHandler sharedHandler] signInWithUsername:self.viewModel.currentUser.username password:self.viewModel.currentUser.password];
    }
    [_alreadyRegisterButton setTitle:NSLocalizedString(@"Login", nil) forState:UIControlStateNormal];
    [_spiceUpButton setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    _betweenButtonsLabel.text = NSLocalizedString(@"or", nil);
    _registrationLabel.text = NSLocalizedString(@"Registration", nil);
    NSLog(@"Test");
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)signInSuccess:(NSNotification *)notification
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self.hidingView removeFromSuperview];
    });
    [self performSegueWithIdentifier:@"alreadyLoggedSegueIdentifier" sender:nil];
}

- (void)signInFail:(NSNotification *)notification
{
    [self.hidingView removeFromSuperview];
    NSLog(@"ERROR AUTO LOGIN");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"signInSegueIdentifier"]) {
        SPRLoginViewController *vc = (SPRLoginViewController *)segue.destinationViewController;
        SPRLoginViewModel *viewModel = [[SPRLoginViewModel alloc] init];
        vc.viewModel = viewModel;
    }
    else if ([segue.identifier isEqualToString:@"signUpSegueIdentifier"]) {
        SPRRegisterViewController *vc = (SPRRegisterViewController *)segue.destinationViewController;
        SPRRegisterViewModel *viewModel = [[SPRRegisterViewModel alloc] init];
        vc.viewModel = viewModel;
    }
}
@end
