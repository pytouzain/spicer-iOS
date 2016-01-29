//
//  MatchTableViewCell.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 18/02/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SPRMatchTableViewCell.h"
#import "SPRDataManager.h"

@interface SPRMatchTableViewCell ()

@property (nonatomic, weak) IBOutlet UIView *imageBackground;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UILabel *fantaisyName;
@property (nonatomic, weak) IBOutlet UILabel *status;

@end

@implementation SPRMatchTableViewCell

- (void)awakeFromNib {
    _imageBackground.layer.masksToBounds = YES;
    _imageBackground.layer.cornerRadius = _imageBackground.frame.size.height / 2.f;
    _imageBackground.layer.borderColor = [[UIColor grayColor] CGColor];
    _imageBackground.layer.borderWidth = 2.0f;
}

- (void)configureCell {
    self.viewModel.delegate = self;
    [self.viewModel loadViewModel];
}

- (void)markCellAsSelected {
    NSDate *today = [NSDate date];
    NSLocale *locale = [NSLocale currentLocale];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"d/MM/yyyy" options:0 locale:locale];
    [formatter setDateFormat:dateFormat];
    [formatter setLocale:locale];
    
    self.backgroundColor = [UIColor whiteColor];
    _fantaisyName.textColor = kSpicerColorDarkRed;
    _status.textColor = kSpicerColorDarkRed;
    _status.text = [formatter stringFromDate:today];
}

- (void)markCellAsUnselected {
    self.backgroundColor = kSpicerColorDarkRed;
    _fantaisyName.textColor = [UIColor whiteColor];
    _status.textColor = [UIColor whiteColor];
    _status.text = NSLocalizedString(@"New", nil);
}


#pragma mark - SPRViewModel Delegate Methods

- (void)viewModelLoadingSuccess {
    _fantaisyName.text = self.viewModel.fantaisy.title;
    
    [_image cancelImageRequestOperation];
    [_image setImage:nil];
    [_image setImageWithURL:[NSURL URLWithString:self.viewModel.fantaisy.imgUrl]];
    
    if ([self.viewModel isNotificationSeen])
        [self markCellAsSelected];
    else
        [self markCellAsUnselected];
}

- (void)viewModelLoadingFailure {
    
}

@end
