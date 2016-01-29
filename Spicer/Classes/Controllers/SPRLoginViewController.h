//
//  LoginViewController.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 29/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPRLoginViewModel.h"

@interface SPRLoginViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) SPRLoginViewModel *viewModel;

@end
