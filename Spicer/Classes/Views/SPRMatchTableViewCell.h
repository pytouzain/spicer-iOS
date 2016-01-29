//
//  MatchTableViewCell.h
//  Spicer
//
//  Created by Pierre-Yves Touzain on 18/02/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SPRMatchCellViewModel.h"
#import "SPRFantaisy.h"

@interface SPRMatchTableViewCell : UITableViewCell <SPRViewModelDelegate>

@property (nonatomic, strong) SPRMatchCellViewModel *viewModel;

- (void)configureCell;

@end
