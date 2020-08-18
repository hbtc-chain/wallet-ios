//
//  XXTradeDepthCell.m
//  Bhex
//
//  Created by BHEX on 2018/7/16.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXTradeDepthCell.h"

@interface XXTradeDepthCell ()

/** 进度视图 */
@property (strong, nonatomic) UIView *progressView;

/** 点视图 */
@property (strong, nonatomic, nullable) UIView *pointView;
@end

@implementation XXTradeDepthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.backgroundColor = kWhite100;
        [self.contentView addSubview:self.progressView];
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.numberLabel];
        [self.contentView addSubview:self.pointView];
    }
    return self;
}

#pragma mark - 1. 模型赋值
- (void)reloadData {

    dispatch_async(dispatch_get_main_queue(), ^{
        self.numberLabel.textColor = kDark100;
        self.priceLabel.textColor = kDark100;

        if (self.model.price.length <= 12) {
            self.priceLabel.font = kFont(12.0f);
            self.numberLabel.font = kFont(12.0f);
        } else {
            self.priceLabel.font = kFont(11.0f);
            self.numberLabel.font = kFont(11.0f);
        }
        
        self.priceLabel.text = self.model.price;
        
        if ([self.model.price isEqualToString:@"--"]) {
            self.numberLabel.text = @"--";
        } else if (self.amounntIndex == 0) {
            self.numberLabel.text = [NSString handValuemeLengthWithAmountStr:self.model.number];
        }  else if (self.amounntIndex == 1) {
            NSString *numberAmount = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.13f", self.model.sumNumber] RoundingMode:NSRoundDown scale:KTrade.numberDigit];
            self.numberLabel.text = [NSString handValuemeLengthWithAmountStr:numberAmount];
        }
        CGFloat progressValue = 0.0;
        if (self.amounntIndex == 0 && [self.model.number doubleValue] > 0 && self.maxAmount > 0) {
            progressValue = [self.model.number doubleValue]/self.maxAmount;
        } else if (self.amounntIndex == 1 && self.model.sumNumber > 0 && self.ordersAverage > 0) {
            progressValue = self.model.sumNumber/self.ordersAverage;
        }
        
        if (progressValue > 1.0) {
            progressValue = 1.0;
        }
        
        if (isnan(progressValue) || isinf(progressValue)) {
            progressValue = 1.0f;
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.width = (K375(144) + KSpacing) * progressValue;
            self.progressView.left = (K375(144) + KSpacing) - self.progressView.width;
        }];
        
        self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.bounds];
        
        if (self.model.isHavePoint) {
            self.pointView.backgroundColor = self.model.isBuy ? kGreen100 : kRed100;
            self.pointView.left = [NSString widthWithText:self.model.price font:self.priceLabel.font] + 3;
            self.pointView.hidden = NO;
        } else {
            self.pointView.hidden = YES;
        }
        
        if (self.model.isBuy) {
            self.progressView.backgroundColor = kGreen10;
            self.selectedBackgroundView.backgroundColor = kGreen50;
            self.priceLabel.textColor = kGreen100;
        } else {
            self.progressView.backgroundColor = kRed10;
            self.selectedBackgroundView.backgroundColor = kRed50;
            self.priceLabel.textColor = kRed100;
        }
    });
}

#pragma mark - || 懒加载
- (UIView *)progressView {
    if (_progressView == nil) {
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, [XXTradeDepthCell getCellHeight] - 1)];
        _progressView.userInteractionEnabled = NO;
    }
    return _progressView;
}

- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(0, 0, K375(92), [XXTradeDepthCell getCellHeight]) font:kFont12 textColor:kDark100];
        _priceLabel.text = @"--";
    }
    return _priceLabel;
}

- (XXLabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame), 0, K375(52), [XXTradeDepthCell getCellHeight]) font:kFont(K375(12.0f)) textColor:kDark100];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        _numberLabel.text = @"--";
    }
    return _numberLabel;
}

/** 点视图 */
- (UIView *)pointView {
    if (_pointView == nil) {
        _pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 9, 6, 6)];
        _pointView.layer.cornerRadius = 3;
        _pointView.layer.masksToBounds = YES;
    }
    return _pointView;
}

+ (CGFloat)getCellHeight {
    return 24;
}
@end
