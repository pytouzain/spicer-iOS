//
//  SPRFantaisyViewModel.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPRViewModel.h"
#import "SPRFantaisy.h"

@interface SPRFantaisyViewModel : SPRViewModel

@property (nonatomic, strong) SPRFantaisy *fantaisy;

- (instancetype)initWithFantaisy:(SPRFantaisy *)fantaisy;

@end
