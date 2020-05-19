//
//  XXRewardView.m
//  Bluehelix
//
//  Created by BHEX on 2020/4/26.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXRewardView.h"
#import "XYHNumbersLabel.h"

@interface XXRewardView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel;
@property (nonatomic, strong) XXButton *sureButton;
@property (nonatomic, strong) XXButton *okButton;
@property (nonatomic, strong) XXButton *cancelButton;

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic,copy) void (^sureBlock)(void);
@end

@implementation XXRewardView

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
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.okButton];
    [self.contentView addSubview:self.cancelButton];
}

+ (void)showWithTitle:(NSString *)title icon:(NSString *)icon content:(NSString *)content sureBlock:(void (^)(void))sureBlock {
    
    XXRewardView *alert = [[XXRewardView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    alert.title = title;
    alert.iconName = icon;
    alert.content = content;
    alert.sureBlock = sureBlock;
    [KWindow addSubview:alert];
    [alert buildUI];
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.6;
        alert.contentView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    } completion:^(BOOL finished) {
       [UIView animateWithDuration:0.1 animations:^{
           alert.contentView.transform = CGAffineTransformIdentity;
       }];
    }];
}

+ (void)dismiss {
    XXRewardView *view = (XXRewardView *)[self currentView];
    if (view) {
            [UIView animateWithDuration:0.2 animations:^{
                view.backView.alpha = 0;
                view.contentView.alpha = 0;
                view.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
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

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _backView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), (kScreen_Height - 280)/2, kScreen_Width - K375(48), 280)];
        _contentView.backgroundColor = kIsNight ? [UIColor colorWithHexString:@"#222D42"] : [UIColor whiteColor];
        _contentView.layer.cornerRadius = kBtnBorderRadius;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake((self.contentView.width - 72)/2, 32, 72, 72)];
        _icon.image = [UIImage imageNamed:self.iconName];
    }
    return _icon;
}

- (XXLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.icon.frame) +8, self.contentView.width, 24) text:self.title font:kFontBold20 textColor:kGray900];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (XYHNumbersLabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(self.titleLabel.frame) + 16, self.contentView.width - 48, 0) font:kFont15];
        _contentLabel.text = self.content;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.textColor = kGray700;
    }
    return _contentLabel;
}

- (XXButton *)okButton {
    if (_okButton == nil) {
        MJWeakSelf
        _okButton = [XXButton buttonWithFrame:CGRectMake(self.contentView.width/2 + K375(4), self.contentView.height - K375(56), (self.contentView.width - K375(40))/2, K375(44)) title:LocalizedString(@"Sure") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf okAction];
        }];
        _okButton.layer.cornerRadius = 4;
        _okButton.layer.masksToBounds = YES;
        _okButton.backgroundColor = kPrimaryMain;
    }
    return _okButton;
}

- (XXButton *)cancelButton {
    if (_cancelButton == nil) {
        MJWeakSelf
        _cancelButton = [XXButton buttonWithFrame:CGRectMake(K375(16), self.contentView.height - K375(56), (self.contentView.width - K375(40))/2, K375(44)) title:LocalizedString(@"Cancel") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [[weakSelf class] dismiss];
        }];
        _cancelButton.layer.cornerRadius = 4;
        _cancelButton.layer.masksToBounds = YES;
        _cancelButton.backgroundColor = kGray200;
    }
    return _cancelButton;
}

@end
