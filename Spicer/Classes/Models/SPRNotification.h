//
//  SPRNotification.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 27/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "RLMObject.h"

@interface SPRNotification : RLMObject

@property int notificationID;
@property int fantaisyID;
@property BOOL isSeen;
@property NSString *matchDate;

@end
