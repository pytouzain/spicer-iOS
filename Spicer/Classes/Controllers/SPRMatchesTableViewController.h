//
//  MatchesTableViewController.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 11/12/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPRMatchesViewModel.h"

@interface SPRMatchesTableViewController : UITableViewController <SPRMatchesViewModelDelegate>

@property (nonatomic, strong) SPRMatchesViewModel *viewModel;

@end
