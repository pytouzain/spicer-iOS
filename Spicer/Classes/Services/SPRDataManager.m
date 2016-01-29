//
//  DataManager.m
//  Spicer
//
//  Created by Pierre-Yves on 26/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import "SPRDataManager.h"

#import "SPRHTTPRequestManager.h"

#import "SPRCouple.h"
#import "SPRUser.h"
#import "SPRPersonalData.h"
#import "SPRNotification.h"

@interface SPRDataManager ()

@property (nonatomic, strong) RLMRealm *defaultRealm;
@property (nonatomic, strong) NSString *token;

@property (nonatomic, strong) NSDictionary *currentFantaisyDatas;

@end

@implementation SPRDataManager

- (instancetype)init {
    if ([super init]) {
        _defaultRealm = [RLMRealm defaultRealm];
        _notificationPendingNumber = 0;
        _isSigningOut = NO;
        _currentFantaisyDatas = nil;
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)signInDidSucceed:(NSDictionary *)datas {
    _token = [datas objectForKey:@"token"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", 5] forKey:@"spiceness"];
    [self persistCurrentUser:[datas objectForKey:@"username"] password:[datas objectForKey:@"password"] token:[datas objectForKey:@"token"]];
}

- (void)signOut
{
    [self resetDataBase];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"language"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sexuality"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"spiceness"];
    self.token = nil;
    _isSigningOut = NO;
}

- (BOOL)checkCurrentUserExistence {
    SPRCurrentUser *currentUser = [self fetchCurrentUser];
    
    if (!currentUser) {
        return NO;
    }
    self.token = currentUser.token;
    return YES;
}

- (void)getNewFantaisyToPersist:(NSDictionary *)fantaisyDatas {
    [self persistFantaisyFromDatas:fantaisyDatas];
}

- (NSArray *)notifications {
    RLMResults *results = [SPRNotification allObjects];
    NSMutableArray *returnedArray = [[NSMutableArray alloc] initWithCapacity:results.count];
    
    for (SPRNotification *notification in results) {
        [returnedArray addObject:notification];
    }
    return returnedArray;
}

- (void)updateNotificationsFromDatas:(NSArray *)notificationsDatas {
    for (id data in notificationsDatas) {
        [self persistNotification:[[data objectForKey:@"id"] intValue]
                       fantaisyID:[[data objectForKey:@"fantaisy"] intValue]
                           isSeen:[[data objectForKey:@"seen"] boolValue]
                            date:[data objectForKey:@"date"]];
    }
}

- (void)updateNotificationStatus:(BOOL)status forNotificationID:(int)notificationID {
    RLMResults *results = [SPRNotification objectsInRealm:_defaultRealm withPredicate:[NSPredicate predicateWithFormat:@"notificationID = %d", notificationID]];
    
    if ([results count] > 0) {
        [_defaultRealm beginWriteTransaction];
        SPRNotification *notification = (SPRNotification *)[results objectAtIndex:0];
        notification.isSeen = status;
        [_defaultRealm addOrUpdateObject:notification];
        [_defaultRealm commitWriteTransaction];
    }
}

- (BOOL)isThereUnseenNotification {
    RLMResults *results = [SPRNotification allObjects];
    
    for (SPRNotification *notification in results) {
        if (notification.isSeen == NO)
            return YES;
    }
    return NO;
}

#pragma mark Fetch Datas from database

- (RLMResults *)fetchFantaisiesFromDatabase
{
    return [SPRFantaisy allObjects];
}

- (SPRFantaisy *)fetchFantaisyWithFantaisyID:(int)fantaisyID
{
    RLMResults *results = [SPRFantaisy objectsInRealm:_defaultRealm withPredicate:[NSPredicate predicateWithFormat:@"fantaisyID = %d", fantaisyID]];
    
    if ([results count] > 0)
        return (SPRFantaisy *)[results objectAtIndex:0];
    return nil;
}

- (SPRCurrentUser *)fetchCurrentUser {
    RLMResults *results = [SPRCurrentUser allObjects];
    return [results count] > 0 ? (SPRCurrentUser *)[results objectAtIndex:0] : nil;
}

#pragma mark Persistence methods

- (void)persistCurrentUser:(NSString *)username password:(NSString *)password token:(NSString *)token {
    [_defaultRealm beginWriteTransaction];
    SPRCurrentUser *currentUser = [[SPRCurrentUser alloc] init];
    currentUser.currentUserID = 0;
    currentUser.username = username;
    currentUser.password = password;
    currentUser.token = token;
    [_defaultRealm addOrUpdateObject:currentUser];
    [_defaultRealm commitWriteTransaction];
}

- (void)persistFantaisyFromDatas:(NSDictionary *)datas {
    [_defaultRealm beginWriteTransaction];
    
    SPRFantaisy *newFantaisy = [[SPRFantaisy alloc] init];
    newFantaisy.fantaisyID = [datas[@"id"] intValue];
    newFantaisy.title = datas[@"title"];
    newFantaisy.url = datas[@"url"];
    newFantaisy.imgUrl = datas[@"imgUrl"];
    newFantaisy.fantaisyDescription = datas[@"description"];
    [_defaultRealm addOrUpdateObject:newFantaisy];
    [_defaultRealm commitWriteTransaction];
}

- (void)persistNotification:(int)notificationID fantaisyID:(int)fantaisyID isSeen:(BOOL)isSeen date:(NSString *)date {
    [_defaultRealm beginWriteTransaction];
    
    SPRNotification *newNotification = [[SPRNotification alloc] init];
    newNotification.notificationID = notificationID;
    newNotification.fantaisyID = fantaisyID;
    newNotification.isSeen = isSeen;
    newNotification.matchDate = date;
    [_defaultRealm addOrUpdateObject:newNotification];
    
    [_defaultRealm commitWriteTransaction];
}

#pragma mark Others methods

- (void)resetDataBase
{
    [_defaultRealm beginWriteTransaction];
    [_defaultRealm deleteAllObjects];
    [_defaultRealm commitWriteTransaction];
}

@end
