//
//  XXFailureView.m
//  Bhex
//
//  Created by Bhex on 2019/8/9.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXFailureView.h"
#import "XYHNumbersLabel.h"

@interface XXFailureView ()

/** <#mark#> */
@property (strong, nonatomic) UIImageView *iconImageView;

/** 重新加载n按钮 */
@property (strong, nonatomic) XYHNumbersLabel *reloadLabel;

@end

@implementation XXFailureView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kWhiteColor;
        [self addSubview:self.iconImageView];
        [self addSubview:self.msgLabel];
        [self addSubview:self.reloadLabel];
    }
    return self;
}

- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kIsNight ? @"noDataFailedDark" : @"noDataFailed"]];
        _iconImageView.frame = CGRectMake((self.width - 120)/2.0, ((self.height - 196.0)/2.0)*0.7, 120, 120);
    }
    return _iconImageView;
}

- (XXLabel *)msgLabel {
    if (_msgLabel == nil) {
        _msgLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.iconImageView.frame) + 10, kScreen_Width - K375(48),24) font:kFont14 textColor:kGray500];
        _msgLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _msgLabel;
}

- (XYHNumbersLabel *)reloadLabel {
    if (_reloadLabel == nil) {
        MJWeakSelf
        _reloadLabel =  [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(32, CGRectGetMaxY(self.msgLabel.frame), self.width -  64, 40) font:kFontBold14];
        _reloadLabel.textColor = kPrimaryMain;
        [_reloadLabel setText:LocalizedString(@"ReloadData") alignment:NSTextAlignmentCenter];
        _reloadLabel.height = _reloadLabel.height + 30;
        _reloadLabel.userInteractionEnabled = YES;
        [_reloadLabel whenTapped:^{
            if (weakSelf.reloadBlock) {
                weakSelf.reloadBlock();
            }
        }];
    }
    return _reloadLabel;
}
@end
