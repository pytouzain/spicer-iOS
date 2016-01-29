//
//  NotificationPushView.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 07/06/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SPRNotificationPushView : UIView

@property (nonatomic, strong) NSString *title;

- (void)showNotification;

@end
