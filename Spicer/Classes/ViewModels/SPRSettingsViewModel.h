//
//  SPRSettingsViewModel.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPRViewModel.h"

typedef enum {
    SPRSettingTypeLanguage  = 2,
    SPRSettingTypeSexuality = 3,
    SPRSettingTypeSpicenest = 4
} SPRSettingType;

@protocol SPRSettingsViewModelDelegate <SPRViewModelDelegate>

- (void)sendFeedbackSuccess;
- (void)sendFeedbackFail;

@end

@interface SPRSettingsViewModel : SPRViewModel

@property (nonatomic, assign) id<SPRSettingsViewModelDelegate> delegate;

- (void)sendFeedback:(NSString *)feedback;
- (void)changeSetting:(int)settingType withData:(int)data;

@end
