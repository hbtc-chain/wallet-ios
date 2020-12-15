//
//  GYNoticeViewCell.m
//  RollingNotice
//
//  Created by qm on 2017/12/4.
//  Copyright © 2017年 qm. All rights reserved.
//

#import "GYNoticeViewCell.h"

@implementation GYNoticeViewCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _reuseIdentifier = reuseIdentifier;
        [self setupInitialUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        if (GYRollingDebugLog) {
        }
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithReuseIdentifier:@""];
}

- (void)setupInitialUI
{
    self.backgroundColor = kWhite100;
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.textLabel];
    [self.contentView addSubview:self.closeBtn];
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(15, 2, kScreen_Width - 30, 32)];
        _contentView.layer.cornerRadius = 16;
    }
    return _contentView;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 28, 28)];
        _icon.layer.cornerRadius = 16;
    }
    return _icon;
}

- (UILabel *)textLabel {
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, self.contentView.width - 80, 32)];
        _textLabel.font = kFont12;
        _textLabel.textColor = kGray700;
    }
    return _textLabel;
}

- (XXButton *)closeBtn {
    if (_closeBtn == nil) {
        MJWeakSelf
        _closeBtn = [XXButton buttonWithFrame:CGRectMake(self.contentView.width - 28, 8, 16, 16) block:^(UIButton *button) {
            KUser.closeNoticeFlag = YES;
            if (weakSelf.closeBlock) {
                weakSelf.closeBlock();
            }
        }];
        [_closeBtn setImage:[UIImage textImageName:@"dismiss"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}
@end
