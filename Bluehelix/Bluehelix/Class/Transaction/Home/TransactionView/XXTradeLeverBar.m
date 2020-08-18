//
//  XXTradeLeverBar.m
//  Bhex
//
//  Created by xu Lance on 2020/5/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTradeLeverBar.h"

@interface XXTradeLeverBar ()

@property (nonatomic, strong) UIView *topLineView;

@property (nonatomic, strong) UIView *riskBackgroundView;

@property (nonatomic, strong) XXButton *riskRatioButton;

@property (nonatomic, strong) XXButton *borrowOrReturnButton;

@property (nonatomic, strong) UIView *bottleLineView;

@end

@implementation XXTradeLeverBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.topLineView];
        [self addSubview:self.riskBackgroundView];
        [self addSubview:self.riskRatioLabel];
        [self addSubview:self.riskRatioDetailImage];
        [self addSubview:self.riskRatioButton];
        [self addSubview:self.borrowOrReturnButton];
        [self addSubview:self.bottleLineView];
    }
    return self;
}

#pragma mark lazy load
- (UIView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 4)];
        _topLineView.backgroundColor = kDark5;
    }
    return _topLineView;
}
- (UIView *)riskBackgroundView{
    if (!_riskBackgroundView) {
        _riskBackgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLineView.frame), kScreen_Width, 40)];
        _riskBackgroundView.backgroundColor = kWhite100;
    }
    return _riskBackgroundView;
}

- (XXLabel *)riskRatioLabel{
    if (!_riskRatioLabel) {
        _riskRatioLabel = [XXLabel labelWithFrame:CGRectMake(16, CGRectGetMaxY(self.topLineView.frame) +8, 64, 24) text:[NSString stringWithFormat:@"%@ --%@",LocalizedString(@"LeverRiskRatio"),@"%"] font:kFont12 textColor:kDark50 alignment:NSTextAlignmentLeft];
        _riskRatioLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _riskRatioLabel;
}
- (UIImageView *)riskRatioDetailImage{
    if (!_riskRatioDetailImage) {
        _riskRatioDetailImage = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.riskRatioLabel.frame) +2, CGRectGetMaxY(self.topLineView.frame) +13, 14, 14)];
        _riskRatioDetailImage.image = [UIImage subTextImageName:@"lever_question"];
    }
    return _riskRatioDetailImage;
}
- (XXButton *)riskRatioButton{
    if (!_riskRatioButton) {
        _riskRatioButton = [XXButton buttonWithFrame:CGRectMake(0, CGRectGetMaxY(self.topLineView.frame), CGRectGetMaxX(self.riskRatioDetailImage.frame) +24, 40) block:^(UIButton *button) {
            if (self.riskRatioButtonActionBlock) {
                self.riskRatioButtonActionBlock(self.riskRatioButton);
            }
        }];
    }
    return _riskRatioButton;
}

- (XXButton *)borrowOrReturnButton {
    if (!_borrowOrReturnButton) {
        _borrowOrReturnButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 78 - 16, CGRectGetMaxY(self.topLineView.frame) + 8, 78, 24) title:LocalizedString(@"BorrowOrReturenButton") font:kFont12 titleColor:kBlue100 block:^(UIButton *button) {
            if (self.XXBorrowOrReturnButtonActionBlock) {
                self.XXBorrowOrReturnButtonActionBlock(self.borrowOrReturnButton);
            }
        }];
        _borrowOrReturnButton.backgroundColor = kBlue10;
        _borrowOrReturnButton.layer.cornerRadius = 2.0f;
    }
    return _borrowOrReturnButton;
}
- (UIView *)bottleLineView{
    if (!_bottleLineView) {
        _bottleLineView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.riskBackgroundView.frame), kScreen_Width, 4)];
        _bottleLineView.backgroundColor = kDark5;
    }
    return _bottleLineView;
}
@end
