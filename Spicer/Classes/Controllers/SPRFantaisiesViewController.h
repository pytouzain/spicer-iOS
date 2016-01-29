//
//  FantaisiesViewController.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 05/12/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SPRFantaisiesViewModel.h"

@interface SPRFantaisiesViewController : UIViewController <SPRFantaisiesViewModelDelegate>

@property (nonatomic, strong) SPRFantaisiesViewModel *viewModel;

@end
