//
//  SPRNavigationControllerDelegate.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 28/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRNavigationControllerDelegate.h"

#import "SPRSettingsViewController.h"
#import "SPRSettingsPushAnimator.h"
#import "SPRSettingsPopAnimator.h"

@interface SPRNavigationControllerDelegate ()

@property (nonatomic, weak) IBOutlet UINavigationController *navigationController;
@property (nonatomic, strong) SPRSettingsPushAnimator *settingsPushAnimator;
@property (nonatomic, strong) SPRSettingsPopAnimator *settingsPopAnimator;

@end

@implementation SPRNavigationControllerDelegate

- (void)awakeFromNib {
    self.settingsPushAnimator = [SPRSettingsPushAnimator new];
    self.settingsPopAnimator = [SPRSettingsPopAnimator new];
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ([toVC isKindOfClass:[SPRSettingsViewController class]] && operation == UINavigationControllerOperationPush) {
        return self.settingsPushAnimator;
    }
    else if ([fromVC isKindOfClass:[SPRSettingsViewController class]] && operation == UINavigationControllerOperationPop) {
        return self.settingsPopAnimator;
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    return nil;
}

@end
