//
//  Couple.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 22/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import "RLMObject.h"
#import "SPRUser.h"

@interface SPRCouple : RLMObject

@property int coupleID;
@property SPRUser *user1;
@property SPRUser *user2;

@end
