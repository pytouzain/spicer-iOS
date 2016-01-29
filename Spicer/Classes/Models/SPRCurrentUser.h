//
//  CurrentUser.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 04/12/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import "RLMObject.h"

@interface SPRCurrentUser : RLMObject

@property int currentUserID;
@property NSString *username;
@property NSString *password;
@property NSString *token;

@end
