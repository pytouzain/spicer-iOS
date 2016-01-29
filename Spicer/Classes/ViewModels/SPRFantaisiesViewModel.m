//
//  SPRFantaisiesViewModel.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRFantaisiesViewModel.h"
#import "SPRRequestHandler.h"

@interface SPRFantaisiesViewModel ()

@end

@implementation SPRFantaisiesViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seeFantaisySuccess:) name:@"seeFantaisySuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(seeFantaisyFail:) name:@"seeFantaisyFail" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusSuccess:) name:@"changeStatusSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatusFail:) name:@"changeStatusFail" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationsSuccess:) name:@"getNotificationsSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationsFail:) name:@"getNotificationsFail" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadViewModel {
    [[SPRRequestHandler sharedHandler] getCurrentFantaisy];
    [[SPRRequestHandler sharedHandler] getNotificationsWithPopUp:NO];
}

- (void)changeStatusForCurrentFantaisy:(BOOL)newStatus {
    [[SPRRequestHandler sharedHandler] changeStatus:newStatus forFantaisyDatas:self.currentFantaisyDatas];
}

- (BOOL)unseenNotification {
    return [[SPRRequestHandler sharedHandler] isThereUnseenNotification];
}

- (SPRFantaisy *)getCurrentFantaisyObject {
    SPRFantaisy *fantaisy = [[SPRFantaisy alloc] init];
    fantaisy.fantaisyID = [self.currentFantaisyDatas[@"id"] intValue];
    fantaisy.title = self.currentFantaisyDatas[@"title"];
    fantaisy.url = self.currentFantaisyDatas[@"url"];
    fantaisy.imgUrl = self.currentFantaisyDatas[@"imgUrl"];
    fantaisy.fantaisyDescription = self.currentFantaisyDatas[@"description"];
    return fantaisy;
}

#pragma mark -
#pragma mark NSNotificationCenter Selectors

- (void)seeFantaisySuccess:(NSNotification *)notification
{
    self.currentFantaisyDatas = (NSDictionary *)notification.object;
    if ([self.currentFantaisyDatas count]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelLoadingSuccess)]) {
            [self.delegate viewModelLoadingSuccess];
        }
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeStatusFailWithStatusCode:)]) {
            [self.delegate changeStatusFailWithStatusCode:400];
        }
    }
}

- (void)seeFantaisyFail:(NSNotification *)notification
{
    self.errorMessage = @"Error See Fantaisy";
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelLoadingFailure)]) {
        [self.delegate viewModelLoadingFailure];
    }
}

- (void)changeStatusSuccess:(NSNotification *)notification
{
    self.currentFantaisyDatas = (NSDictionary *)notification.object;
    [[SPRRequestHandler sharedHandler] getNotificationsWithPopUp:YES];
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeStatusSuccess)]) {
        [self.delegate changeStatusSuccess];
    }
}

- (void)changeStatusFail:(NSNotification *)notification
{
    self.errorMessage = @"Error Change Status";
    NSNumber *statusCode = (NSNumber *)notification.object;
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeStatusFailWithStatusCode:)]) {
        [self.delegate changeStatusFailWithStatusCode:[statusCode integerValue]];
    }
}

- (void)getNotificationsSuccess:(NSNotification *)notification
{
    NSDictionary *response = (NSDictionary *)notification.object;
    
    SPRFantaisy *matchedFantaisy = nil;
    
    if ([[response objectForKey:@"withPopUp"] boolValue]) {
        matchedFantaisy = [response objectForKey:@"matchedFantaisy"];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(getNotificationsSuccessWithPopUp:matchedFantaisy:)]) {
        [self.delegate getNotificationsSuccessWithPopUp:(matchedFantaisy ? YES : NO) matchedFantaisy:matchedFantaisy];
    }
}

- (void)getNotificationsFail:(NSNotification *)notification
{
    self.errorMessage = @"Error Get Notifications";
    if (self.delegate && [self.delegate respondsToSelector:@selector(getNotificationsFail)]) {
        [self.delegate getNotificationsFail];
    }
}


@end
