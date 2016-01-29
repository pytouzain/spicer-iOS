//
//  DataManager.h
//  Spicer
//
//  Created by Pierre-Yves on 26/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

#import "SPRCurrentUser.h"
#import "SPRFantaisy.h"

@interface SPRDataManager : NSObject

@property (nonatomic, readonly, strong) NSString *token;

@property (nonatomic, strong) NSArray *notifications;
@property (nonatomic, assign) NSUInteger notificationPendingNumber;

@property (nonatomic, assign) BOOL isSigningOut;

- (void)signInDidSucceed:(NSDictionary *)datas;
- (BOOL)checkCurrentUserExistence;
- (void)getNewFantaisyToPersist:(NSDictionary *)fantaisyDatas;
//- (void)setLanguage:(NSString *)data;
//- (void)setSexuality:(NSString *)data;
//- (void)setSpicenest:(NSString *)data;

- (void)updateNotificationsFromDatas:(NSArray *)notificationsDatas;
- (void)updateNotificationStatus:(BOOL)status forNotificationID:(int)notificationID;
- (BOOL)isThereUnseenNotification;

- (void)signOut;

//- (void)changeStatus:(BOOL)isLiked forFantaisy:(NSDictionary *)fantaisyDatas;

//- (void)getFantaisiesDatas;
//- (void)getCurrentFantaisy;
//- (void)getFantaisy:(int)fantaisyID;

- (RLMResults *)fetchFantaisiesFromDatabase;

- (SPRFantaisy *)fetchFantaisyWithFantaisyID:(int)fantaisyID;
- (SPRCurrentUser *)fetchCurrentUser;


@end
