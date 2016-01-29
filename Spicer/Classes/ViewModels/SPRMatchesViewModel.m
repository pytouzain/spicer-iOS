//
//  SPRMatchesViewModel.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRMatchesViewModel.h"
#import "SPRRequestHandler.h"

@implementation SPRMatchesViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNotificationsStatusSuccess:) name:@"setNotificationsStatusSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNotificationsStatusFail:) name:@"setNotificationsStatusFail" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationsSuccess:) name:@"getNotificationsSuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotificationsFail:) name:@"getNotificationsFail" object:nil];
    }
    return self;
}

- (NSUInteger)notificationsNumber {
    return [[SPRRequestHandler sharedHandler] getNotificationsNumber];
}

- (void)updateNotificationStatus:(BOOL)status forIndexPath:(NSIndexPath *)indexPath {
    SPRNotification *notification = [[SPRRequestHandler sharedHandler] fetchNotificationForIndex:indexPath.row];
    [[SPRRequestHandler sharedHandler] setNotificationStatus:status forNotificationID:notification.notificationID];
}

- (SPRMatchCellViewModel *)matchViewModelForIndexPath:(NSIndexPath *)indexPath {
    return [[SPRMatchCellViewModel alloc] initWithNotification:[[SPRRequestHandler sharedHandler] fetchNotificationForIndex:indexPath.row]];
}

- (SPRFantaisyViewModel *)fantaisyViewModelForIndexPath:(NSIndexPath *)indexPath {
    SPRNotification *notification = [[SPRRequestHandler sharedHandler] fetchNotificationForIndex:indexPath.row];
    SPRFantaisy *fantaisy = [[SPRRequestHandler sharedHandler] fetchFantaisyForID:notification.fantaisyID];
    return [[SPRFantaisyViewModel alloc] initWithFantaisy:fantaisy];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark NSNotificationCenter Selectors

- (void)setNotificationsStatusSuccess:(NSNotification *)notification {
    
}

- (void)setNotificationsStatusFail:(NSNotification *)notification {
    
}

- (void)getNotificationsSuccess:(NSNotification *)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getNotificationSuccess)]) {
        [self.delegate getNotificationSuccess];
    }
}

- (void)getNotificationsFail:(NSNotification *)notification
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(getNotificationFail)]) {
        [self.delegate getNotificationFail];
    }
}

@end
