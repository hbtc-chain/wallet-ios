//
//  XXScreenShotAlert.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXScreenShotAlert.h"

@interface XXScreenShotAlert()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIImageView *screenShotImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *okBtn;

@end

@implementation XXScreenShotAlert

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)buildUI {
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.dismissBtn];
    [self.contentView addSubview:self.screenShotImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.okBtn];
}
+ (void)showWithSureBlock:(void (^)(void))sureBlock {
    
    XXScreenShotAlert *alert = [[XXScreenShotAlert alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    [alert buildUI];
    alert.sureBlock = sureBlock;
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - 248;
    } completion:^(BOOL finished) {
       
    }];
}


+ (void)dismiss {
    XXScreenShotAlert *view = (XXScreenShotAlert *)[self currentView];
    if (view) {
        [UIView animateWithDuration:0.25 animations:^{
            view.contentView.top = kScreen_Height;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                view.backView.alpha = 0;
                view.contentView.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }];
    }
}

+ (UIView *)currentView {
    for (UIView *view in [KWindow subviews]) {
        if ([view isKindOfClass:[self class]]) {
            return view;
        }
    }
    return nil;
}

- (void)okAction {
    if (self.sureBlock) {
        self.sureBlock();
    }
    [[self class] dismiss];
}

- (void)cancelAction {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [[self class] dismiss];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _backView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 248, kScreen_Width, 248)];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}

- (UIImageView *)screenShotImageView {
    if (_screenShotImageView == nil) {
        _screenShotImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreen_Width-64)/2, 24, 64, 64)];
        _screenShotImageView.image = [UIImage imageNamed:@"ScreenShot"];
    }
    return _screenShotImageView;
}

- (UIButton *)dismissBtn {
    if (_dismissBtn == nil ) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - K375(50), 0, K375(50), K375(50))];
        [_dismissBtn setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 104, kScreen_Width - 32, 24)];
        _titleLabel.text = LocalizedString(@"NoScreenShot");
        _titleLabel.font = kFontBold18;
        _titleLabel.textColor = kDark100;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 132, kScreen_Width - 32, 18)];
        _contentLabel.text = LocalizedString(@"ScreenShotTip");
        _contentLabel.font = kFont14;
        _contentLabel.textColor = kDark50;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.numberOfLines = 0;
    }
    return _contentLabel;
}

//- (XYHNumbersLabel *)contentLabel {
//    if (_contentLabel ==nil) {
//        _contentLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.titleLabel.frame) + 6, self.versionView.width - K375(48), 10) font:kFont14];
//        _contentLabel.textAlignment = NSTextAlignmentLeft;
//        _contentLabel.textColor = [UIColor blackColor];
//    }
//    return _contentLabel;
//}

- (UIButton *)okBtn {
    if (_okBtn == nil) {
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(K375(16), self.contentView.height - 64, kScreen_Width - K375(32), kBtnHeight)];
        [_okBtn setTitle:LocalizedString(@"IKnow") forState:UIControlStateNormal];
        [_okBtn setBackgroundColor:kBlue100];
        [_okBtn.titleLabel setFont:kFontBold18];
        _okBtn.layer.cornerRadius = kBtnBorderRadius;
        _okBtn.layer.masksToBounds = YES;
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

@end
