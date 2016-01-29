//
//  SPRSettingsPopAnimator.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 28/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRSettingsPopAnimator.h"

@implementation SPRSettingsPopAnimator

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [[transitionContext containerView] insertSubview:toViewController.view belowSubview:fromViewController.view];
    
    __block CGRect tvcFrame = toViewController.view.frame;
    tvcFrame.origin.x += tvcFrame.size.width;
    toViewController.view.frame = tvcFrame;
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        tvcFrame = toViewController.view.frame;
        tvcFrame.origin.x -= tvcFrame.size.width;
        toViewController.view.frame = tvcFrame;
        
        CGRect fvcFrame = fromViewController.view.frame;
        fvcFrame.origin.x -= fvcFrame.size.width;
        fromViewController.view.frame = fvcFrame;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

@end
