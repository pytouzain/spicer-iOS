//
//  SPRRequestHandler.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRRequestHandler.h"

@interface SPRRequestHandler ()

@property (nonatomic, strong) SPRHTTPRequestManager *httpRequestManager;
@property (nonatomic, strong) SPRDataManager *dataManager;

@end

@implementation SPRRequestHandler

static SPRRequestHandler *requestHandler = nil;

+ (instancetype)sharedHandler
{
    if (requestHandler == nil)
        requestHandler = [[SPRRequestHandler alloc] init];
    return requestHandler;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpRequestManager = [[SPRHTTPRequestManager alloc] init];
        _dataManager = [[SPRDataManager alloc] init];
        
        _httpRequestManager.delegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark Requests Methods

- (void)signInWithUsername:(NSString *)username password:(NSString *)password {
    [_httpRequestManager signInWithUsername:username password:password];
}

- (void)signUpWithUsernameOne:(NSString *)usernameOne usernameTwo:(NSString *)usernameTwo password:(NSString *)password {
    [_httpRequestManager signUp:@{@"user1":usernameOne, @"user2":usernameTwo, @"password":password}];
}

- (void)signOut {
    _httpRequestManager.token = nil;
    [_dataManager signOut];
}

- (void)getCurrentFantaisy
{
    [_httpRequestManager seeFantaisy];
}

- (void)changeStatus:(BOOL)status forFantaisyDatas:(NSDictionary *)fantaisyDatas {
    [_httpRequestManager changeStatus:status forFantaisyDatas:fantaisyDatas];
}

- (void)getFantaisiesDatas {
    
}

- (void)getFantaisyForID:(int)fantaisyID {
    [_httpRequestManager getFantaisyForID:fantaisyID];
}

- (SPRFantaisy *)fetchFantaisyForID:(int)fantaisyID {
    return [_dataManager fetchFantaisyWithFantaisyID:fantaisyID];
}

- (void)getNotificationsWithPopUp:(BOOL)withPopUp {
    [_httpRequestManager getNotificationsWithPopUp:withPopUp];
}

- (BOOL)isThereUnseenNotification {
    return [_dataManager isThereUnseenNotification];
}

- (NSUInteger)getNotificationsNumber {
    return [_dataManager.notifications count];
}

- (SPRNotification *)fetchNotificationForIndex:(NSUInteger)index {
    return [_dataManager.notifications objectAtIndex:index];
}

- (void)setNotificationStatus:(BOOL)isSeen forNotificationID:(int)notificationID {
    [_httpRequestManager setNotificationStatus:isSeen forNotificationID:notificationID];
}

- (void)sendFeedback:(NSString *)feedback {
    [_httpRequestManager sendFeedback:feedback];
}

- (void)getFeedBack {
    
}

- (void)changeSettings:(int)settingType withData:(int)data {
    [_httpRequestManager changeSettingType:settingType withData:data];
}

- (SPRCurrentUser *)fetchCurrentUser {
    return [_dataManager fetchCurrentUser];
}

#pragma mark -
#pragma mark SPRHTTPRequestManagerProtocol Methods

- (void)signInDidSucceed:(NSDictionary *)response {
    [_dataManager signInDidSucceed:response];
    _httpRequestManager.token = [response objectForKey:@"token"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"signInSuccess" object:response];
}
- (void)signInDidFail:(NSNumber *)errorCode {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"signInFail" object:errorCode];
}

- (void)signUpDidSucceed:(NSDictionary *)response {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"signUpSuccess" object:response];
}
- (void)signUpDidFail:(NSNumber *)errorCode {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"signUpFail" object:errorCode];
}

- (void)seeFantaisyDidSucceed:(NSDictionary *)response {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"seeFantaisySuccess" object:response];
}
- (void)seeFantaisyDidFail:(NSNumber *)errorCode {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"seeFantaisyFail" object:errorCode];
}

- (void)changeStatusDidSucceed:(NSDictionary *)response {
    if ([[response objectForKey:@"status"] boolValue] == YES) {
        [_dataManager getNewFantaisyToPersist:[response objectForKey:@"currentFantaisy"]];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeStatusSuccess" object:response];
}
- (void)changeStatusDidFail:(NSNumber *)errorCode {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeStatusFail" object:errorCode];
}

- (void)getFantaisiesDatasDidSucceed:(NSDictionary *)response { }
- (void)getFantaisiesDatasDidFail:(NSNumber *)errorCode { }

- (void)getFantaisyDidSucceed:(NSDictionary *)response {
    [_dataManager getNewFantaisyToPersist:response];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getFantaisySuccess" object:response];
}
- (void)getFantaisyDidFail:(NSNumber *)errorCode {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getFantaisyFail" object:errorCode];
}

- (void)getNotificationsDidSucceed:(NSDictionary *)response {
    NSMutableDictionary *newResponse = [NSMutableDictionary dictionaryWithDictionary:response];
    NSArray *oldArray = _dataManager.notifications;
    
    [_dataManager updateNotificationsFromDatas:[response objectForKey:@"notificationsArray"]];
    
    if ([[response objectForKey:@"withPopUp"] boolValue]) {
        NSArray *newArray = _dataManager.notifications;
        NSMutableArray *compareArray = [NSMutableArray arrayWithArray:newArray];
        [compareArray removeObjectsInArray:oldArray];
        
        if ([compareArray count] > 0) {
            SPRNotification *newNotification = (SPRNotification *)[compareArray objectAtIndex:0];
            SPRFantaisy *matchedFantaisy = [_dataManager fetchFantaisyWithFantaisyID:newNotification.fantaisyID];
            [newResponse setObject:matchedFantaisy forKey:@"matchedFantaisy"];
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getNotificationsSuccess" object:newResponse];
}
- (void)getNotificationsDidFail:(NSNumber *)errorCode {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"getNotificationsFail" object:errorCode];
}

- (void)setNotificationsStatusDidSucceed:(NSDictionary *)response {
    [_dataManager updateNotificationStatus:[[response objectForKey:@"seen"] boolValue] forNotificationID:[[response objectForKey:@"notificationID"] intValue]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setNotificationsStatusSuccess" object:response];
}

- (void)setNotificationsStatusDidFail:(NSNumber *)errorCode {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"setNotificationsStatusFail" object:errorCode];
}

- (void)sendFeedbackDidSucceed:(NSDictionary *)response {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendFeedbackSuccess" object:response];
}
- (void)sendFeedbackDidFail:(NSNumber *)errorCode {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sendFeedbackFail" object:errorCode];
}

- (void)getFeedBackDidSucceed:(NSDictionary *)response { }
- (void)getFeedBackDidFail:(NSNumber *)errorCode { }

- (void)changeSettingDidSucceed:(NSDictionary *)response {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSettingSuccess" object:response];
}
- (void)changeSettingDidFail:(NSNumber *)errorCode {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeSettingFail" object:errorCode];
}

@end
