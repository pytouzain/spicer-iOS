//
//  RegisterViewController.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 29/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SPRRegisterViewController.h"
#import "SPRRequestHandler.h"

#import "NSString+MD5.h"

#define kOFFSET_FOR_KEYBOARD 80.0

@interface SPRRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameOneTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTwoTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *registrationLabel;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;
@property (weak, nonatomic) IBOutlet UILabel *errorMessageLabel;

@end

@implementation SPRRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signUpSuccess:) name:@"signUpSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(signUpFail:) name:@"signUpFail" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    _usernameOneTextField.layer.borderColor = [kSpicerColorRed CGColor];
    _usernameOneTextField.layer.masksToBounds = YES;
    _usernameOneTextField.layer.borderWidth = 0.8f;
    _usernameOneTextField.layer.cornerRadius= 6.0f;
    
    _usernameTwoTextField.layer.borderColor = [kSpicerColorRed CGColor];
    _usernameTwoTextField.layer.masksToBounds = YES;
    _usernameTwoTextField.layer.borderWidth = 0.8f;
    _usernameTwoTextField.layer.cornerRadius= 6.0f;
    
    _passwordTextField.layer.borderColor = [kSpicerColorRed CGColor];
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.borderWidth = 0.8f;
    _passwordTextField.layer.cornerRadius= 6.0f;
    
    _usernameOneTextField.placeholder = NSLocalizedString(@"My username", nil);
    _usernameTwoTextField.placeholder = NSLocalizedString(@"My partner", nil);
    _passwordTextField.placeholder = NSLocalizedString(@"Our password", nil);
    _registrationLabel.text = NSLocalizedString(@"Registration", nil);
    [_signUpButton setTitle:NSLocalizedString(@"Sign Up", nil) forState:UIControlStateNormal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_usernameOneTextField resignFirstResponder];
    [_usernameTwoTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)signUp:(id)sender {
    [[SPRRequestHandler sharedHandler] signUpWithUsernameOne:_usernameOneTextField.text usernameTwo:_usernameTwoTextField.text password:[_passwordTextField.text md5]];
}

- (void)signUpSuccess:(NSNotification *)notification {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)signUpFail:(NSNotification *)notification {
    _errorMessageLabel.text = [self.viewModel errorCodeToMessage:notification.object];
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

#pragma mark UIKeyboard notifications

-(void)keyboardWillShow:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
        self.view.frame = rect;
    }];
}

-(void)keyboardWillHide:(NSNotification *)notification {
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
        self.view.frame = rect;
    }];
}

@end
