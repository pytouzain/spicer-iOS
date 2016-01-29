//
//  FantaisiesViewController.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 05/12/2014.
//  Copyright (c) 2014 Spicer. All rights reserved.
//

#import <Realm/Realm.h>
#import <AFNetworking/UIImageView+AFNetworking.h>

#import "SPRFantaisiesViewController.h"
#import "SPRMatchesTableViewController.h"
#import "SPRMatchesViewModel.h"
#import "SPRSettingsViewController.h"
#import "SPRSettingsViewModel.h"
#import "SPRFantaisyViewController.h"
#import "SPRFantaisyViewModel.h"

#import "SPRFantaisy.h"

@interface SPRFantaisiesViewController ()

@property (nonatomic, weak) IBOutlet UIImageView *currentFantaisyImage;

@property (weak, nonatomic) IBOutlet UIView *matchViewBackground;
@property (weak, nonatomic) IBOutlet UIView *matchView;
@property (weak, nonatomic) IBOutlet UILabel *matchLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleMatchFantaisy;

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *dislikeButton;
@property (weak, nonatomic) IBOutlet UILabel *currentFantaisyText;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewConstraint;

@property (nonatomic, strong) UILabel *timerLabel;
@property (nonatomic, strong) UILabel *endOfMatchesLabel;
@property (nonatomic, strong) NSTimer *timer;

@property (assign) NSUInteger index;

@end

@implementation SPRFantaisiesViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.viewModel = [[SPRFantaisiesViewModel alloc] init];
        self.viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _index = 0;
    
    [_viewModel loadViewModel];
    
    UIImage *imageButtonLeft = [[UIImage imageNamed:@"settings_tmp"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:imageButtonLeft
                                                                         style:UIBarButtonItemStylePlain target:self action:@selector(showSettings)];
    
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor grayColor]];
    
    UIImage *imageButtonRight = [[UIImage imageNamed:@"link"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithImage:imageButtonRight
                                                                              style:UIBarButtonItemStylePlain target:self action:@selector(showMatches)];
    
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor grayColor]];
    
    _likeButton.layer.masksToBounds = YES;
    _likeButton.layer.cornerRadius= _likeButton.frame.size.height / 2.f;

    _dislikeButton.layer.masksToBounds = YES;
    _dislikeButton.layer.cornerRadius= _dislikeButton.frame.size.height / 2.f;
    
    _infoButton.layer.masksToBounds = YES;
    _infoButton.layer.cornerRadius = _infoButton.frame.size.height / 2.f;
    _infoButton.layer.borderColor = [[UIColor grayColor] CGColor];
    _infoButton.layer.borderWidth = 2.0f;
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"spicer-small"]];
    self.navigationItem.titleView = logo;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMatchPopUp)];
    gesture.numberOfTapsRequired = 1;
    gesture.numberOfTouchesRequired = 1;
    
    [_matchView addGestureRecognizer:gesture];
    
    _matchLabel.text = NSLocalizedString(@"It's a match", nil);

   // [_descriptionTextView setBackgroundColor:[UIColor blueColor]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *imageButtonRight;
    
    if (self.viewModel.unseenNotification == YES)
        imageButtonRight = [[UIImage imageNamed:@"link_notif"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    else
        imageButtonRight = [[UIImage imageNamed:@"link"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem.image = imageButtonRight;
}

- (void)showMatches
{
   [self performSegueWithIdentifier:@"showMatchesSegueIdentifier" sender:nil];
}

- (void)showSettings
{
    [self performSegueWithIdentifier:@"showSettingsSegueIdentifier" sender:nil];
}

- (void)displayFantaisyWithDatas:(NSDictionary *)fantaisyDatas
{
    NSURL *url = [NSURL URLWithString:[fantaisyDatas objectForKey:@"imgUrl"]];
    
    [_currentFantaisyImage cancelImageRequestOperation];
    [_currentFantaisyImage setImage:nil];
    [_currentFantaisyImage setImageWithURL:url];
    
    _currentFantaisyText.text = [fantaisyDatas objectForKey:@"title"];
    _descriptionTextView.text = [fantaisyDatas objectForKey:@"description"];
}

- (IBAction)setLikedStatus:(id)sender
{
    _likeButton.userInteractionEnabled = NO;
    _dislikeButton.userInteractionEnabled = NO;
    [self.viewModel changeStatusForCurrentFantaisy:(((UIButton *)sender).tag == 0 ? NO : YES)];
}

- (IBAction)getMoreInfos:(id)sender
{
    SPRFantaisyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"fantaisyViewController"];
    SPRFantaisyViewModel *viewModel = [[SPRFantaisyViewModel alloc] initWithFantaisy:[self.viewModel getCurrentFantaisyObject]];
    vc.viewModel = viewModel;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark View Model Delegate Methods

- (void)viewModelLoadingSuccess {
    [self displayFantaisyWithDatas:self.viewModel.currentFantaisyDatas];
}

- (void)viewModelLoadingFailure {
    NSLog(@"%@", self.viewModel.errorMessage);
}

- (void)changeStatusSuccess {
    _likeButton.userInteractionEnabled = YES;
    _dislikeButton.userInteractionEnabled = YES;
    [self displayFantaisyWithDatas:self.viewModel.currentFantaisyDatas];
}

- (void)changeStatusFailWithStatusCode:(NSInteger)statusCode {
    NSLog(@"%@", self.viewModel.errorMessage);
    if (statusCode == 400) {
        [self activateTooMuchMatchesMode];
    }
    else {
        _likeButton.userInteractionEnabled = YES;
        _dislikeButton.userInteractionEnabled = YES;
    }
}

- (void)getNotificationsSuccessWithPopUp:(BOOL)withPopUp matchedFantaisy:(SPRFantaisy *)fantaisy {
    UIImage *imageButtonRight;
    
    if (self.viewModel.unseenNotification == YES)
        imageButtonRight = [[UIImage imageNamed:@"link_notif"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    else
        imageButtonRight = [[UIImage imageNamed:@"link"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.rightBarButtonItem.image = imageButtonRight;
    
    if (withPopUp) {
        [self showMatchPopUpWithFantaisy:fantaisy];
    }
}

- (void)getNotificationsFail {
    NSLog(@"%@", self.viewModel.errorMessage);
}

#pragma mark Match PopUp Methods

- (void)showMatchPopUpWithFantaisy:(SPRFantaisy *)fantaisy {
    _titleMatchFantaisy.text = fantaisy.title;
    _matchViewBackground.hidden = NO;
    _matchView.hidden = NO;
    
}

- (void)dismissMatchPopUp {
    _matchViewBackground.hidden = YES;
    _matchView.hidden = YES;
}

#pragma mark Manage Description Methods

- (IBAction)manageDescription:(id)sender
{
    _infoButton.userInteractionEnabled = NO;
    if (_infoButton.tag == 0) {
        [self showDescriptionWithOffset:65];
    }
    else {
        [self hideDescriptionWithOffset:65];
    }
}

- (void)showDescriptionWithOffset:(CGFloat)offset {
    _topViewConstraint.constant -= offset;
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            _descriptionTextView.alpha = 1.0;
        } completion:^(BOOL finished) {
            _infoButton.tag = 1;
            _infoButton.userInteractionEnabled = YES;
        }];
    }];
}

- (void)hideDescriptionWithOffset:(CGFloat)offset {
    [UIView animateWithDuration:0.4 animations:^{
        _descriptionTextView.alpha = 0.0;
    } completion:^(BOOL finished) {
        _topViewConstraint.constant += offset;
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            _infoButton.tag = 0;
            _infoButton.userInteractionEnabled = YES;
        }];
    }];
}

#pragma mark Too Much Match Methods

- (void)refreshTimerLabel {
    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSIntegerMax fromDate:date];
    
    _timerLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)(23 - components.hour), (long)(59 - components.minute), (long)(59 - components.second)];
    
    if ((23 - components.hour) == 0 && (59 - components.minute) == 0 && (59 - components.second) == 0) {
        [self desactivateTooMuchMatchesMode];
    }
}

- (void)activateTooMuchMatchesMode {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeStatusFailed" object:nil];
    _timerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, (_currentFantaisyImage.frame.size.height / 2) - 20, _currentFantaisyImage.frame.size.width, 40)];
    _timerLabel.textAlignment = NSTextAlignmentCenter;
    _timerLabel.font = [UIFont fontWithName:@"Helvetica" size:40.0];
    _timerLabel.textColor = kSpicerColorDarkRed;
    _currentFantaisyImage.image = nil;
    [_currentFantaisyImage addSubview:_timerLabel];
    
    _endOfMatchesLabel = [[UILabel alloc] initWithFrame:_currentFantaisyText.frame];
    _endOfMatchesLabel.numberOfLines = 0;
    _endOfMatchesLabel.textAlignment = NSTextAlignmentCenter;
    _endOfMatchesLabel.font = _currentFantaisyText.font;
    _endOfMatchesLabel.textColor = kSpicerColorDarkRed;
    [self.view addSubview:_endOfMatchesLabel];
    
    _likeButton.userInteractionEnabled = NO;
    _dislikeButton.userInteractionEnabled = NO;
    
    NSString *endOfMatchesString = NSLocalizedString(@"You swiped all the inspirations of Spicer. Come back for more tomorrow. Until then, you’ve got stuff to do ;-)", nil);
    
    CGFloat labelHeight = [endOfMatchesString boundingRectWithSize:CGSizeMake(_endOfMatchesLabel.frame.size.width, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : _endOfMatchesLabel.font} context:nil].size.height;
    
    CGRect labelFrame = _endOfMatchesLabel.frame;
    labelFrame.size.height = labelHeight;
    _endOfMatchesLabel.frame = labelFrame;
    
    _endOfMatchesLabel.text = endOfMatchesString;
    
    _infoButton.hidden = YES;
    
    [self refreshTimerLabel];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshTimerLabel) userInfo:nil repeats:YES];
}

- (void)desactivateTooMuchMatchesMode {
    [_timerLabel removeFromSuperview];
    [_endOfMatchesLabel removeFromSuperview];
    
    _likeButton.userInteractionEnabled = YES;
    _dislikeButton.userInteractionEnabled = YES;
    
    [self displayFantaisyWithDatas:self.viewModel.currentFantaisyDatas];
    
    _infoButton.hidden = NO;
    
    [_timer invalidate];
}

#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showMatchesSegueIdentifier"]) {
        SPRMatchesTableViewController *vc = (SPRMatchesTableViewController *)[segue destinationViewController];
        SPRMatchesViewModel *viewModel = [[SPRMatchesViewModel alloc] init];
        viewModel.delegate = vc;
        vc.viewModel = viewModel;
    }
    else if ([segue.identifier isEqualToString:@"showSettingsSegueIdentifier"]) {
        SPRSettingsViewController *vc = (SPRSettingsViewController *)[segue destinationViewController];
        SPRSettingsViewModel *viewModel = [[SPRSettingsViewModel alloc] init];
        viewModel.delegate = vc;
        vc.viewModel = viewModel;
    }
}


@end
