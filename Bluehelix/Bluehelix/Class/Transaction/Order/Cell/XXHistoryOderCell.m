//
//  XXHistoryOderCell.m
//  Bhex
//
//  Created by BHEX on 2018/7/22.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXHistoryOderCell.h"

@interface XXHistoryOderCell ()

/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 时间 */
@property (strong, nonatomic) XXLabel *timeLabel;

/** 状态标签 */
@property (strong, nonatomic) XXLabel *statusLabel;

/** 价格标签 */
@property (strong, nonatomic) XXLabel *priceNameLabel;

/** 价格值标签 */
@property (strong, nonatomic) XXLabel *pricelValueLabel;

/** 成家均价标签 */
@property (strong, nonatomic) XXLabel *averagePriceNameLabel;

/** 成家均价值标签 */
@property (strong, nonatomic) XXLabel *averagePricelValueLabel;

/** 数量标签 */
@property (strong, nonatomic) XXLabel *numberNameLabel;

/** 数量值标签 */
@property (strong, nonatomic) XXLabel *numberValueLabel;

/** 成交数量标签 */
@property (strong, nonatomic) XXLabel *finishNumberNameLabel;

/** 成效数量值标签 */
@property (strong, nonatomic) XXLabel *finishNumberValueLabel;

@end

@implementation XXHistoryOderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kWhite100;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 创建主界面
- (void)setupUI {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.finishNumberNameLabel];
    [self.contentView addSubview:self.finishNumberValueLabel];
    [self.contentView addSubview:self.priceNameLabel];
    [self.contentView addSubview:self.pricelValueLabel];
    [self.contentView addSubview:self.numberNameLabel];
    [self.contentView addSubview:self.numberValueLabel];
    [self.contentView addSubview:self.averagePriceNameLabel];
    [self.contentView addSubview:self.averagePricelValueLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.lineView];
    
}

- (void)setModel:(XXOrderModel *)model {
    _model = model;
    
    NSString *nameString = @"";
    NSString *symbolString = @"";
    UIColor *typeClolor;
    
    // 判断买卖 /** LIMIT 限价  MARKET  市价 */
    if ([_model.side isEqualToString:@"BUY"]) {
        typeClolor = kGreen100;
    
        nameString = [_model.type isEqualToString:@"LIMIT"] ? [NSString stringWithFormat:@"%@ %@", LocalizedString(@"Limit"), LocalizedString(@"Buy")] : [NSString stringWithFormat:@"%@ %@", LocalizedString(@"MarketPrice"), LocalizedString(@"Buy")];
    } else {
        typeClolor = kRed100;
        nameString = [_model.type isEqualToString:@"LIMIT"] ? [NSString stringWithFormat:@"%@ %@", LocalizedString(@"Limit"), LocalizedString(@"Sell")] : [NSString stringWithFormat:@"%@ %@", LocalizedString(@"MarketPrice"), LocalizedString(@"Sell")];
    }
    symbolString = [NSString stringWithFormat:@"   %@/%@", _model.baseTokenName, _model.quoteTokenName];
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":nameString, @"color":typeClolor, @"font":kFont14};
    itemsArray[1] = @{@"string":symbolString, @"color":kDark100, @"font":kFont14};
    self.nameLabel.attributedText = [NSString mergeStrings:itemsArray];
    
    NSString *timeString = [NSString dateStringFromTimestampWithTimeTamp:[_model.time longLongValue]];
    self.timeLabel.text = timeString;

    NSInteger numberPrecision = [KMarket getNumberPrecisionWithSymbolId:_model.symbolId quoteName:_model.quoteTokenName];
    NSInteger pricePrecision = [KMarket getPricePrecisionWithSymbolId:_model.symbolId quoteName:_model.quoteTokenName];
    NSInteger quotePrecision = [KMarket getQuotePrecisionWithSymbolId:_model.symbolId quoteName:_model.quoteTokenName];
    
    // 1. 成交数量
    self.finishNumberValueLabel.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.executedQty RoundingMode:NSRoundDown scale:numberPrecision], _model.baseTokenName];
    
    // 2. 价格
    if ([_model.type isEqualToString:@"LIMIT"]) {
        self.pricelValueLabel.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.price RoundingMode:NSRoundDown scale:pricePrecision], _model.quoteTokenName];
    } else {
        self.pricelValueLabel.text =LocalizedString(@"MarketPrice");
    }
    
    // 3. 委托总量 金额
    if ([_model.type isEqualToString:@"MARKET"] && [_model.side isEqualToString:@"BUY"]) {
        self.numberNameLabel.text = [NSString stringWithFormat:@"%@:",LocalizedString(@"OrderAmount")];
        self.numberValueLabel.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.origQty RoundingMode:NSRoundDown scale:quotePrecision], _model.quoteTokenName];
    } else {
        self.numberNameLabel.text = [NSString stringWithFormat:@"%@:",LocalizedString(@"OrderTotal")];
        self.numberValueLabel.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.origQty RoundingMode:NSRoundDown scale:numberPrecision], _model.baseTokenName];
    }
    
    // 4. 成交均价
    self.averagePricelValueLabel.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.avgPrice RoundingMode:NSRoundDown scale:pricePrecision], _model.quoteTokenName];
    
    // 5. 状态
    self.statusLabel.text = _model.status;
    if ([_model.status isEqualToString:@"FILLED"]) {
        self.statusLabel.text = LocalizedString(@"FILLED");
    } else {
        if ([_model.executedQty doubleValue] > 0) {
            self.statusLabel.text = LocalizedString(@"PARTIALLY_FILLED");
        } else {
            self.statusLabel.text = LocalizedString(@"CANCELD");
        }
    }
    
    self.finishNumberNameLabel.text = [NSString stringWithFormat:@"%@:",LocalizedString(@"TradingVolume")];
    self.priceNameLabel.text = [NSString stringWithFormat:@"%@:",LocalizedString(@"Price")];
    self.averagePriceNameLabel.text = [NSString stringWithFormat:@"%@:",LocalizedString(@"AveragePrice")];
}

#pragma mark - || 懒加载
/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 16, K375(168), 16) font:kFont14 textColor:kDark100];
    }
    return _nameLabel;
}

/** 时间 */
- (XXLabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [XXLabel labelWithFrame:CGRectMake(kScreen_Width - K375(200) - KSpacing, self.nameLabel.top, K375(200), self.nameLabel.height) font:kFont10 textColor:kDark50];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

/** 成交数量标签 */
- (XXLabel *)finishNumberNameLabel {
    if (_finishNumberNameLabel == nil) {
        _finishNumberNameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nameLabel.frame) + 8, K375(96), 16) font:kFont12 textColor:kDark50];
    }
    return _finishNumberNameLabel;
}

/** 成效数量值标签 */
- (XXLabel *)finishNumberValueLabel {
    if (_finishNumberValueLabel == nil) {
        _finishNumberValueLabel = [XXLabel labelWithFrame:CGRectMake(K375(136), self.finishNumberNameLabel.top, K375(142), self.finishNumberNameLabel.height) font:kFont12 textColor:kDark100];
    }
    return _finishNumberValueLabel;
}

/** 价格标签 */
- (XXLabel *)priceNameLabel {
    if (_priceNameLabel == nil) {
        _priceNameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.finishNumberNameLabel.frame), self.finishNumberNameLabel.width, self.finishNumberNameLabel.height) font:kFont12 textColor:kDark50];
    }
    return _priceNameLabel;
}

/** 价格值标签 */
- (XXLabel *)pricelValueLabel {
    if (_pricelValueLabel == nil) {
        _pricelValueLabel = [XXLabel labelWithFrame:CGRectMake(self.finishNumberValueLabel.left, self.priceNameLabel.top, self.finishNumberValueLabel.width, self.priceNameLabel.height) font:kFont12 textColor:kDark100];
    }
    return _pricelValueLabel;
}

/** 数量标签 */
- (XXLabel *)numberNameLabel {
    if (_numberNameLabel == nil) {
        _numberNameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.priceNameLabel.frame), self.priceNameLabel.width, self.priceNameLabel.height) font:kFont12 textColor:kDark50];
    }
    return _numberNameLabel;
}

/** 数量值标签 */
- (XXLabel *)numberValueLabel {
    if (_numberValueLabel == nil) {
        _numberValueLabel = [XXLabel labelWithFrame:CGRectMake(self.finishNumberValueLabel.left, self.numberNameLabel.top, self.finishNumberValueLabel.width, self.numberNameLabel.height) font:kFont12 textColor:kDark100];
    }
    return _numberValueLabel;
}

/** 成家均价标签 */
- (XXLabel *)averagePriceNameLabel {
    if (_averagePriceNameLabel == nil) {
        _averagePriceNameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.numberNameLabel.frame), self.numberNameLabel.width, self.numberNameLabel.height) font:kFont12 textColor:kDark50];
    }
    return _averagePriceNameLabel;
}

/** 成家均价值标签 */
- (XXLabel *)averagePricelValueLabel {
    if (_averagePricelValueLabel == nil) {
        _averagePricelValueLabel = [XXLabel labelWithFrame:CGRectMake(self.finishNumberValueLabel.left, self.averagePriceNameLabel.top, self.finishNumberValueLabel.width, self.averagePriceNameLabel.height) font:kFont12 textColor:kDark100];
    }
    return _averagePricelValueLabel;
}

/** 状态标签 */
- (XXLabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [XXLabel labelWithFrame:CGRectMake(kScreen_Width - K375(120) - KSpacing, self.averagePriceNameLabel.top, K375(120), self.averagePriceNameLabel.height) font:kFont12 textColor:kDark100];
        _statusLabel.textAlignment = NSTextAlignmentRight;
    }
    return _statusLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, 127, kScreen_Width - KSpacing, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 128;
}
@end
