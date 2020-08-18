//
//  XXSwitchPairsOptionCell.m
//  Bhex
//
//  Created by Bhex on 2019/3/27.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXSwitchPairsOptionCell.h"

@interface XXSwitchPairsOptionCell ()

/** 看涨看跌标签 */
@property (strong, nonatomic) XXLabel *markLabel;

/** 名称 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 最新价 */
@property (strong, nonatomic) XXLabel *nowPriceLabel;


@end

@implementation XXSwitchPairsOptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kWhite100;
        
        [self.contentView addSubview:self.markLabel];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.nowPriceLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)setModel:(XXSymbolModel *)model {
    _model = model;
    self.nameLabel.text = [NSString stringWithFormat:@"%@", model.symbolName];
    
    if (_model.quote && _model.quote.close && [_model.quote.close doubleValue] >= 0) {
        self.nowPriceLabel.text = [KDecimal decimalNumber:KString(_model.quote.close) RoundingMode:NSRoundDown scale:[KDecimal scale:_model.minPricePrecision]];
        CGFloat value = (([_model.quote.close floatValue] - [_model.quote.open floatValue])*100)/[_model.quote.open floatValue];
        if (isnan(value)) {
            value = 0.0;
        }
        if (value >= 0) {
            self.nowPriceLabel.textColor = kGreen100;
        } else {
            self.nowPriceLabel.textColor = kRed100;
        }
    } else {
        self.nowPriceLabel.text = @"--";
        self.nowPriceLabel.textColor = kGreen100;
    }

    if (self.isSymbolDetail) {
        if ([_model.symbolId isEqualToString:KDetail.symbolModel.symbolId]) {
            self.backgroundColor = kDark5;
            self.lineView.hidden = YES;
        } else {
            self.backgroundColor = kWhite100;
            self.lineView.hidden = NO;
        }
    } else {
            self.backgroundColor = kWhite100;
            self.lineView.hidden = NO;
    }
}

#pragma mark - || 懒加载
/** 看涨看跌标签 */
- (XXLabel *)markLabel {
    if (_markLabel == nil) {
        _markLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, ([XXSwitchPairsOptionCell getCellHeight] - 16)/2.0, K375(30), 16) text:@"" font:kFontBold10 textColor:kWhite100 alignment:NSTextAlignmentCenter];
        _markLabel.layer.borderWidth = 1.5;
        _markLabel.layer.cornerRadius = 3;
        _markLabel.layer.masksToBounds = YES;
    }
    return _markLabel;
}

- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.markLabel.frame) + K375(5), 0, K375(130), [XXSwitchPairsOptionCell getCellHeight] - 1) text:@"" font:kFontBold14 textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXLabel *)nowPriceLabel {
    if (_nowPriceLabel == nil) {
        _nowPriceLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.nameLabel.frame), self.nameLabel.top, K375(80), self.nameLabel.height) text:@"" font:kFont14 textColor:kDark100 alignment:NSTextAlignmentRight];
    }
    return _nowPriceLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.markLabel.left, [XXSwitchPairsOptionCell getCellHeight] - 0.5, K375(275) - self.markLabel.left, 0.5)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 45;
}

@end
