//
//  XXSwitchPairsCell.m
//  Bhex
//
//  Created by Bhex on 2018/9/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXSwitchPairsCell.h"

@interface XXSwitchPairsCell ()

/** 名称 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 最新价 */
@property (strong, nonatomic) XXLabel *nowPriceLabel;

@end

@implementation XXSwitchPairsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kWhite100;
        
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.nowPriceLabel];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

- (void)setModel:(XXSymbolModel *)model {
    _model = model;
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":_model.baseTokenName, @"color":kDark100, @"font":kFontBold(16)};
    itemsArray[1] = @{@"string":[NSString stringWithFormat:@" / %@", _model.quoteTokenName], @"color":kDark50, @"font":kFontBold10};
    if (model.type == SymbolTypeCoin || model.type == SymbolTypeCoinMargin) {
        self.nameLabel.attributedText = [NSString mergeStrings:itemsArray];
    } else {
        self.nameLabel.text = model.symbolName;
    }
    
    if (_model.quote && [_model.quote.close doubleValue] >= 0) {
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
        if ([_model.symbolId isEqualToString:KTrade.coinTradeModel.symbolId]) {
            self.backgroundColor = kDark5;
            self.lineView.hidden = YES;
        } else {
            self.backgroundColor = kWhite100;
            self.lineView.hidden = NO;
        }
    }
}

#pragma mark - || 懒加载
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 0, K375(125), [XXSwitchPairsCell getCellHeight] - 1) text:@"" font:kFontBold14 textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXLabel *)nowPriceLabel {
    if (_nowPriceLabel == nil) {
        _nowPriceLabel = [XXLabel labelWithFrame:CGRectMake(K375(129), self.nameLabel.top, K375(122), self.nameLabel.height) text:@"" font:kFont14 textColor:kDark100 alignment:NSTextAlignmentRight];
    }
    return _nowPriceLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.nameLabel.left, [XXSwitchPairsCell getCellHeight] - 1, K375(275) - self.nameLabel.left, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 45;
}

@end
