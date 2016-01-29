//
//  LoginViewController.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 29/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SPRLoginViewController.h"
#import "SPRRequestHandler.h"

#import "NSString+MD5.h"

@interface SPRLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *identificationLabel;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;

@end

@implementation SPRLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _passwordTextField.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInSuccess:) name:@"signInSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signInFail:) name:@"signInFail" object:nil];
    
    _usernameTextField.layer.borderColor = [kSpicerColorRed CGColor];
    _usernameTextField.layer.masksToBounds = YES;
    _usernameTextField.layer.borderWidth = 0.8f;
    _usernameTextField.layer.cornerRadius= 6.0f;
    
    _passwordTextField.layer.borderColor = [kSpicerColorRed CGColor];
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.borderWidth = 0.8f;
    _passwordTextField.layer.cornerRadius= 6.0f;
    
    _usernameTextField.placeholder = NSLocalizedString(@"My username", nil);
    _passwordTextField.placeholder = NSLocalizedString(@"Our password", nil);
    _identificationLabel.text = NSLocalizedString(@"Login", nil);
    [_signInButton setTitle:NSLocalizedString(@"Sign In", nil) forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_usernameTextField setText:@""];
    [_passwordTextField setText:@""];
    [_usernameTextField becomeFirstResponder];
}

- (IBAction)signIn:(id)sender {
    [[SPRRequestHandler sharedHandler] signInWithUsername:_usernameTextField.text password:[_passwordTextField.text md5]];
}

- (void)signInSuccess:(NSNotification *)notification
{
    [self performSegueWithIdentifier:@"signInSuccess" sender:nil];
}

- (void)signInFail:(NSNotification *)notification
{
    _errorMessageLabel.text = [self.viewModel errorCodeToMessage:notification.object];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark UITextfield delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _errorMessageLabel.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger nextTag = textField.tag + 1;
    
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        [nextResponder becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
    }
    return NO;
}

@end
