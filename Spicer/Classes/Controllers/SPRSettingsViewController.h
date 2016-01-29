//
//  SettingsViewController.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 19/02/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPRSettingsViewModel.h"

@interface SPRSettingsViewController : UIViewController <SPRSettingsViewModelDelegate, UITextViewDelegate>

@property (nonatomic, strong) SPRSettingsViewModel *viewModel;

@end
