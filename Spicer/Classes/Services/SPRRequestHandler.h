//
//  SPRRequestHandler.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SPRHTTPRequestManager.h"
#import "SPRDataManager.h"

#import "SPRCurrentUser.h"
#import "SPRNotification.h"

@interface SPRRequestHandler : NSObject <SPRHTTPRequestManagerDelegate>

+ (instancetype)sharedHandler;

- (void)signInWithUsername:(NSString *)username password:(NSString *)password;
- (void)signUpWithUsernameOne:(NSString *)usernameOne usernameTwo:(NSString *)usernameTwo password:(NSString *)password;
- (void)signOut;

- (void)getCurrentFantaisy;
- (SPRCurrentUser *)fetchCurrentUser;

- (void)changeStatus:(BOOL)status forFantaisyDatas:(NSDictionary *)fantaisyDatas;
- (void)getNotificationsWithPopUp:(BOOL)withPopUp;
- (BOOL)isThereUnseenNotification;
- (NSUInteger)getNotificationsNumber;
- (SPRNotification *)fetchNotificationForIndex:(NSUInteger)index;
- (void)setNotificationStatus:(BOOL)isSeen forNotificationID:(int)notificationID;

- (void)getFantaisyForID:(int)fantaisyID;
- (SPRFantaisy *)fetchFantaisyForID:(int)fantaisyID;

- (void)sendFeedback:(NSString *)feedback;
- (void)changeSettings:(int)settingType withData:(int)data;


@end
