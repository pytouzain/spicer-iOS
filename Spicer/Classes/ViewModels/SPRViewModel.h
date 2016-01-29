//
//  SPRViewModel.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 26/07/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SPRViewModelDelegate <NSObject>

@optional
- (void)viewModelLoadingSuccess;
- (void)viewModelLoadingFailure;

@end

@interface SPRViewModel : NSObject

- (void)loadViewModel;

@end
