//
//  XXTradeView.m
//  Bhex
//
//  Created by Bhex on 2019/1/8.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXTradeView.h"
#import "YBPopupMenu.h"

@interface XXTradeView ()

/** 交易盘宽度 */
@property (assign, nonatomic) CGFloat itemWidth;

/** 进入详情按钮 */
@property (strong, nonatomic) XXButton *rightActionButton;


/** 分割线 */
@property (strong, nonatomic) UIView *lineView;

@property (nonatomic, assign) XXTradeViewType tradeViewType;

@end

@implementation XXTradeView
- (instancetype)initWithFrame:(CGRect)frame withType:(XXTradeViewType)tradeType{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhite100;
        self.tradeViewType = tradeType;
        if (self.tradeViewType == XXTradeViewTypeLever) {
            self.isHaveRiskBar = YES;
        }else{
            self.isHaveRiskBar = NO;
        }
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhite100;
        [self setupUI];
    }
    return self;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    self.itemWidth = kScreen_Width - KSpacing * 2 - K375(144) -K375(15);
    if (self.isHaveRiskBar) {
        [self addSubview:self.leverRiskBar];
        [self addSubview:self.leverMoreButton];
    }
    [self addSubview:self.titleButton];
    [self addSubview:self.riseFallLabel];
    [self addSubview:self.rightActionButton];
    [self addSubview:self.lineView];
    
//    [self addOptionTimeView];
    [self.headerView addSubview:self.typeButton];
    [self.headerView addSubview:self.fixedPriceButton];
    [self.headerView addSubview:self.priceView];
    [self.headerView addSubview:self.aboutPriceLabel];
    [self.headerView addSubview:self.amountView];
    [self.headerView addSubview:self.availableNameLabel];
    [self.headerView addSubview:self.availableValueLabel];
    [self.headerView addSubview:self.availableMoneyLabel];
    [self.headerView addSubview:self.progressView];
    [self.headerView addSubview:self.tradeTitleLabel];
    [self.headerView addSubview:self.tradeNameLabel];
    [self.headerView addSubview:self.tradeValueLabel];
    if (self.tradeViewType == XXTradeViewTypeLever) {
        [self.headerView addSubview:self.transferButton];
    }
    [self.headerView addSubview:self.actionButton];
    
    [self.headerView addSubview:self.depthView];
    
    [self addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    
}

- (void)addOptionTimeView {

}

#pragma mark - 2. 标题按钮赋值
- (void)setTitleButtonTitle:(NSString *)title {
    
    [self.titleButton setTitle:title forState:UIControlStateNormal];
    self.titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [self.titleButton setImage:[UIImage textImageName:@"left_more"]  forState:UIControlStateNormal];
}

#pragma mark - 3.1 跳转详情
- (void)tradeViewPushToDetailVC {
    
}

#pragma mark - 3.2 标题按钮点击事件
- (void)tradeViewTitleButtonAction:(UIButton *)sender {
    
}

#pragma mark - 4. 交易类型【买、买切换】
- (void)tradeViewSwitchTradeType {
    
}

#pragma mark - 5. 价格类型按钮点击事件【限价、市价】
- (void)tradeViewTradePriceTypeButtonAction:(UIButton *)sender {
    
}

#pragma mark - 6. 价格变化
- (void)tradeViewPriceViewTextChange:(UITextField *)textField {
    
}

#pragma mark - 7. 数量变化
- (void)tradeViewAmountViewTextChange:(UITextField *)textField {
    
}

#pragma mark - 8. 滑块值变化
- (void)progressProportionChenge:(double)proportion {
    
}

#pragma mark - 9. 深度按钮点击事件
- (void)depthViewButtonAction {
    
}

#pragma mark - 10. 买入、卖出、登录事件按钮
- (void)tradeActionButtonAction:(UIButton *)sender {
    
}
#pragma mark - 11 杠杆风险
- (void)riskRatioAction:(UIButton *)sender{
    
}
#pragma mark - 12. 借还币 事件按钮
- (void)borrowOrReturnAction:(UIButton *)sender{
    
}
#pragma mark  13.杠杆更多按钮事件
- (void)leverMoreButtonAction:(UIButton *)sender{
    
}
#pragma mark  14. 资金划转按钮事件
- (void)transferButtonAction:(UIButton *)sender{
    
}

#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  nil;
}

#pragma mark - 10. 选择价格后刷新数据
- (void)selectPrice:(NSString *)price ReloadAmount:(double)amount isBuy:(BOOL)isBuy {
    
}
#pragma mark set/get
- (void)setIsHaveRiskBar:(BOOL)isHaveRiskBar{
    _isHaveRiskBar = isHaveRiskBar;
    if (!_isHaveRiskBar) {
        self.leverRiskBar.hidden = YES;
        [self setNeedsDisplay];
    }
}
#pragma mark - || 懒加载
- (XXTradeLeverBar *)leverRiskBar{
    MJWeakSelf
    if (!_leverRiskBar) {
        _leverRiskBar = [[XXTradeLeverBar alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, 48)];
        _leverRiskBar.riskRatioButtonActionBlock = ^(UIButton * _Nonnull action) {
            [weakSelf riskRatioAction:action];
        };
        _leverRiskBar.XXBorrowOrReturnButtonActionBlock = ^(UIButton * _Nonnull action){
            [weakSelf borrowOrReturnAction:action];
        };
    }
    return _leverRiskBar;
}
/** 标题按钮 */
- (XXButton *)titleButton {
    if (_titleButton == nil) {
        MJWeakSelf
        _titleButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, self.isHaveRiskBar ? 48 :0, K375(220), 44) title:@"" font:kFontBold16 titleColor:KNavigationBar_TitleColor block:^(UIButton *button) {
            [weakSelf tradeViewTitleButtonAction:button];
        }];
    }
    return _titleButton;
}

/** 涨跌幅标签 */
- (XXLabel *)riseFallLabel {
    if (_riseFallLabel == nil) {
        _riseFallLabel = [XXLabel labelWithFrame:CGRectMake(40, self.isHaveRiskBar ? 48 :0,self.isHaveRiskBar ? kScreen_Width - 90 - 44 : kScreen_Width - 90, self.titleButton.height) text:@"" font:kFont14 textColor:kGreen100 alignment:NSTextAlignmentRight];
    }
    return _riseFallLabel;
}

/** 进入详情按钮 */
- (XXButton *)rightActionButton {
    if (_rightActionButton == nil) {
        MJWeakSelf
        _rightActionButton = [XXButton buttonWithFrame:CGRectMake(self.isHaveRiskBar ? kScreen_Width  - 45- 44 :kScreen_Width  - 60, self.isHaveRiskBar ? 48 :0, self.isHaveRiskBar ? 44 :60, self.titleButton.height) block:^(UIButton *button) {
            [weakSelf tradeViewPushToDetailVC];
        }];
        [_rightActionButton setImage:[UIImage textImageName:@"klineNav_0"] forState:UIControlStateNormal];
    }
    return _rightActionButton;
}

- (XXButton *)leverMoreButton{
    MJWeakSelf
    if (!_leverMoreButton) {
        _leverMoreButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width  - 45, self.isHaveRiskBar ? 48 :0, 44, self.titleButton.height) block:^(UIButton *button) {
            [weakSelf leverMoreButtonAction:self.leverMoreButton];
        }];
        [_leverMoreButton setImage:[UIImage textImageName:@"moreActions_0"] forState:UIControlStateNormal];
    }
    return _leverMoreButton;
}
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleButton.frame), kScreen_Width, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

/** 头视图 */
- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 420)];
        _headerView.backgroundColor = kWhite100;
    }
    return _headerView;
}

/** 表示图 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,self.isHaveRiskBar ? 45 +48 : 45, kScreen_Width, self.isHaveRiskBar ? self.height -45 -48 : self.height - 45) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhite100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

//- (XXOptionTimeView *)optionTimeView {
//    if (_optionTimeView == nil) {
//        _optionTimeView = [[XXOptionTimeView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
//    }
//    return _optionTimeView;
//}

/** 买卖方式按钮 */
- (XXBuySellButton *)typeButton {
    if (_typeButton == nil) {
        _typeButton = [[XXBuySellButton alloc] initWithFrame:CGRectMake(KSpacing, 0, self.itemWidth, 40)];
        MJWeakSelf
        _typeButton.buySellBlock = ^(NSInteger index) {
   //TODO
//            if (KTrade.currentModel.type == SymbolTypeCoin) {
//                if ((index == 0 && KTrade.coinIsSell == NO) || (index == 1 && KTrade.coinIsSell == YES)) {
//
//                } else {
//                    KTrade.coinIsSell = index == 0 ? NO : YES;
//                    [weakSelf tradeViewSwitchTradeType];
//                }
//            } else if (KTrade.currentModel.type == SymbolTypeOption) {
//                if ((index == 0 && KTrade.optionIsSell == NO) || (index == 1 && KTrade.optionIsSell == YES)) {
//
//                } else {
//                    KTrade.optionIsSell = index == 0 ? NO : YES;
//                    [weakSelf tradeViewSwitchTradeType];
//                }
//            }else if (KTrade.currentModel.type == SymbolTypeCoinMargin ){
//                if ((index == 0 && KTrade.coinLeverIsSell == NO) || (index == 1 && KTrade.coinLeverIsSell == YES)) {
//
//                } else {
//                    KTrade.coinLeverIsSell = index == 0 ? NO : YES;
//                    [weakSelf tradeViewSwitchTradeType];
//                }
//            }
        };
    }
    return _typeButton;
}

- (XXButton *)fixedPriceButton {
    if (_fixedPriceButton == nil) {
        MJWeakSelf
        _fixedPriceButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.typeButton.frame) + 16, self.typeButton.width, 24) title:LocalizedString(@"Limit") font:kFont14 titleColor:kDark100 block:^(UIButton *button) {
            [weakSelf tradeViewTradePriceTypeButtonAction:button];
        }];
        _fixedPriceButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_fixedPriceButton setImage:[UIImage textImageName:@"lineLow_0"] forState:UIControlStateNormal];
        [_fixedPriceButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -_fixedPriceButton.imageView.size.width, 0, _fixedPriceButton.imageView.size.width)];
        [_fixedPriceButton setImageEdgeInsets:UIEdgeInsetsMake(0, _fixedPriceButton.width - 20, 0, -(_fixedPriceButton.width - 20))];
    }
    return _fixedPriceButton;
}

/** 价格视图 */
- (XXBusinessPriceView *)priceView {
    if (_priceView == nil) {
        _priceView = [[XXBusinessPriceView alloc] initWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.fixedPriceButton.frame) + 8, self.typeButton.width, 40)];
        _priceView.textField.width = _priceView.width - K375(70);
        [_priceView.textField addTarget:self
                                 action:@selector(tradeViewPriceViewTextChange:)
                       forControlEvents:UIControlEventEditingChanged];
        MJWeakSelf
        _priceView.priceValueChange = ^{
            [weakSelf endEditing:YES];
            [weakSelf tradeViewPriceViewTextChange:weakSelf.priceView.textField];
        };
    }
    return _priceView;
}

/** 折合价钱 */
- (XXLabel *)aboutPriceLabel {
    if (_aboutPriceLabel == nil) {
        _aboutPriceLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing + 2, CGRectGetMaxY(self.priceView.frame) + 6, self.typeButton.width, 18) font:kFont12 textColor:kDark50];
    }
    return _aboutPriceLabel;
}

/** 数量视图 */
- (XXBusinessAmountView *)amountView {
    if (_amountView == nil) {
        _amountView = [[XXBusinessAmountView alloc] initWithFrame:CGRectMake(self.priceView.left, CGRectGetMaxY(self.aboutPriceLabel.frame) + 12, self.priceView.width, 40)];
        [_amountView.textField addTarget:self
                                  action:@selector(tradeViewAmountViewTextChange:)
                        forControlEvents:UIControlEventEditingChanged];
    }
    return _amountView;
}

/** 可用余额 */
- (XXLabel *)availableNameLabel {
    if (_availableNameLabel == nil) {
        _availableNameLabel = [XXLabel labelWithFrame:CGRectMake(self.priceView.left, CGRectGetMaxY(self.amountView.frame) + 6, self.priceView.width, 24) font:kFont12 textColor:kDark50];
        _availableNameLabel.text = LocalizedString(@"Available");
    }
    return _availableNameLabel;
}

/** 可用余额 */
- (XXLabel *)availableValueLabel {
    if (_availableValueLabel == nil) {
        _availableValueLabel = [XXLabel labelWithFrame:CGRectMake(self.priceView.left, self.availableNameLabel.top, self.priceView.width, self.availableNameLabel.height) font:kFont12 textColor:kDark50];
        _availableValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _availableValueLabel;
}

- (XXLabel *)availableMoneyLabel {
    if (_availableMoneyLabel == nil) {
        _availableMoneyLabel = [XXLabel labelWithFrame:CGRectMake(self.priceView.left, CGRectGetMaxY(self.availableValueLabel.frame), self.priceView.width, 14) font:kFont10 textColor:kDark50];
        _availableMoneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _availableMoneyLabel;
}

/** 进度条 */
- (XXBusinessProgressView *)progressView {
    if (_progressView == nil) {
        _progressView = [[XXBusinessProgressView alloc] initWithFrame:CGRectMake(self.priceView.left, CGRectGetMaxY(self.availableMoneyLabel.frame) + 6, self.priceView.width, 17)];
        MJWeakSelf
        _progressView.progressProportionBlock = ^(double proportion) {
            [weakSelf progressProportionChenge:proportion];
        };
    }
    return _progressView;
}
- (XXLabel *)tradeTitleLabel{
    if (!_tradeTitleLabel) {
        _tradeTitleLabel = [XXLabel labelWithFrame:CGRectMake(self.priceView.left, CGRectGetMaxY(self.progressView.frame) + 16, 64, 16) text:LocalizedString(@"MoneyAmount") font:kFontBold14 textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _tradeTitleLabel;
}

/** 金额名称标签 */
- (XXLabel *)tradeNameLabel {
    if (_tradeNameLabel == nil) {
        _tradeNameLabel = [XXLabel labelWithFrame:CGRectMake(self.tradeTitleLabel.right, CGRectGetMaxY(self.progressView.frame) + 16, self.priceView.width - 64, 16) text:@"--" font:kFontBold14 textColor:kDark100];
        _tradeNameLabel.textAlignment = NSTextAlignmentRight;
    }
    return _tradeNameLabel;
}

/** 交易金额 */
- (XXLabel *)tradeValueLabel {
    if (_tradeValueLabel == nil) {
        _tradeValueLabel = [XXLabel labelWithFrame:CGRectMake(self.tradeTitleLabel.right, CGRectGetMaxY(self.tradeNameLabel.frame) + 8, self.priceView.width - 64, 12) text:@"--" font:kFont10 textColor:kDark50];
        _tradeValueLabel.textAlignment = NSTextAlignmentRight;
    }
    return _tradeValueLabel;
}
/** 资金划转按钮 */
- (XXButton *)transferButton {
    if (_transferButton == nil) {
        MJWeakSelf
        _transferButton = [XXButton buttonWithFrame:CGRectMake(16, self.tradeTitleLabel.bottom + 8, self.priceView.width, 20) title:LocalizedString(@"AssetTransfer") font:kFontBold12 titleColor:kBlue100 block:^(UIButton *button) {
            [weakSelf transferButtonAction:button];
        }];
        [_transferButton setImage:[UIImage mainImageName:@"trade_0"] forState:UIControlStateNormal];
        _transferButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _transferButton;
}

/** 买卖 登录按钮 */
- (XXButton *)actionButton {
    if (_actionButton == nil) {
        MJWeakSelf
        _actionButton = [XXButton buttonWithFrame:CGRectMake(self.priceView.left, CGRectGetMaxY(self.tradeValueLabel.frame) + 24, self.priceView.width, 40) title:LocalizedString(@"Login") font:kFontBold14 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf tradeActionButtonAction:button];
        }];
        _actionButton.backgroundColor = kGreen100;
        _actionButton.layer.cornerRadius = 2;
        _actionButton.layer.masksToBounds = YES;
    }
    return _actionButton;
}

/** 盘口深度视图 */
- (XXDepthView *)depthView {
    if (_depthView == nil) {
        _depthView = [[XXDepthView alloc] initWithFrame:CGRectMake(kScreen_Width - K375(144) - KSpacing, 7, K375(144) + KSpacing, self.headerView.height)];
        MJWeakSelf
        _depthView.depthPriceBlcok = ^(NSString *price, double sumAmount, BOOL isBuy) {
            
            if (KTrade.currentModel.type == SymbolTypeCoin || KTrade.currentModel.type == SymbolTypeCoinMargin) {

                [weakSelf selectPrice:price ReloadAmount:sumAmount isBuy:isBuy];
            }
        };
        
        _depthView.depthActionBlcok = ^{
            [weakSelf depthViewButtonAction];
        };
    }
    return _depthView;
}
@end
