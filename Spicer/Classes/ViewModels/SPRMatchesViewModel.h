//
//  SPRMatchesViewModel.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SPRViewModel.h"

#import "SPRMatchCellViewModel.h"
#import "SPRFantaisyViewModel.h"

@protocol SPRMatchesViewModelDelegate <SPRViewModelDelegate>

- (void)getNotificationSuccess;
- (void)getNotificationFail;

@end

@interface SPRMatchesViewModel : SPRViewModel

@property (nonatomic, assign) id<SPRMatchesViewModelDelegate> delegate;
@property (nonatomic, assign) NSUInteger notificationsNumber;

- (void)updateNotificationStatus:(BOOL)status forIndexPath:(NSIndexPath *)indexPath;
- (SPRMatchCellViewModel *)matchViewModelForIndexPath:(NSIndexPath *)indexPath;
- (SPRFantaisyViewModel *)fantaisyViewModelForIndexPath:(NSIndexPath *)indexPath;

@end
