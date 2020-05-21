//
//  XXSplashScreen.m
//  Bhex
//
//  Created by Bhex on 2019/11/17.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXSplashScreen.h"

@interface XXSplashScreen () {
    dispatch_source_t _timer;
}

/** 倒计时 */
@property (assign, nonatomic) NSInteger timeCount;

/** icon */
@property (strong, nonatomic, nullable) UIImageView *iconImageView;


@end

@implementation XXSplashScreen

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self initData];
        [self setupCurrentLaunchPage];
    }
    return self;
}

- (void)initData {
    self.timeCount = 2;
}

- (void)setupCurrentLaunchPage {
    [self addSubview:self.iconImageView];
    
    NSString *language = [[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode];
    UIImage *logoImage = [UIImage imageNamed:@"LaunchDefault"]; // 默认
    if ([language isEqualToString:@"zh-CN"] && [UIImage imageNamed:@"LaunchZH-CN"]) { // 中文
        logoImage = [UIImage imageNamed:@"LaunchZH-CN"];
    } else if ([language isEqualToString:@"ko-kr"] && [UIImage imageNamed:@"LaunchKO-KR"]) { // 韩文
        logoImage = [UIImage imageNamed:@"LaunchKO-KR"];
    } else if ([language isEqualToString:@"vi-VN"] && [UIImage imageNamed:@"LaunchVI-VN"]) { // 越南
        logoImage = [UIImage imageNamed:@"LaunchVI-VN"];
    } else if ([language isEqualToString:@"ja-jp"] && [UIImage imageNamed:@"LaunchJA-JP"]) { // 日语
        logoImage = [UIImage imageNamed:@"LaunchJA-JP"];
    } else if ([language isEqualToString:@"tr"] && [UIImage imageNamed:@"LaunchTR"]) { // 土耳其
        logoImage = [UIImage imageNamed:@"LaunchTR"];
    }
    if (logoImage) {
        self.iconImageView.image = logoImage;
    }
}

- (void)showSplashScreen {
    [KWindow addSubview:self];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self clearSplashScreen];
    });
}

- (void)clearSplashScreen {
    [UIView animateWithDuration:0.6f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:self.frame];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

@end
