//
//  SPRHomeViewModel.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 24/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPRCurrentUser.h"

@interface SPRHomeViewModel : NSObject

@property (nonatomic, strong) SPRCurrentUser *currentUser;

@end
