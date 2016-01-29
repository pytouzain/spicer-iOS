//
//  SPRMatchCellViewModel.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 28/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPRViewModel.h"

#import "SPRFantaisy.h"
#import "SPRNotification.h"

@interface SPRMatchCellViewModel : SPRViewModel

@property (nonatomic, strong) id<SPRViewModelDelegate> delegate;
@property (nonatomic, strong) SPRFantaisy *fantaisy;

- (instancetype)initWithNotification:(SPRNotification *)notification;
- (BOOL)isNotificationSeen;

@end
