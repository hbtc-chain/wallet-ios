//
//  XXCrossDepositAlert.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXCrossDepositAlert.h"

@interface XXCrossDepositAlert()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIButton *dismissBtn;
@property (nonatomic, strong) UIImageView *screenShotImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *okBtn;

@end

@implementation XXCrossDepositAlert

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
//    [self.contentView addSubview:self.dismissBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.contentLabel];
    [self.contentView addSubview:self.okBtn];
}

+ (void)show {
    XXCrossDepositAlert *alert = [[XXCrossDepositAlert alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    [alert buildUI];
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - 200;
    } completion:^(BOOL finished) {
       
    }];
}


+ (void)dismiss {
    XXCrossDepositAlert *view = (XXCrossDepositAlert *)[self currentView];
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
    [[self class] dismiss];
}

- (void)cancelAction {
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
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 200, kScreen_Width, 200)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
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
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 24, kScreen_Width - 160, 24)];
        _titleLabel.text = LocalizedString(@"Tip");
        _titleLabel.font = kFont20;
        _titleLabel.textColor = kGray900NoChange;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

- (UILabel *)contentLabel {
    if (_contentLabel == nil) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(self.titleLabel.frame) + 24, kScreen_Width - 32, 44)];
        _contentLabel.text = LocalizedString(@"CrossDepositRecordFeeTip");
        _contentLabel.font = kFont14;
        _contentLabel.textColor = kGray700;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _contentLabel;
}

- (UIButton *)okBtn {
    if (_okBtn == nil) {
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(K375(16), self.contentView.height - 64, kScreen_Width - K375(32), kBtnHeight)];
        [_okBtn setTitle:LocalizedString(@"OkIKnow") forState:UIControlStateNormal];
        [_okBtn setBackgroundColor:kPrimaryMain];
        [_okBtn.titleLabel setFont:kFontBold18];
        _okBtn.layer.cornerRadius = kBtnBorderRadius;
        _okBtn.layer.masksToBounds = YES;
        [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_okBtn addTarget:self action:@selector(okAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

@end

