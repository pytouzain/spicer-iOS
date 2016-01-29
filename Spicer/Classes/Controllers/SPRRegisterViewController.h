//
//  RegisterViewController.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 29/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPRRegisterViewModel.h"

@interface SPRRegisterViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) SPRRegisterViewModel *viewModel;

@end
