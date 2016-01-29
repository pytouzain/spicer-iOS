//
//  HTTPRequestManager.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 29/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPRHTTPRequestManagerDelegate <NSObject>

- (void)signInDidSucceed:(NSDictionary *)response;
- (void)signInDidFail:(NSNumber *)errorCode;

- (void)signUpDidSucceed:(NSDictionary *)response;
- (void)signUpDidFail:(NSNumber *)errorCode;

- (void)seeFantaisyDidSucceed:(NSDictionary *)response;
- (void)seeFantaisyDidFail:(NSNumber *)errorCode;

- (void)changeStatusDidSucceed:(NSDictionary *)response;
- (void)changeStatusDidFail:(NSNumber *)errorCode;

- (void)getFantaisiesDatasDidSucceed:(NSDictionary *)response;
- (void)getFantaisiesDatasDidFail:(NSNumber *)errorCode;

- (void)getFantaisyDidSucceed:(NSDictionary *)response;
- (void)getFantaisyDidFail:(NSNumber *)errorCode;

- (void)getNotificationsDidSucceed:(NSDictionary *)response;
- (void)getNotificationsDidFail:(NSNumber *)errorCode;

- (void)setNotificationsStatusDidSucceed:(NSDictionary *)response;
- (void)setNotificationsStatusDidFail:(NSNumber *)errorCode;

- (void)sendFeedbackDidSucceed:(NSDictionary *)response;
- (void)sendFeedbackDidFail:(NSNumber *)errorCode;

- (void)getFeedBackDidSucceed:(NSDictionary *)response;
- (void)getFeedBackDidFail:(NSNumber *)errorCode;

- (void)changeSettingDidSucceed:(NSDictionary *)response;
- (void)changeSettingDidFail:(NSNumber *)errorCode;

@end

@interface SPRHTTPRequestManager : NSObject

@property (nonatomic, weak) id<SPRHTTPRequestManagerDelegate> delegate;
@property (nonatomic, strong) NSString *token;

- (void)signUp:(NSDictionary *)parameters;
- (void)signInWithUsername:(NSString *)username password:(NSString *)password;
- (void)getFantaisiesDatas;
- (void)getFantaisyForID:(int)fantaisyID;
- (void)seeFantaisy;
- (void)changeStatus:(BOOL)isLiked forFantaisyDatas:(NSDictionary *)fantaisyDatas;
- (void)getNotificationsWithPopUp:(BOOL)withPopUp;
- (void)setNotificationStatus:(BOOL)isSeen forNotificationID:(int)notificationID;
- (void)sendFeedback:(NSString *)feedback;
- (void)getFeedback;
- (void)changeSettingType:(int)type withData:(int)data;

@end
