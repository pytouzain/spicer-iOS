//
//  SPRMatchCellViewModel.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 28/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRMatchCellViewModel.h"
#import "SPRRequestHandler.h"

@interface SPRMatchCellViewModel ()

@property (nonatomic, strong) SPRNotification *notification;

@end

@implementation SPRMatchCellViewModel

- (instancetype)initWithNotification:(SPRNotification *)notification {
    self = [super init];
    if (self) {
        self.notification = notification;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFantaisySuccess:) name:@"getFantaisySuccess" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFantaisyFail:) name:@"getFantaisyFail" object:nil];
    }
    return self;
}

- (void)loadViewModel {
    self.fantaisy = [[SPRRequestHandler sharedHandler] fetchFantaisyForID:self.notification.fantaisyID];
    if (!self.fantaisy) {
        [[SPRRequestHandler sharedHandler] getFantaisyForID:self.notification.fantaisyID];
    }
    else {
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelLoadingSuccess)]) {
            [self.delegate viewModelLoadingSuccess];
        }
    }
}

- (BOOL)isNotificationSeen {
    return self.notification.isSeen;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark NSNotificationCenter Selectors

- (void)getFantaisySuccess:(NSNotification *)notification {
    self.fantaisy = [[SPRRequestHandler sharedHandler] fetchFantaisyForID:self.notification.fantaisyID];
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelLoadingSuccess)]) {
        [self.delegate viewModelLoadingSuccess];
    }
}

- (void)getFantaisyFail:(NSNotification *)notification {
    if (self.delegate && [self.delegate respondsToSelector:@selector(viewModelLoadingFailure)]) {
        [self.delegate viewModelLoadingFailure];
    }
}

@end
