//
//  XXWebMenuAlert.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXWebMenuAlert.h"

@interface XXWebMenuAlert ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) XXButton *leftBtn;
@property (nonatomic, strong) XXLabel *leftLabel;
@property (nonatomic, strong) XXButton *rightBtn;
@property (nonatomic, strong) XXLabel *rightLabel;
@property (nonatomic, strong) XXButton *cancelBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation XXWebMenuAlert

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
    [self.contentView addSubview:self.leftBtn];
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightBtn];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.cancelBtn];
}

+ (void)showWithSureBlock:(void (^)(void))sureBlock {
    
    XXWebMenuAlert *alert = [[XXWebMenuAlert alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    [alert buildUI];
    alert.sureBlock = sureBlock;
    
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
    XXWebMenuAlert *view = (XXWebMenuAlert *)[self currentView];
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
        _contentView.backgroundColor = kWhiteColor;
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 124, kScreen_Width, 8)];
        _lineView.backgroundColor = kGray50;
    }
    return _lineView;
}

- (XXButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [XXButton buttonWithFrame:CGRectMake(0, 132, kScreen_Width, 68) title:LocalizedString(@"Cancel") font:kFontBold(17) titleColor:kPrimaryMain block:^(UIButton *button) {
            [[self class] dismiss];
        }];
        _cancelBtn.backgroundColor = kWhiteColor;
    }
    return _cancelBtn;
}

- (XXButton *)leftBtn {
    if (!_leftBtn) {
        _leftBtn = [XXButton buttonWithFrame:CGRectMake(self.contentView.width/4 - 28, 24, 56, 56) block:^(UIButton *button) {
            
        }];
        [_leftBtn setImage:[UIImage imageNamed:@"dapp_wallet"] forState:UIControlStateNormal];
        [_leftBtn setBackgroundColor:kGray50];
    }
    return _leftBtn;
}

- (XXLabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.leftBtn.frame) + 4, 0, 24) text:LocalizedString(@"ChangeAccount") font:kFont13 textColor:kGray700 alignment:NSTextAlignmentCenter];
        [_leftLabel sizeToFit];
        _leftLabel.centerX = self.leftBtn.centerX;
    }
    return _leftLabel;
}

- (XXButton *)rightBtn {
    if (!_rightBtn) {
        _rightBtn = [XXButton buttonWithFrame:CGRectMake(self.contentView.width*3/4 - 28, 24, 56, 56) block:^(UIButton *button) {
            
        }];
        [_rightBtn setImage:[UIImage imageNamed:@"dapp_refresh"] forState:UIControlStateNormal];
        [_rightBtn setBackgroundColor:kGray50];
    }
    return _rightBtn;
}

- (XXLabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.rightBtn.frame) + 4, 0, 24) text:LocalizedString(@"Refresh") font:kFont13 textColor:kGray700 alignment:NSTextAlignmentCenter];
        [_rightLabel sizeToFit];
        _rightLabel.centerX = self.rightBtn.centerX;
    }
    return _rightLabel;
}
@end
