//
//  SPRFantaisyViewModel.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRFantaisyViewModel.h"

@implementation SPRFantaisyViewModel

- (instancetype)initWithFantaisy:(SPRFantaisy *)fantaisy {
    self = [super init];
    if (self) {
        self.fantaisy = fantaisy;
    }
    return self;
}

@end
