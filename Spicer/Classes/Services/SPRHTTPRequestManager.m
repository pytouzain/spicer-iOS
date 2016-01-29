//
//  HTTPRequestManager.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 29/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "SPRHTTPRequestManager.h"
#import "SPRDataManager.h"

@interface SPRHTTPRequestManager ()

@end

@implementation SPRHTTPRequestManager

#pragma mark Authentification

- (void)signInWithUsername:(NSString *)username password:(NSString *)password
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"username" : username,
                                 @"password" : password,
                                 @"lang" : [[NSLocale preferredLanguages] objectAtIndex:0],
                                 @"extra" : @"",
                                 @"plateform" : @""};

    [manager POST:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"user"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Sign in Success %@", response);
        NSMutableDictionary *persistentsDatas = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        [persistentsDatas addEntriesFromDictionary:response];
         
         if (_delegate && [_delegate respondsToSelector:@selector(signInDidSucceed:)]) {
             [_delegate signInDidSucceed:persistentsDatas];
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Sign in Error : %@", error);
         
         if (_delegate && [_delegate respondsToSelector:@selector(signInDidFail:)]) {
             [_delegate signInDidFail:[NSNumber numberWithInteger:operation.response ? [operation.response statusCode] : error.code]];
         }
     }];
    
}

- (void)signUp:(NSDictionary *)parameters
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"couple"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Sign up Success : %@", response);

        if (_delegate && [_delegate respondsToSelector:@selector(signUpDidSucceed:)]) {
            [_delegate signUpDidSucceed:response];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Sign up Error : %@", error);

        if (_delegate && [_delegate respondsToSelector:@selector(signUpDidFail:)]) {
            [_delegate signUpDidFail:[NSNumber numberWithInteger:operation.response ? [operation.response statusCode] : error.code]];
        }
    }];
}

#pragma mark Fantaisy Seen

- (void)seeFantaisy
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"fantaisySeen"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"See Fantaisy Success : %@", response);

        if (_delegate && [_delegate respondsToSelector:@selector(seeFantaisyDidSucceed:)]) {
            [_delegate seeFantaisyDidSucceed:response];
        }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"See Fantaisy Error : %@", error);

        if (_delegate && [_delegate respondsToSelector:@selector(seeFantaisyDidFail:)]) {
            [_delegate seeFantaisyDidFail:[NSNumber numberWithInteger:[operation.response statusCode]]];
        }
     }];
     
}

- (void)changeStatus:(BOOL)isLiked forFantaisyDatas:(NSDictionary *)fantaisyDatas
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"id":[NSNumber numberWithInt:[[fantaisyDatas objectForKey:@"id"] intValue]], @"status":(isLiked ? @"true" : @"false")};
    
    NSLog(@"Parameters : %@", parameters);
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [manager POST:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"fantaisySeen"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Change Status Success : %@", response);

        NSMutableDictionary *persistentsDatas = [[NSMutableDictionary alloc] initWithDictionary:@{@"currentFantaisy" : fantaisyDatas, @"status" : [NSNumber numberWithBool:isLiked]}];
        [persistentsDatas addEntriesFromDictionary:response];

        if (_delegate && [_delegate respondsToSelector:@selector(changeStatusDidSucceed:)]) {
            [_delegate changeStatusDidSucceed:persistentsDatas];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Change status Error : %@", error);

        if (_delegate && [_delegate respondsToSelector:@selector(changeStatusDidFail:)]) {
            [_delegate changeStatusDidFail:[NSNumber numberWithInteger:[operation.response statusCode]]];
        }
    }];
}

#pragma mark Fantaisy

- (void)getFantaisiesDatas
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    
    [manager GET:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"fantaisy"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Get Fantaisies Datas Success : %@", response);

        if (_delegate && [_delegate respondsToSelector:@selector(getFantaisiesDatasDidSucceed:)]) {
            [_delegate getFantaisiesDatasDidSucceed:response];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get Fantaisies Error : %@", error);
        if (_delegate && [_delegate respondsToSelector:@selector(getFantaisiesDatasDidFail:)]) {
            [_delegate getFantaisiesDatasDidFail:[NSNumber numberWithInteger:[operation.response statusCode]]];
        }
    }];

}

- (void)getFantaisyForID:(int)fantaisyID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[NSString stringWithFormat:@"%@/%@/%d/", API_BASE_URL, @"fantaisy", fantaisyID] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Get Fantaisy : %@", response);

        if (_delegate && [_delegate respondsToSelector:@selector(getFantaisyDidSucceed:)]) {
            [_delegate getFantaisyDidSucceed:response];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get Fantaisy Error : %@", error);

        if (_delegate && [_delegate respondsToSelector:@selector(getFantaisyDidFail:)]) {
            [_delegate getFantaisyDidFail:[NSNumber numberWithInteger:[operation.response statusCode]]];
        }
    }];
}

#pragma mark Notification

- (void)getNotificationsWithPopUp:(BOOL)withPopUp
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"notification"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Get Notifications Success : %@", response);

        NSMutableDictionary *persistentsDatas = [[NSMutableDictionary alloc] initWithDictionary:@{@"withPopUp" : [NSNumber numberWithBool:withPopUp],
                                                                                                  @"notificationsArray" : response}];

        if (_delegate && [_delegate respondsToSelector:@selector(getNotificationsDidSucceed:)]) {
            [_delegate getNotificationsDidSucceed:persistentsDatas];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get Notifications Error : %@", error);

        if (_delegate && [_delegate respondsToSelector:@selector(getNotificationsDidFail:)]) {
            [_delegate getNotificationsDidFail:[NSNumber numberWithInteger:[operation.response statusCode]]];
        }
    }];
}

- (void)setNotificationStatus:(BOOL)isSeen forNotificationID:(int)notificationID
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"id":[NSNumber numberWithInt:notificationID], @"seen" : (isSeen ? @"true" : @"false")};
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [manager PUT:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"notification"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Set Notification Status Success = %@", response);

        NSMutableDictionary *persistentsDatas = [[NSMutableDictionary alloc] initWithDictionary:@{@"notificationID":[NSNumber numberWithInt:notificationID], @"seen" : [NSNumber numberWithBool:isSeen]}];
        [persistentsDatas addEntriesFromDictionary:response];

        if (_delegate && [_delegate respondsToSelector:@selector(setNotificationsStatusDidSucceed:)]) {
            [_delegate setNotificationsStatusDidSucceed:persistentsDatas];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Set Notification Status Error : %@", error);

        if (_delegate && [_delegate respondsToSelector:@selector(setNotificationsStatusDidFail:)]) {
        [_delegate setNotificationsStatusDidFail:[NSNumber numberWithInteger:[operation.response statusCode]]];
        }
    }];
}

#pragma mark Feedback

- (void)sendFeedback:(NSString *)feedback
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"feedback":feedback};
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.token] forHTTPHeaderField:@"Authorization"];

    [manager POST:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"feedback"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Send Feedback Success = %@", response);

        if (_delegate && [_delegate respondsToSelector:@selector(sendFeedbackDidSucceed:)]) {
            [_delegate sendFeedbackDidSucceed:response];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Send Feedback Error : %@", error);

        if (_delegate && [_delegate respondsToSelector:@selector(sendFeedbackDidFail:)]) {
            [_delegate sendFeedbackDidFail:[NSNumber numberWithInteger:[operation.response statusCode]]];
        }
    }];
}

- (void)getFeedback
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [manager GET:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"feedback"] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {

    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Get Feedback Success = %@", response);

        if (_delegate && [_delegate respondsToSelector:@selector(getFeedBackDidSucceed:)]) {
            [_delegate getFeedBackDidSucceed:response];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Get Feedback Error : %@", error);

        if (_delegate && [_delegate respondsToSelector:@selector(getFeedBackDidFail:)]) {
            [_delegate getFeedBackDidFail:[NSNumber numberWithInteger:[operation.response statusCode]]];
        }
    }];
}

#pragma mark Settings

- (void)changeSettingType:(int)type withData:(int)data {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *parameters = @{@"type":[NSNumber numberWithInt:type], @"data":[NSNumber numberWithInt:data]};
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@", self.token] forHTTPHeaderField:@"Authorization"];
    
    [manager PUT:[NSString stringWithFormat:@"%@/%@/", API_BASE_URL, @"settings"] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"Change Setting Success = %@", response);
        NSMutableDictionary *persistentsDatas = [[NSMutableDictionary alloc] initWithDictionary:@{@"settingType" : [NSNumber numberWithInt:type], @"settingData" : [NSNumber numberWithInt:data]}];
        [persistentsDatas addEntriesFromDictionary:response];

        if (_delegate && [_delegate respondsToSelector:@selector(changeSettingDidSucceed:)]) {
            [_delegate changeSettingDidSucceed:persistentsDatas];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Change Setting Error : %@", error);

        if (_delegate && [_delegate respondsToSelector:@selector(changeSettingDidFail:)]) {
            [_delegate changeSettingDidFail:[NSNumber numberWithInteger:[operation.response statusCode]]];
        }
    }];
}

@end
