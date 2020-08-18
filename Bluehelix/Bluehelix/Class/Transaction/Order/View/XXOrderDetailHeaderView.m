//
//  XXOrderDetailHeaderView.m
//  Bhex
//
//  Created by BHEX on 2018/7/24.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXOrderDetailHeaderView.h"

@interface XXOrderDetailHeaderView () {
    CGFloat offetY;
}

/** 限价 卖出 */
@property (strong, nonatomic) XXLabel *typeLabel;

/** 币对 */
@property (strong, nonatomic) XXLabel *symbolLabel;

/** 状态标签 */
@property (strong, nonatomic) XXLabel *statusLabel;

/** 标签数组 */
@property (strong, nonatomic) NSMutableArray *nameLabelsArray;

/** 标签数组 */
@property (strong, nonatomic) NSMutableArray *labelsArray;

/** 复制按钮 */
@property (strong, nonatomic) XXButton *coppButton;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

/** 成交详情标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 分割线2 */
@property (strong, nonatomic) UIView *lineTwoView;

@end

@implementation XXOrderDetailHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self. backgroundColor = kViewBackgroundColor;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    [self addSubview:self.typeLabel];
    [self addSubview:self.symbolLabel];
    [self addSubview:self.statusLabel];
    self.nameLabelsArray = [NSMutableArray array];
    self.labelsArray = [NSMutableArray array];
    NSArray *namesArray = @[LocalizedString(@"Price"), LocalizedString(@"AveragePrice"), LocalizedString(@"OrderTotal"), LocalizedString(@"TradingVolume"), LocalizedString(@"TotalVolume"), LocalizedString(@"OrderNamber")];
    
    offetY = CGRectGetMaxY(self.statusLabel.frame) + 10;
    for (NSInteger i=0; i < namesArray.count; i ++) {
        XXLabel *nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), offetY, K375(200), 25) text:namesArray[i] font:kFont14 textColor:kDark50];
        [self addSubview:nameLabel];
        
        XXLabel *valueLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), offetY, kScreen_Width - K375(48), nameLabel.height) text:@"" font:kFont14 textColor:kDark100 alignment:NSTextAlignmentRight];
        [self addSubview:valueLabel];
        [self.nameLabelsArray addObject:nameLabel];
        [self.labelsArray addObject:valueLabel];
        offetY += 25;
        
        if (i == 5) {
            valueLabel.width = kScreen_Width - (24 + K375(50));
            self.coppButton.top = valueLabel.top;
            [self addSubview:self.coppButton];
        }
    }
    
    offetY += 10;
    [self addSubview:self.lineView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.lineTwoView];
    self.height = CGRectGetMaxY(self.lineTwoView.frame);
}

#pragma mark - 2. 模型赋值
- (void)setCoinModel:(XXOrderModel *)coinModel {
    _coinModel = coinModel;
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    NSString *typeString = [_coinModel.type isEqualToString:@"MARKET"] ? LocalizedString(@"MarketPrice") : LocalizedString(@"Limit");
    NSString *sideString = [_coinModel.side isEqualToString:@"BUY"] ? LocalizedString(@"Buy") : LocalizedString(@"Sell");
    UIColor *sideColor = [_coinModel.side isEqualToString:@"BUY"] ? kGreen100 : kRed100;
    
    itemsArray[0] = @{@"string":typeString, @"color":kDark100, @"font":kFontBold18};
    itemsArray[1] = @{@"string":[NSString stringWithFormat:@" %@", sideString], @"color":sideColor, @"font":kFontBold18};
    self.typeLabel.attributedText = [NSString mergeStrings:itemsArray];
    self.symbolLabel.text = [NSString stringWithFormat:@"%@/%@", _coinModel.baseTokenName, _coinModel.quoteTokenName];
    
    NSInteger numberPrecision = [KMarket getNumberPrecisionWithSymbolId:_coinModel.symbolId quoteName:_coinModel.quoteTokenName];
    NSInteger pricePrecision = [KMarket getPricePrecisionWithSymbolId:_coinModel.symbolId quoteName:_coinModel.quoteTokenName];
    NSInteger quotePrecision = [KMarket getQuotePrecisionWithSymbolId:_coinModel.symbolId quoteName:_coinModel.quoteTokenName];
    
    self.statusLabel.text = _coinModel.statusDesc;
    self.statusLabel.text = _coinModel.status;
    if ([_coinModel.status isEqualToString:@"FILLED"]) {
        self.statusLabel.text = LocalizedString(@"FILLED");
    } else {
        if ([_coinModel.executedQty doubleValue] > 0) {
            self.statusLabel.text = LocalizedString(@"PARTIALLY_FILLED");
        } else {
            self.statusLabel.text = LocalizedString(@"CANCELD");
        }
    }
    
    for (NSInteger i=0; i < self.labelsArray.count; i ++) {
        XXLabel *label = self.labelsArray[i];
        if (i == 0) { // 价格
            label.text = [_coinModel.type isEqualToString:@"MARKET"] ? LocalizedString(@"MarketPrice") : [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_coinModel.price RoundingMode:NSRoundDown scale:pricePrecision], _coinModel.quoteTokenName];
        } else if ( i==1) { // 成交均价
            label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_coinModel.avgPrice RoundingMode:NSRoundDown scale:pricePrecision], _coinModel.quoteTokenName];
        } else if ( i==2) { // 委托总量
            if ([_coinModel.type isEqualToString:@"MARKET"] && [_coinModel.side isEqualToString:@"BUY"]) {
                label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_coinModel.origQty RoundingMode:NSRoundDown scale:quotePrecision], _coinModel.quoteTokenName];
            } else {
                label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_coinModel.origQty RoundingMode:NSRoundDown scale:numberPrecision], _coinModel.baseTokenName];
            }
        } else if ( i==3) { // 已成交量
            label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_coinModel.executedQty RoundingMode:NSRoundDown scale:numberPrecision], _coinModel.baseTokenName];
        } else if ( i==4) { // 总成交额
            label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_coinModel.executedAmount RoundingMode:NSRoundDown scale:quotePrecision], _coinModel.quoteTokenName];
        } else if ( i==5) { // 总成交额
            label.text = _coinModel.orderId;
        }
    }
}

- (void)setOptionModel:(XXOrderModel *)optionModel {
    _optionModel = optionModel;
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    NSString *typeString = [_optionModel.type isEqualToString:@"MARKET"] ? LocalizedString(@"MarketPrice") : LocalizedString(@"Limit");
    NSString *sideString = [_optionModel.side isEqualToString:@"BUY"] ? LocalizedString(@"Buy") : LocalizedString(@"Sell");
    UIColor *sideColor = [_optionModel.side isEqualToString:@"BUY"] ? kGreen100 : kRed100;
    
    itemsArray[0] = @{@"string":typeString, @"color":kDark100, @"font":kFontBold18};
    itemsArray[1] = @{@"string":[NSString stringWithFormat:@" %@", sideString], @"color":sideColor, @"font":kFontBold18};
    self.typeLabel.attributedText = [NSString mergeStrings:itemsArray];
    self.symbolLabel.text = _optionModel.symbolName;

    self.statusLabel.text = _optionModel.statusDesc;
    self.statusLabel.text = _optionModel.status;
    if ([_optionModel.status isEqualToString:@"FILLED"]) {
        self.statusLabel.text = LocalizedString(@"FILLED");
    } else {
        if ([_optionModel.executedQty doubleValue] > 0) {
            self.statusLabel.text = LocalizedString(@"PARTIALLY_FILLED");
        } else {
            self.statusLabel.text = LocalizedString(@"CANCELD");
        }
    }
    
    for (NSInteger i=0; i < self.labelsArray.count; i ++) {
        XXLabel *label = self.labelsArray[i];
        if (i == 0) { // 价格
            label.text = [_optionModel.type isEqualToString:@"MARKET"] ? LocalizedString(@"MarketPrice") : [NSString stringWithFormat:@"%@%@", _optionModel.price, _optionModel.quoteTokenName];
        } else if ( i==1) { // 成交均价
            label.text = [NSString stringWithFormat:@"%@%@", _optionModel.avgPrice, _optionModel.quoteTokenName];
        } else if ( i==2) { // 委托总量
            if ([_optionModel.type isEqualToString:@"MARKET"] && [_optionModel.side isEqualToString:@"BUY"]) {
                label.text = [NSString stringWithFormat:@"%@%@", _optionModel.origQty, LocalizedString(@"Paper")];
            } else {
                label.text = [NSString stringWithFormat:@"%@%@", _optionModel.origQty, LocalizedString(@"Paper")];
            }
        } else if ( i==3) { // 已成交量
            label.text = [NSString stringWithFormat:@"%@%@", _optionModel.executedQty,  LocalizedString(@"Paper")];
        } else if ( i==4) { // 总成交额
            label.text = [NSString stringWithFormat:@"%@%@", _optionModel.executedAmount, _optionModel.quoteTokenName];
        } else if ( i==5) { // 总成交额
            label.text = _optionModel.orderId;
        }
    }
    
}

#pragma mark - || 懒加载
/** 限价 卖出 */
- (XXLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [XXLabel labelWithFrame:CGRectMake(0, 15, kScreen_Width, 30) text:@"" font:kFontBold18 textColor:kDark100 alignment:NSTextAlignmentCenter];
    }
    return _typeLabel;
}

/** 币对 */
- (XXLabel *)symbolLabel {
    if (_symbolLabel == nil) {
        _symbolLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeLabel.frame), kScreen_Width, 30) text:@"" font:kFontBold18 textColor:kDark100 alignment:NSTextAlignmentCenter];
    }
    return _symbolLabel;
}

/** 状态标签 */
- (XXLabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [XXLabel labelWithFrame:CGRectMake(0, CGRectGetMaxY(self.symbolLabel.frame), kScreen_Width, 20) text:@"" font:kFont14 textColor:kDark50 alignment:NSTextAlignmentCenter];
    }
    return _statusLabel;
}

/** 分割线 */
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, offetY, kScreen_Width, 8)];
        _lineView.backgroundColor = KBigLine_Color;
    }
    return _lineView;
}

/** 成交详情标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.lineView.frame), K375(200), 40) text:LocalizedString(@"TransactionDetails") font:kFontBold14 textColor:kDark100];

    }
    return _nameLabel;
}

/** 复制按钮 */
- (XXButton *)coppButton {
    if (_coppButton == nil) {
        MJWeakSelf
        _coppButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - (24 + K375(44)), 110, 24 + K375(44), 25) block:^(UIButton *button) {
            
            if (weakSelf.coinModel.orderId.length > 0) {
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:weakSelf.coinModel.orderId];
                [MBProgressHUD showSuccessMessage:LocalizedString(@"CopySuccessfully")];
            } else if (weakSelf.optionModel.orderId.length > 0) {
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:weakSelf.optionModel.orderId];
                [MBProgressHUD showSuccessMessage:LocalizedString(@"CopySuccessfully")];
            }
        }];
        [_coppButton setImage:[UIImage textImageName:@"paste"] forState:UIControlStateNormal];
    }
    return _coppButton;
}

- (UIView *)lineTwoView {
    if (_lineTwoView == nil) {
        _lineTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), kScreen_Width, 1)];
        _lineTwoView.backgroundColor = KLine_Color;
    }
    return _lineTwoView;
}
@end
