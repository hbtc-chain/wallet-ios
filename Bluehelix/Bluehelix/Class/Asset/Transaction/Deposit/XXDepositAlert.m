//
//  XXDepositAlert.m
//  Bluehelix
//
//  Created by BHEX on 2020/4/25.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXDepositAlert.h"
#import "XYHNumbersLabel.h"

@interface XXDepositAlert ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) XYHNumbersLabel *contentLabel;
@property (nonatomic, strong) XXButton *sureButton;
@property (nonatomic, copy) NSMutableAttributedString *message;
@end

@implementation XXDepositAlert

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
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.sureButton];
}

+ (void)showWithMessage:(NSMutableAttributedString *)message {
    
    XXDepositAlert *alert = [[XXDepositAlert alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    alert.message = message;
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
    XXDepositAlert *view = (XXDepositAlert *)[self currentView];
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), (kScreen_Height - 218)/2, kScreen_Width - K375(48), 218)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = kBtnBorderRadius;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (XXLabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(0, 16, self.contentView.width, 24) text:LocalizedString(@"Tip") font:kFontBold18 textColor:[UIColor blackColor]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (XYHNumbersLabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(24, CGRectGetMaxY(self.titleLabel.frame) + 24, self.contentView.width - 48, 0) font:kFont15];
        [_contentLabel setAttributedText:self.message alignment:NSTextAlignmentLeft];
    }
    return _contentLabel;
}

- (XXButton *)sureButton {
    if (_sureButton == nil) {
        MJWeakSelf
        _sureButton = [XXButton buttonWithFrame:CGRectMake(16, self.contentView.height - 56, self.contentView.width - 32, 44) title:LocalizedString(@"ShowAddress") font:kFontBold(17) titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf okAction];
        }];
        _sureButton.backgroundColor = kPrimaryMain;
        _sureButton.layer.cornerRadius = kBtnBorderRadius;
        _sureButton.layer.masksToBounds = YES;
    }
    return _sureButton;
}
@end
