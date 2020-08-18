//
//  XXOrderDetailCell.m
//  Bhex
//
//  Created by BHEX on 2018/7/24.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXOrderDetailCell.h"

@interface XXOrderDetailCell () {
    CGFloat offetY;
}

/** 标签数组 */
@property (strong, nonatomic) NSMutableArray *labelsArray;

/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

/** 复制按钮 */
@property (strong, nonatomic) XXButton *coppButton;
@end

@implementation XXOrderDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 创建主界面
- (void)setupUI {
    self.labelsArray = [NSMutableArray array];
    NSArray *namesArray = @[LocalizedString(@"ShiJian"), LocalizedString(@"ExecutedPrice"), LocalizedString(@"Amount"), LocalizedString(@"Total"), LocalizedString(@"Fee"), LocalizedString(@"TradeId")];
    offetY = 10;
    for (NSInteger i=0; i < namesArray.count; i ++) {
        XXLabel *nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), offetY, K375(200), 25) text:namesArray[i] font:kFont14 textColor:kDark50];
        [self.contentView addSubview:nameLabel];
        
        XXLabel *valueLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), offetY, kScreen_Width - K375(48), nameLabel.height) text:@"" font:kFont14 textColor:kDark100 alignment:NSTextAlignmentRight];
        [self.contentView addSubview:valueLabel];
        [self.labelsArray addObject:valueLabel];
        if (i == 5) {
            valueLabel.width = kScreen_Width - (24 + K375(50));
            self.coppButton.top = valueLabel.top;
            [self.contentView addSubview:self.coppButton];
        }
        offetY += 25;
    }
    
    offetY += 10;
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), offetY, kScreen_Width - K375(24), 1)];
    self.lineView.backgroundColor = KLine_Color;
    [self.contentView addSubview:self.lineView];
}

#pragma mark - 2. 模型赋值
- (void)setModel:(XXOrderInfoModel *)model {
    _model = model;
    //TODO
//    if (_model.indexType == SymbolTypeCoin || _model.indexType == SymbolTypeCoinMargin) {
//        NSInteger numberPrecision = [KMarket getNumberPrecisionWithSymbolId:_model.symbolId quoteName:_model.quoteTokenName];
//        NSInteger pricePrecision = [KMarket getPricePrecisionWithSymbolId:_model.symbolId quoteName:_model.quoteTokenName];
//        NSInteger quotePrecision = [KMarket getQuotePrecisionWithSymbolId:_model.symbolId quoteName:_model.quoteTokenName];
//
//        for (NSInteger i=0; i < self.labelsArray.count; i ++) {
//            XXLabel *label = self.labelsArray[i];
//            if (i == 0) { // 时间
//                label.text = [NSString dateStringFromTimestampWithTimeTamp:[_model.time longLongValue]];
//            } else if ( i==1) { // 成交价
//                label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.price RoundingMode:NSRoundDown scale:pricePrecision],_model.quoteTokenName];
//            } else if ( i==2) { // 数量
//                label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.quantity RoundingMode:NSRoundDown scale:numberPrecision], _model.baseTokenName];
//            } else if ( i==3) { // 成交额
//                NSString *quamtity = [NSString stringWithFormat:@"%.12f", [_model.price doubleValue]*[_model.quantity doubleValue]];
//                label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:quamtity RoundingMode:NSRoundDown scale:quotePrecision], _model.quoteTokenName];
//            } else if ( i==4) { // 手续费
//                if ([_model.fee floatValue] == 0) {
//                    label.text = @"0";
//                } else {
//                    label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.fee RoundingMode:NSRoundDown scale:8], _model.feeTokenName];
//                }
//            } else if (i == 5) {
//                label.text = KString(_model.tradeId);
//            }
//        }
//    } else if (_model.indexType == SymbolTypeOption) {
//        for (NSInteger i=0; i < self.labelsArray.count; i ++) {
//            XXLabel *label = self.labelsArray[i];
//            if (i == 0) { // 时间
//                label.text = [NSString dateStringFromTimestampWithTimeTamp:[_model.time longLongValue]];
//            } else if ( i==1) { // 成交价
//                label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.price  RoundingMode:NSRoundDown scale:8],_model.quoteTokenName];
//            } else if ( i==2) { // 数量
//                label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.quantity RoundingMode:NSRoundDown scale:8], LocalizedString(@"Paper")];
//            } else if ( i==3) { // 成交额
//                NSString *quamtity = [NSString stringWithFormat:@"%.12f", [_model.price doubleValue]*[_model.quantity doubleValue]];
//                label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:quamtity RoundingMode:NSRoundDown scale:8], _model.quoteTokenName];
//            } else if ( i==4) { // 手续费
//                if ([_model.fee floatValue] == 0) {
//                    label.text = @"0";
//                } else {
//                    label.text = [NSString stringWithFormat:@"%@%@", [KDecimal decimalNumber:_model.fee RoundingMode:NSRoundDown scale:8], _model.feeTokenName];
//                }
//            } else if (i == 5) {
//                label.text = KString(_model.tradeId);
//            }
//        }
//    } else if (_model.indexType == SymbolTypeContract) {
//
//        XXSymbolModel *symbolModel = KMarket.contractSymbolsDict[_model.symbolId];
//        NSString *unit = KString(symbolModel.baseTokenFutures.displayTokenId);
//
//        for (NSInteger i=0; i < self.labelsArray.count; i ++) {
//            XXLabel *label = self.labelsArray[i];
//            if (i == 0) { // 时间
//                label.text = [NSString dateStringFromTimestampWithTimeTamp:[_model.time longLongValue]];
//            } else if ( i==1) { // 成交价
//                label.text = [NSString stringWithFormat:@"%@ %@", _model.price, unit];
//            } else if ( i==2) { // 数量
//                label.text = [NSString stringWithFormat:@"%@ %@", _model.quantity, LocalizedString(@"Paper")];
//            } else if ( i==3) { // 成交额
//                label.text = [NSString stringWithFormat:@"%@ %@", _model.executedAmount, _model.quoteTokenName];
//            } else if ( i==4) { // 手续费
//                if ([_model.fee floatValue] == 0) {
//                    label.text = @"0";
//                } else {
//                    label.text = [NSString stringWithFormat:@"%@ %@", [KDecimal decimalNumber:_model.fee RoundingMode:NSRoundDown scale:8], _model.feeTokenName];
//                }
//            }
//        }
//    }
}


/** 复制按钮 */
- (XXButton *)coppButton {
    if (_coppButton == nil) {
        MJWeakSelf
        _coppButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - (24 + K375(44)), 135, 24 + K375(44), 25) block:^(UIButton *button) {
            
            if (weakSelf.model.tradeId.length > 0) {
                UIPasteboard *pab = [UIPasteboard generalPasteboard];
                [pab setString:weakSelf.model.tradeId];
                [MBProgressHUD showSuccessMessage:LocalizedString(@"CopySuccessfully")];
            }
        }];
        [_coppButton setImage:[UIImage textImageName:@"paste"] forState:UIControlStateNormal];
    }
    return _coppButton;
}

+ (CGFloat)getCellHeight {
    return 171;
}
@end
