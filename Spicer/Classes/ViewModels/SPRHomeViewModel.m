//
//  SPRHomeViewModel.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRHomeViewModel.h"
#import "SPRRequestHandler.h"

@implementation SPRHomeViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentUser = [[SPRRequestHandler sharedHandler] fetchCurrentUser];
    }
    return self;
}

@end
