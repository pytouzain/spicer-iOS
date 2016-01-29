//
//  NotificationPushView.m
//  Spicer
//
//  Created by Pierre-Yves Touzain on 07/06/2015.
//  Copyright (c) 2015 Spicer. All rights reserved.
//

#import "SPRNotificationPushView.h"

#define kAnimationDuration      0.3f
#define kHideNotificationDelay  2

@interface SPRNotificationPushView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation SPRNotificationPushView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, frame.size.width - 20, frame.size.height - 10)];
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:24]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [self addSubview:_titleLabel];
        
        [self setBackgroundColor:kSpicerColorDarkRed];
    }
    
    return self;
}

- (void)setTitle:(NSString *)title {
    _titleLabel.text = title;
}

- (void)showNotification {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y += frame.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideNotification) withObject:nil afterDelay:kHideNotificationDelay];
    }];
}

- (void)hideNotification {
    [UIView animateWithDuration:kAnimationDuration animations:^{
        CGRect frame = self.frame;
        frame.origin.y -= frame.size.height;
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
   }

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
