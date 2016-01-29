//
//  User.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 21/11/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <Realm/Realm.h>

#import "SPRPersonalData.h"

@interface SPRUser : RLMObject

@property int userID;
@property NSString *language;
@property NSString *plateform;
@property SPRPersonalData *personalData;

@end
