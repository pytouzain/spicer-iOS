//
//  SPRFantaisiesViewModel.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPRViewModel.h"

#import "SPRFantaisy.h"

@protocol SPRFantaisiesViewModelDelegate <SPRViewModelDelegate>

- (void)changeStatusSuccess;
- (void)changeStatusFailWithStatusCode:(NSInteger)statusCode;
- (void)getNotificationsSuccessWithPopUp:(BOOL)withPopUp matchedFantaisy:(SPRFantaisy *)fantaisy;
- (void)getNotificationsFail;

@end

@interface SPRFantaisiesViewModel : SPRViewModel

@property (nonatomic, strong) id<SPRFantaisiesViewModelDelegate> delegate;
@property (nonatomic, strong) NSDictionary *currentFantaisyDatas;
@property (nonatomic, strong) NSString *errorMessage;
@property (nonatomic, assign) BOOL unseenNotification;

- (SPRFantaisy *)getCurrentFantaisyObject;
- (void)changeStatusForCurrentFantaisy:(BOOL)newStatus;

@end
