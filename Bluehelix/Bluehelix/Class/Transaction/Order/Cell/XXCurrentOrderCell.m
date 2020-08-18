//
//  XXCurrentOrderCell.m
//  Bhex
//
//  Created by BHEX on 2018/7/22.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXCurrentOrderCell.h"

@interface XXCurrentOrderCell ()

/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 日期标签 */
@property (strong, nonatomic) XXLabel *dateLabel;

/** 撤单按钮 */
@property (strong, nonatomic) XXButton *cancelButton;

/** 价格标签 */
@property (strong, nonatomic) XXLabel *priceNameLabel;

/** 价格值标签 */
@property (strong, nonatomic) XXLabel *pricelValueLabel;

/** 数量标签 */
@property (strong, nonatomic) XXLabel *numberNameLabel;

/** 数量值标签 */
@property (strong, nonatomic) XXLabel *numberValueLabel;

/** 成交数量标签 */
@property (strong, nonatomic) XXLabel *finishNumberNameLabel;

/** 成效数量值标签 */
@property (strong, nonatomic) XXLabel *finishNumberValueLabel;

@end

@implementation XXCurrentOrderCell

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
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.numberNameLabel];
    [self.contentView addSubview:self.numberValueLabel];
    [self.contentView addSubview:self.priceNameLabel];
    [self.contentView addSubview:self.pricelValueLabel];
    [self.contentView addSubview:self.finishNumberNameLabel];
    [self.contentView addSubview:self.finishNumberValueLabel];
    [self.contentView addSubview:self.cancelButton];
    [self.contentView addSubview:self.lineView];
}

#pragma mark - 2. 模型赋值
- (void)setModel:(XXOrderModel *)model {
    _model = model;
    
    NSString *nameOne = @"";
    NSString *nameTwo = @"";
    UIColor *textColor;
    // 是否限价
    if ([_model.side isEqualToString:@"BUY"]) {
        nameOne = LocalizedString(@"Buy");
        textColor = kGreen100;
    } else {
        nameOne = LocalizedString(@"Sell");
        textColor = kRed100;
    }
    nameTwo = [NSString stringWithFormat:@"   %@/%@", _model.baseTokenName, _model.quoteTokenName];
    
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":nameOne, @"color":textColor, @"font":kFontBold14};
    itemsArray[1] = @{@"string":nameTwo, @"color":kDark100, @"font":kFontBold14};
    self.nameLabel.attributedText = [NSString mergeStrings:itemsArray];
    
    NSString *timeString = [NSString dateStringFromTimestampWithTimeTamp:[_model.time longLongValue]];
    self.dateLabel.text = timeString;
    
    NSInteger numberPrecision = [KMarket getNumberPrecisionWithSymbolId:_model.symbolId quoteName:_model.quoteTokenName];
    NSInteger pricePrecision = [KMarket getPricePrecisionWithSymbolId:_model.symbolId quoteName:_model.quoteTokenName];

    self.pricelValueLabel.text = [NSString stringWithFormat:@"%@ %@", [KDecimal decimalNumber:_model.price RoundingMode:NSRoundDown scale:pricePrecision], _model.quoteTokenName];
    self.numberValueLabel.text = [NSString stringWithFormat:@"%@ %@", [KDecimal decimalNumber:_model.origQty RoundingMode:NSRoundDown scale:numberPrecision], _model.baseTokenName];
    self.finishNumberValueLabel.text = [NSString stringWithFormat:@"%@ %@", [KDecimal decimalNumber:_model.executedQty RoundingMode:NSRoundDown scale:numberPrecision], _model.baseTokenName];
}

#pragma mark - 3. 撤单按钮点击事件
- (void)cancelButtonClick:(UIButton *)sender {
    
    sender.enabled = NO;
    if (self.type == SymbolTypeCoinMargin) {
        //杠杆订单撤单
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"client_order_id"] = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
        //params[@"account_id"] = KUser.defaultAccountId;
        params[@"order_id"] = self.model.orderId;
        [MBProgressHUD showActivityMessageInView:@""];
//        [HttpManager order_PostWithPath:@"v1/margin/order/cancel" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//            [MBProgressHUD hideHUD];
//            sender.enabled = YES;
//            if (code == 0) {
//                [MBProgressHUD showSuccessMessage:LocalizedString(@"OrderCanceled")];
//                if (self.deleteBlock) {
//                    self.deleteBlock(self.model);
//                }
//            } else {
//                [MBProgressHUD showErrorMessage:msg];
//            }
//        }];
    }else{
        //币币订单撤单
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"client_order_id"] = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
//        params[@"account_id"] = KUser.defaultAccountId;
//        params[@"order_id"] = self.model.orderId;
//        [MBProgressHUD showActivityMessageInView:@""];
//        [HttpManager order_PostWithPath:@"order/cancel" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//            [MBProgressHUD hideHUD];
//            sender.enabled = YES;
//            if (code == 0) {
//                [MBProgressHUD showSuccessMessage:LocalizedString(@"OrderCanceled")];
//                if (self.deleteBlock) {
//                    self.deleteBlock(self.model);
//                }
//            } else {
//                [MBProgressHUD showErrorMessage:msg];
//            }
//        }];
    }
}

#pragma mark - || 懒加载
/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 12, K375(200), 24) font:kFontBold14 textColor:kGreen100];
    }
    return _nameLabel;
}

/** 日期标签 */
- (XXLabel *)dateLabel {
    if (_dateLabel == nil) {
        _dateLabel = [XXLabel labelWithFrame:CGRectMake(kScreen_Width - K375(200) - KSpacing, self.nameLabel.top, K375(200), self.nameLabel.height) font:kFont10 textColor:kDark50];
        _dateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _dateLabel;
}

/** 数量标签 */
- (XXLabel *)numberNameLabel {
    if (_numberNameLabel == nil) {
        _numberNameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.nameLabel.frame) + 4, K375(88), 16) font:kFont12 textColor:kDark50];
        _numberNameLabel.text = [NSString stringWithFormat:@"%@:",LocalizedString(@"OrderTotal")];
    }
    return _numberNameLabel;
}

/** 数量值标签 */
- (XXLabel *)numberValueLabel {
    if (_numberValueLabel == nil) {
        _numberValueLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.numberNameLabel.frame), self.numberNameLabel.top, K375(200), self.numberNameLabel.height) font:kFont12 textColor:kDark100];
    }
    return _numberValueLabel;
}

/** 价格标签 */
- (XXLabel *)priceNameLabel {
    if (_priceNameLabel == nil) {
        _priceNameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.numberNameLabel.frame), K375(88), 16) font:kFont12 textColor:kDark50];
        _priceNameLabel.text = [NSString stringWithFormat:@"%@:",LocalizedString(@"Price")];
    }
    return _priceNameLabel;
}

/** 价格值标签 */
- (XXLabel *)pricelValueLabel {
    if (_pricelValueLabel == nil) {
        _pricelValueLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.priceNameLabel.frame), self.priceNameLabel.top, K375(200), self.priceNameLabel.height) font:kFont12 textColor:kDark100];
    }
    return _pricelValueLabel;
}

/** 成交数量标签 */
- (XXLabel *)finishNumberNameLabel {
    if (_finishNumberNameLabel == nil) {
        _finishNumberNameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.priceNameLabel.frame), K375(88), 16) font:kFont12 textColor:kDark50];
        _finishNumberNameLabel.text = [NSString stringWithFormat:@"%@:",LocalizedString(@"TradingVolume")];
    }
    return _finishNumberNameLabel;
}

/** 成效数量值标签 */
- (XXLabel *)finishNumberValueLabel {
    if (_finishNumberValueLabel == nil) {
        _finishNumberValueLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.finishNumberNameLabel.frame), self.finishNumberNameLabel.top, K375(200), self.finishNumberNameLabel.height) font:kFont12 textColor:kDark100];
    }
    return _finishNumberValueLabel;
}

/** 撤单按钮 */
- (XXButton *)cancelButton {
    if (_cancelButton == nil) {
        MJWeakSelf
        _cancelButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - K375(62), self.finishNumberNameLabel.centerY - 24, K375(62), 48) block:^(UIButton *button) {
            [weakSelf cancelButtonClick:button];
        }];
        [_cancelButton setImage:[[UIImage textImageName:@"icon_dismiss_0"] alpha:0.5] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, 104, kScreen_Width - KSpacing, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 105;
}
@end
