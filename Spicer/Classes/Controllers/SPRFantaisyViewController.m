//
//  FantaisyViewController.m
//  Spicer
//
//  Created by Pierre-Yves on 13/03/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import <AFNetworking/UIImageView+AFNetworking.h>
#import "SPRFantaisyViewController.h"

@interface SPRFantaisyViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *fantaisyImageView;
@property (nonatomic, weak) IBOutlet UILabel *fantaisyTitle;
@property (nonatomic, weak) IBOutlet UITextView *fantaisyDescription;
@property (weak, nonatomic) IBOutlet UIButton *moreDetailsButton;

@end

@implementation SPRFantaisyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fantaisyTitle.text = self.viewModel.fantaisy.title;
    _fantaisyDescription.text = self.viewModel.fantaisy.fantaisyDescription;
    
    [_moreDetailsButton setTitle:NSLocalizedString(@"More", nil) forState:UIControlStateNormal];
    
    [_fantaisyImageView cancelImageRequestOperation];
    [_fantaisyImageView setImage:nil];
    [_fantaisyImageView setImageWithURL:[NSURL URLWithString:self.viewModel.fantaisy.imgUrl]];
}

- (IBAction)moreDetailsButtonClicked:(id)sender {
    NSURL *url;
    if ([self.viewModel.fantaisy.url rangeOfString:@"http://"].location == NSNotFound) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", self.viewModel.fantaisy.url]];
    }
    else {
        url = [NSURL URLWithString:self.viewModel.fantaisy.url];
    }
    [[UIApplication sharedApplication] openURL:url];
}


@end
