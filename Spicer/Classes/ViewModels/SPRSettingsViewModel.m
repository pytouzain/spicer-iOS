//
//  SPRSettingsViewModel.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRSettingsViewModel.h"
#import "SPRRequestHandler.h"

@implementation SPRSettingsViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendFeedBackSuccess:) name:@"sendFeedbackSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendFeedBackFail:) name:@"sendFeedbackFail" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSettingSuccess:) name:@"changeSettingSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSettingFail:) name:@"changeSettingFail" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)sendFeedback:(NSString *)feedback {
    if (![feedback isEqualToString:@""]) {
        [[SPRRequestHandler sharedHandler] sendFeedback:feedback];
    }
}

- (void)changeSetting:(int)settingType withData:(int)data {
    [[SPRRequestHandler sharedHandler] changeSettings:settingType withData:data];
}

#pragma mark -
#pragma mark NSNotificationCenter Selectors

- (void)sendFeedBackSuccess:(NSNotification *)notification {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendFeedbackSuccess)]) {
        [self.delegate sendFeedbackSuccess];
    }
}

- (void)sendFeedBackFail:(NSNotification *)notification {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendFeedbackFail)]) {
        [self.delegate sendFeedbackFail];
    }
}

- (void)changeSettingSuccess:(NSNotification *)notification {
    switch ([[notification.object objectForKey:@"settingType"] intValue]) {
        case SPRSettingTypeSpicenest:
            [[NSUserDefaults standardUserDefaults] setObject:[notification.object objectForKey:@"settingData"] forKey:@"spiceness"];
            break;
            
        default:
            break;
    }
}

- (void)changeSettingFail:(NSNotification *)notification {
    
}

@end
