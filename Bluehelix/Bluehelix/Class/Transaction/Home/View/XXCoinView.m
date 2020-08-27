//
//  XXCoinView.m
//  Bhex
//
//  Created by Bhex on 2019/1/8.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXCoinView.h"
#import "XXBitcoinDetailVC.h"
#import "XXAssetModel.h"
#import "XXPickerView.h"
#import "XXSwitchCoinView.h"
#import "XXCoinTradeSectionHeaderView.h"
#import "XXCurrentOrderCell.h"
#import "XXTradeCoinData.h"
#import "XXMenuView.h"
#import "XXHistoryOderCell.h"
#import "XXOrderDetailVC.h"
#import "XXEmptyView.h"
#import "XYHAlertView.h"

@interface XXCoinView () <XXTradeDataDelegate, XXMenuViewDelegate, YBPopupMenuDelegate> {
    BOOL _isShowing;
    BOOL _isUp;
}

/** 数据 */
@property (strong, nonatomic) XXTradeCoinData *data;

/** 余额 */
@property (strong, nonatomic) NSString *balance;

/** 最大交易量 */
@property (assign, nonatomic) double maxNumber;

/** 是否是市价 */
@property (assign, nonatomic) BOOL isMarketPrice;

/** 菜单视图 */
@property (strong, nonatomic) XXMenuView *meunView;

/** 区头视图 */
@property (strong, nonatomic) XXCoinTradeSectionHeaderView *sectionView;

/** 失败视图 */
@property (nonatomic, strong) XXFailureView *failureView;

/** 区空提示 */
@property (nonatomic, strong) XXEmptyView *emptyView;

@end

@implementation XXCoinView
static NSString *identifir = @"TradeXXCurrentOrderCell";
static NSString *identifir1 = @"TradeXXHistoryOrderCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.backgroundColor = kWhite100;
        self.meunView.delegate = self;
        [self.sectionView addSubview:self.meunView];

        [self.tableView registerClass:[XXCurrentOrderCell class] forCellReuseIdentifier:identifir];
        [self.tableView registerClass:[XXHistoryOderCell class] forCellReuseIdentifier:identifir1];

        MJWeakSelf
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{

            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
                
                if (KUserSocket.reqModel.httpBlock) {
                    KUserSocket.reqModel.httpBlock();
                }
                
                if (weakSelf.meunView.indexClass == 0) {
                    if (weakSelf.data.reqModel.httpBlock) {
                        weakSelf.data.reqModel.httpBlock();
                    }
                } else if (weakSelf.meunView.indexClass == 1) {
                    weakSelf.data.isHistoryFailure = NO;
                    [weakSelf.tableView reloadData];
                    [weakSelf loadDataOfHistoryOrderIsUserAction:YES];
                }
        }];

        self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.meunView.indexClass == 1) {
                [weakSelf.data loadNextPageHistoryOrder];
            } else {
                [weakSelf.tableView.mj_header endRefreshing];
                [weakSelf.tableView.mj_footer endRefreshing];
            }
        }];
        
        // 1. 接收到新币对通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationSwitchSymbol) name:Switch_TradeSymbol_NotificationName object:nil];

        // 2. 退出登录通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationSwitchSymbol) name:Login_Out_NotificationName object:nil];

        // 3. 登录通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationSwitchSymbol) name:Login_In_NotificationName object:nil];

        // 4. 从无到有交易币对通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveHaveTradeSymbolNotificationName) name:Have_TradeSymbol_NotificationName object:nil];
    }
    return self;
}

#pragma mark - 1.1 展示
- (void)show {
    _isShowing = YES;
    if (KTrade.coinTradeModel) {
        [self receiveNotificationSwitchSymbol];
    }
}

#pragma mark - 1.2 从无到有交易币对通知
- (void)receiveHaveTradeSymbolNotificationName {
    if (_isShowing) {
        [self receiveNotificationSwitchSymbol];
    }
}

#pragma mark - 2. 消失
- (void)dismiss {
    if (_isShowing) {
        _isShowing = NO;
        KTrade.delegate = nil;
        [KTrade closeSocket];

        if (self.data) {
            [self.data dismiss];
        }
    }
}

#pragma mark - 3.0 接收切换币对通知
- (void)receiveNotificationSwitchSymbol {

    if (!_isShowing) {
        return;
    }

    // 1. 初始化盘口数据
    [self initDeptchData];

    // 2. 初始化交易数据
    [self initTradeData];

    // 3. 处理订单列表
    if (self.data.currentModelsArray && (![self.data.symbolId isEqualToString:KTrade.coinTradeModel.symbolId])) {
        [self.data.currentModelsArray removeAllObjects];
        self.data.currentModelsArray = nil;
    }
    if (self.data.historyModelsArray && (![self.data.symbolId isEqualToString:KTrade.coinTradeModel.symbolId])) {
        [self.data.historyModelsArray removeAllObjects];
        self.data.historyModelsArray = nil;
    }
    self.data.isHistoryFailure = NO;
    self.data.symbolId = KTrade.coinTradeModel.symbolId;
    [self.tableView reloadData];

    // 4. 加载委托订单
    [self loadDataOrderOfCurrentOrder];
    [self loadDataOfHistoryOrderIsUserAction:NO];
}

#pragma mark - 3.1 初始盘口数据
- (void)initDeptchData {

    // 1. 合并 价格 和 数量单位
    NSArray *digitMergeArray = [KTrade.coinTradeModel.digitMerge componentsSeparatedByString:@","];
    KTrade.priceDigit = [KDecimal scale:[digitMergeArray lastObject]];
    KTrade.numberDigit = [KDecimal scale:KTrade.coinTradeModel.basePrecision];

    // 1. 深度图单位赋值
    self.depthView.priceLabel.text = [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Price"), KTrade.coinTradeModel.quoteTokenName];
    
    NSArray *namesArray = @[
        [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Amount"), KTrade.coinTradeModel.baseTokenName],
        [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Cumulative"), KTrade.coinTradeModel.baseTokenName]];
    self.depthView.numberLabel.text = namesArray[KTrade.coinDepthAmount];

    // 2. 合并深度选项数组 和 位数数组
    if (self.depthView.itemsArray) {
        [self.depthView.itemsArray removeAllObjects];
        [self.depthView.valuesArray removeAllObjects];
    } else {
        self.depthView.itemsArray = [NSMutableArray array];
        self.depthView.valuesArray = [NSMutableArray array];
    }

    NSArray *digsArray = [KTrade.coinTradeModel.digitMerge componentsSeparatedByString:@","];
    for (NSInteger i=0; i < digsArray.count; i ++) {
        NSString *key = digsArray[i];
        if ([key isEqualToString:KTrade.coinTradeModel.minPricePrecision]) {
            self.depthView.numberIndex = i;
        }
        NSInteger number = [KDecimal scale:key];
        if (number > 0) {
            [self.depthView.itemsArray addObject:[NSString stringWithFormat:@"%zd%@", number, LocalizedString(@"Decimal")]];
        } else {
            NSString *kkeeyy = [NSString stringWithFormat:@"%zd", number];
            [self.depthView.itemsArray addObject:LocalizedString(kkeeyy)];
        }
    
        [self.depthView.valuesArray addObject:@(number)];
    }
    [self.depthView reloadNumberButtonTitle];

    // 3. 类型赋值
    self.depthView.orderIndex = 0;
    
    [self.depthView.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

    // 4. 设置代理 订阅数据
    KTrade.delegate = self;
    [KTrade openSocketWithSymbolModel:KTrade.coinTradeModel];
}

#pragma mark - 3.2 初始化交易数据
- (void)initTradeData {

    // 1. 标题赋值
    [self setTitleButtonTitle:[NSString stringWithFormat:@" %@/%@", KTrade.coinTradeModel.baseTokenName, KTrade.coinTradeModel.quoteTokenName]];

    // 2. 判断是否买入 还是 卖出
    if (KTrade.coinIsSell) { // 卖出
        [self.typeButton changeIndex:1];
    } else { // 买入
        [self.typeButton changeIndex:0];
    }

    // 3. 价格视图
    [self initPriceViewData];

    // 4. 数量视图
    [self initAmountViewData];

    // 5. 进度条设置为0
    [self.progressView reloadUI];

    // 6. 清除可用余额
    self.availableValueLabel.text = [NSString stringWithFormat:@"--%@",KTrade.coinIsSell ? KTrade.coinTradeModel.baseTokenName : KTrade.coinTradeModel.quoteTokenName];

    // 7. 交易额清空
    self.tradeNameLabel.text = @"--";
    self.tradeValueLabel.text = @"--";

    // 8. 操作按钮
    self.actionButton.backgroundColor = KTrade.coinIsSell ? kRed100 : kGreen100;

    // 9. 是否登录
        MJWeakSelf
        if (KTrade.coinIsSell) {
            [self.actionButton setTitle:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"SELL"), KTrade.coinTradeModel.baseTokenName] forState:UIControlStateNormal];
        } else {
            [self.actionButton setTitle:[NSString stringWithFormat:@"%@ %@", LocalizedString(@"BUY"), KTrade.coinTradeModel.baseTokenName] forState:UIControlStateNormal];
        }

        [self.data loadAssetsDataBlock:^{
            if (weakSelf.balance.doubleValue != weakSelf.data.assetsModel.free.doubleValue) {
                [weakSelf updateBalance];
            }
        }];
        [self updateBalance];

        self.priceView.textField.enabled = YES;
        self.amountView.textField.enabled = YES;
        self.sectionView.actionButton.hidden = NO;
}

#pragma mark - 3.3 初始化价格视图数据
- (void)initPriceViewData {

    self.priceView.tokenNameLabel.text = KTrade.coinTradeModel.quoteTokenName;

    if (KTrade.coinTradeModel.quote && !self.isMarketPrice) {

        // 最新价
        self.priceView.textField.text = [KDecimal decimalNumber:KString(KTrade.coinTradeModel.quote.close) RoundingMode:NSRoundDown scale:[KDecimal scale:KTrade.coinTradeModel.minPricePrecision]];

        // 法币
        self.aboutPriceLabel.text = [[RatesManager shareRatesManager] getRatesWithToken:KTrade.coinTradeModel.quoteTokenId priceValue:[self.priceView.textField.text doubleValue]];

    } else {
        self.priceView.textField.text = @"";
        self.aboutPriceLabel.text = @"";
    }

    if (self.isMarketPrice) {
        self.priceView.marketPriceLable.hidden = NO;
    } else {
        self.priceView.marketPriceLable.hidden = YES;
    }
}

#pragma mark - 3.4 初始化数量视图数据
- (void)initAmountViewData {

    if (self.isMarketPrice && !KTrade.coinIsSell) {

        self.amountView.textField.placeholder = LocalizedString(@"MoneyAmount");
        self.amountView.textField.text = @"";
        self.amountView.tokenNameLabel.text = KTrade.coinTradeModel.quoteTokenName;

    } else {
        self.amountView.textField.placeholder = LocalizedString(@"Amount");
        self.amountView.textField.text = @"";
        self.amountView.tokenNameLabel.text = KTrade.coinTradeModel.baseTokenName;
    }

    self.progressView.proportion = 0.0;
}

#pragma mark - 3.5 更新余额
- (void)updateBalance {

    self.balance = self.data.assetsModel.free;
    NSString *balanceValue = [KDecimal decimalNumber:self.balance RoundingMode:NSRoundDown scale:8];
    if (balanceValue.length > 21) {
        balanceValue = [balanceValue substringToIndex:balanceValue.length - 9];
    } else if (balanceValue.length > 12) {
        balanceValue = [balanceValue substringToIndex:12];
    }

    NSString *tokenName = KTrade.coinIsSell ? KTrade.coinTradeModel.baseTokenName : KTrade.coinTradeModel.quoteTokenName;
    self.availableValueLabel.text = [NSString stringWithFormat:@"%@%@", balanceValue, tokenName];
    self.availableMoneyLabel.text = [[RatesManager shareRatesManager] getRatesWithToken:tokenName priceValue:[self.balance doubleValue]];
    if (KTrade.coinIsSell) {
        self.maxNumber = [self.balance doubleValue];
    } else {
        if (self.isMarketPrice) {
            self.maxNumber = [self.balance doubleValue];
        } else {
            if ([self.priceView.textField.text doubleValue] != 0) {
                self.maxNumber = [self.balance doubleValue] / [self.priceView.textField.text doubleValue];
            }
        }
    }
}

#pragma mark - 4. ===========KTrade代理【XXTradeDataDelegate】
- (void)tradeQuoteData:(NSDictionary *)quoteDta {

    self.depthView.tickerModel = [XXTickerModel mj_objectWithKeyValues:quoteDta];
    NSString *closePrice = [KDecimal decimalNumber:self.depthView.tickerModel.c RoundingMode:NSRoundDown scale:[KDecimal scale:KTrade.coinTradeModel.minPricePrecision]];

    if (!KTrade.coinTradeModel.quote.close) {
        KTrade.coinTradeModel.quote.close = self.depthView.tickerModel.c;
        [self initPriceViewData];
//        if (KUser.isLogin) {
            [self updateBalance];
//        }
    } else {
        KTrade.coinTradeModel.quote.close = self.depthView.tickerModel.c;
    }

    UIColor *textColor;
    NSString *riseString = @"";
    double rise = ([self.depthView.tickerModel.c doubleValue] - [self.depthView.tickerModel.o doubleValue])*100/[self.depthView.tickerModel.o doubleValue];
    if (isnan(rise)) {
        rise = 0.00;
    }
    if (rise >= 0) {
        textColor = kGreen100;
        riseString = [NSString stringWithFormat:@"+%@", [NSString riseFallValue:rise]];
    } else {
        riseString = [NSString riseFallValue:rise];
        textColor = kRed100;
    }
    NSString *money = [NSString stringWithFormat:@"  %@", [[RatesManager shareRatesManager] getRatesWithToken:KTrade.coinTradeModel.quoteTokenId priceValue:[closePrice doubleValue]]];
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":closePrice, @"color":textColor, @"font":kFontBold(14.0f)};
    itemsArray[1] = @{@"string":money, @"color":kDark50, @"font":kFont10};
    self.depthView.closeLabel.attributedText = [NSString mergeStrings:itemsArray];

    self.riseFallLabel.textColor = textColor;
    self.riseFallLabel.text = riseString;
}

- (void)tradeDepthListData:(NSDictionary *)listData {
    self.depthView.ordersArray = self.data.currentModelsArray;
    [self.depthView reloadDepthListData:listData];
}

/** 清理数据 */
- (void)cleanData {
    self.depthView.closeLabel.text = @"--";
    self.riseFallLabel.text = @"--";
    self.priceView.textField.text = @"";
    self.depthView.ordersArray = nil;
    [self.depthView reloadDepthListData:@{}];
}


#pragma mark - =================菜单代理事件=================
- (void)menuViewItemDidselctIndex:(NSInteger)index name:(NSString *)name {
    self.meunView.selectIndex = index;
    [self.tableView reloadData];
    if (index == 1) {
        [self loadDataOfHistoryOrderIsUserAction:YES];
    }
}

#pragma mark - =================继承=================

#pragma mark - 0. 跳转详情
- (void)tradeViewPushToDetailVC {
    XXBitcoinDetailVC *vc = [[XXBitcoinDetailVC alloc] init];
    KDetail.symbolModel = KTrade.coinTradeModel;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 1. 标题按钮点击事件
- (void)tradeViewTitleButtonAction:(UIButton *)sender {

    // 关闭 行情 跟 深度订阅
    [KTrade closeSocket];

//    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
//    CGRect rect = [sender convertRect:sender.bounds toView:window];
    XXSwitchCoinView *switchPairsView = [[XXSwitchCoinView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [switchPairsView show];

}

#pragma mark - 2. 交易类型【买、买切换】
- (void)tradeViewSwitchTradeType {
    [self initTradeData];
}

#pragma mark - 3. 价格类型按钮点击事件【限价、市价】
- (void)tradeViewTradePriceTypeButtonAction:(UIButton *)sender {
 
    NSArray *titleArr = @[LocalizedString(@"Limit"), LocalizedString(@"MarketPrice")];
    CGFloat itemWith = 0;
    UIFont *font = kFont14;
    for (NSInteger i=0; i < titleArr.count; i ++) {
        NSString *itemString = titleArr[i];
        CGFloat width = [NSString widthWithText:itemString font:font] + 80;
        if (itemWith < width) {
            itemWith = width;
        }
    }
    CGRect rect = [self.headerView convertRect:self.fixedPriceButton.frame toView:KWindow];
    CGPoint point = CGPointMake(rect.origin.x + 15, rect.origin.y + rect.size.height);
    MJWeakSelf
    [YBPopupMenu showAtPoint:point titles:titleArr icons:nil menuWidth:itemWith otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = weakSelf;
        popupMenu.borderColor = KLine_Color;
        popupMenu.borderWidth = 1;
        popupMenu.textColor = kDark100;
        popupMenu.backColor = kWhite100;
        popupMenu.indexSelectedCell = weakSelf.isMarketPrice;
    }];
}

#pragma mark - 3.1 <YBPopupMenuDelegate>
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {

    if (index == 0) {
        [self.fixedPriceButton setTitle:LocalizedString(@"Limit") forState:UIControlStateNormal];
        if (self.isMarketPrice == YES) {
            self.isMarketPrice = NO;
            [self initTradeData];
        }
    } else {
        [self.fixedPriceButton setTitle:LocalizedString(@"MarketPrice") forState:UIControlStateNormal];
        if (self.isMarketPrice == NO) {
            self.isMarketPrice = YES;
            [self initTradeData];
        }
    }
}

#pragma mark - 4.1 价格变化
- (void)tradeViewPriceViewTextChange:(UITextField *)textField {

    if (self.isMarketPrice) {
        textField.text = @"";
        return;
    }

    // 1. 去空格
    textField.text = [textField.text trimmingCharacters];

    // 2. 保证输入数字的有效性
    if ( textField.text.length > 0 ) {

        // 1. 首次输入小数点
        if ([textField.text isEqualToString:@"."]) {
            textField.text = @"0.";
        }

        // 2. 判断0后一位不是小数点
        if (textField.text.length > 1 && [textField.text hasPrefix:@"0"] && ![[textField.text substringToIndex:2] isEqualToString:@"0."]) {
            textField.text = [textField.text substringFromIndex:1];
        }

        // 3. 防止输入多个小数点
        if ( [textField.text componentsSeparatedByString:@"."].count > 2 ) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }

        // 4. 防止小数点后超过 最小价格的变动单位
        NSInteger maxValue = [KDecimal scale:KTrade.coinTradeModel.minPricePrecision];
        if ( [textField.text componentsSeparatedByString:@"."].count == 2 && [[textField.text componentsSeparatedByString:@"."] lastObject].length > maxValue ) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
    }

    // 1. 计算法币和交易额
    [self priceTextFieldChengedReloadUI];
    
    // 2. 判断合法性
    if ([self.priceView.textField.text doubleValue] > 0 && [self.amountView.textField.text doubleValue] > self.maxNumber) {
        [MBProgressHUD showErrorMessage:LocalizedString(@"InsufficientBalance")];
    }
}

#pragma mark - 4.2 价格输入款值变化事件
- (void)priceTextFieldChengedReloadUI {

    // 1. 设置最新价的法币
    if ([self.priceView.textField.text doubleValue] > 0) {
        self.aboutPriceLabel.text = [[RatesManager shareRatesManager] getRatesWithToken:KTrade.coinTradeModel.quoteTokenId priceValue:[self.priceView.textField.text doubleValue]];
    } else {
        self.aboutPriceLabel.text = @"";
    }

    // 2. 如果是买入 设置最大交易量
    if (!KTrade.coinIsSell) {
        if ([self.priceView.textField.text doubleValue] > 0) {
            self.maxNumber = [self.balance doubleValue] / [self.priceView.textField.text doubleValue];
        } else {
            self.maxNumber = 0.0;
        }
    }

    // 3. 如果是买入 存在数量 设置进度条
    if (!KTrade.coinIsSell) {
        if ([self.priceView.textField.text doubleValue] > 0 && [self.amountView.textField.text doubleValue] > 0) {
            self.progressView.proportion = [self.amountView.textField.text doubleValue] / self.maxNumber;
        } else {
            self.progressView.proportion = 0.0;
        }
    }

    // 4. 设置交易额 判断是否存在 数量和 单价 计算交易额
    if ([self.amountView.textField.text doubleValue] > 0 && [self.priceView.textField.text doubleValue] > 0) {

        NSString *tradeValueString = [NSString stringWithFormat:@"%.12f", [self.amountView.textField.text doubleValue] * [self.priceView.textField.text doubleValue]];

        NSString *money = [[RatesManager shareRatesManager] getRatesWithToken:KTrade.coinTradeModel.quoteTokenId priceValue:[tradeValueString doubleValue]];
        self.tradeNameLabel.text = [NSString stringWithFormat:@"%@ %@", [KDecimal decimalNumber:tradeValueString RoundingMode:NSRoundDown scale:[KDecimal scale:KTrade.coinTradeModel.minPricePrecision]], KTrade.coinTradeModel.quoteTokenName];
        self.tradeValueLabel.text = money;

    } else {
        self.tradeNameLabel.text = @"--";//LocalizedString(@"MoneyAmount");
        self.tradeValueLabel.text = @"--";
    }

}


#pragma mark - 5. 数量变化
- (void)tradeViewAmountViewTextChange:(UITextField *)textField {
    // 1. 去空格
    textField.text = [textField.text trimmingCharacters];

    // 2. 保证输入数字的有效性
    if ( textField.text.length > 0 ) {

        // 1. 首次输入小数点
        if ([textField.text isEqualToString:@"."]) {
            textField.text = @"0.";
        }

        // 2. 判断0后一位不是小数点
        if (textField.text.length > 1 && [textField.text hasPrefix:@"0"] && ![[textField.text substringToIndex:2] isEqualToString:@"0."]) {
            textField.text = [textField.text substringFromIndex:1];
        }

        // 3. 防止输入多个小数点
        if ( [textField.text componentsSeparatedByString:@"."].count > 2 ) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }

        // 4. 防止小数点后超过 最小数量的变动单位
        NSInteger maxValue = [KDecimal scale:KTrade.coinTradeModel.basePrecision];
        if (!KTrade.coinIsSell && self.isMarketPrice) { // 市价 买入
            maxValue = [KDecimal scale:KTrade.coinTradeModel.quotePrecision];
        }
        if ( [textField.text componentsSeparatedByString:@"."].count == 2 && [[textField.text componentsSeparatedByString:@"."] lastObject].length > maxValue ) {

            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
    }

    // 3. 刷新UI
    [self numberTextFieldChengedReloadUI];
}

#pragma mark - 5.1 刷新 进度条 交易额 数据
- (void)numberTextFieldChengedReloadUI {

    // 1. 判断是限价 还是 市价
    if (self.isMarketPrice) { // 市价
        if ([self.amountView.textField.text doubleValue] > 0 && self.maxNumber > 0) {

            self.progressView.proportion = [self.amountView.textField.text doubleValue] / self.maxNumber;
        } else {
            self.progressView.proportion = 0.0;
        }
    } else { // 限价

        // 1. 进度条
        if ([self.amountView.textField.text doubleValue] > 0 && self.maxNumber > 0) {

            self.progressView.proportion = [self.amountView.textField.text doubleValue] / self.maxNumber;
        } else {
            self.progressView.proportion = 0.0;
        }

        // 2. 设置交易额 判断是否存在 数量和 单价 计算交易额
        if ([self.amountView.textField.text doubleValue] > 0 && [self.priceView.textField.text doubleValue] > 0) {


            NSString *tradeValueString = [NSString stringWithFormat:@"%.12f", [self.amountView.textField.text doubleValue] * [self.priceView.textField.text doubleValue]];
            self.tradeNameLabel.text = [NSString stringWithFormat:@"%@ %@", [KDecimal decimalNumber:tradeValueString RoundingMode:NSRoundDown scale:[KDecimal scale:KTrade.coinTradeModel.minPricePrecision]], KTrade.coinTradeModel.quoteTokenName];
            
            self.tradeValueLabel.text = [NSString stringWithFormat:@"%@", [[RatesManager shareRatesManager] getRatesWithToken:KTrade.coinTradeModel.quoteTokenId priceValue:[tradeValueString doubleValue]]];

        } else {
            self.tradeNameLabel.text = @"--";//LocalizedString(@"MoneyAmount");
            self.tradeValueLabel.text = @"--";
        }
    }

    // 2. 判断合法性
    if ([self.priceView.textField.text doubleValue] > 0 && [self.amountView.textField.text doubleValue] > self.maxNumber) {
        [MBProgressHUD showErrorMessage:LocalizedString(@"InsufficientBalance")];
    }
}

#pragma mark - 6. 滑块值变化
- (void)progressProportionChenge:(double)proportion {

    NSString *numberString = [NSString stringWithFormat:@"%.12f", self.maxNumber * proportion];
    NSInteger maxValue = [KDecimal scale:KTrade.coinTradeModel.basePrecision];
    if (!KTrade.coinIsSell && self.isMarketPrice) { // 市价 买入
        maxValue = [KDecimal scale:KTrade.coinTradeModel.quotePrecision];
    }
    self.amountView.textField.text = [KDecimal decimalNumber:numberString RoundingMode:NSRoundDown scale:maxValue];

    [self numberTextFieldChengedReloadUI];
}

#pragma mark - 7. 深度按钮点击事件
- (void)depthViewButtonAction {
    
    KTrade.priceDigit = [self.depthView.valuesArray[self.depthView.numberIndex] integerValue];
    [KTrade openSocketWithSymbolModel:KTrade.coinTradeModel];
}

#pragma mark - 8. 买入、卖出、登录事件按钮
- (void)tradeActionButtonAction:(UIButton *)sender {

    if (![self verifyInputIsLegal]) {
        return;
    }
    [MBProgressHUD showActivityMessageInWindow:@""];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"exchange_id"] = KTrade.coinTradeModel.exchangeId;
    param[@"client_order_id"] = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]*1000];
//    param[@"account_id"] = KUser.defaultAccountId;
    param[@"symbol_id"] = KTrade.coinTradeModel.symbolId;
    param[@"side"] = KTrade.coinIsSell ? @"sell" : @"buy";
    param[@"type"] = self.isMarketPrice ? @"market" : @"limit";
    if (self.isMarketPrice) {
        param[@"price"] = @"";
    } else {
        param[@"price"] = self.priceView.textField.text;
    }
    param[@"quantity"] = self.amountView.textField.text;
    
//    [HttpManager order_PostWithPath:@"order/create" params:param andBlock:^(id data, NSString *msg, NSInteger code) {
//        [MBProgressHUD hideHUD];
//        if (code == 0) {
//            [MBProgressHUD showSuccessMessage:LocalizedString(@"OrderSucceeded")];
//            [self initTradeData];
//        } else {
//            [MBProgressHUD showErrorMessage:msg];
//        }
//    }];
}

#pragma mark - 8.2 验证是否合法
- (BOOL)verifyInputIsLegal {

    // 1. 是否登录
//    if (!KUser.isLogin) {
//        [XXPush toLoginViewController:self.viewController];
//        return NO;
//    }

    // 2. 是否市价
    if (self.isMarketPrice && KTrade.coinIsSell) { // 市价 卖出

        // 1. 交易量
        if ([self.amountView.textField.text doubleValue] < [KTrade.coinTradeModel.minTradeQuantity doubleValue]) {
            NSString *message = [NSString stringWithFormat:@"%@%@%@", LocalizedString(@"TheSellingQuantityCannotBeLessThan"), KTrade.coinTradeModel.minTradeQuantity, KTrade.coinTradeModel.baseTokenName];
            [MBProgressHUD showErrorMessage:message];
            return NO;
        }

        // 2. 余额
        if ([self.amountView.textField.text doubleValue] > [self.balance doubleValue]) {
            [MBProgressHUD showErrorMessage:LocalizedString(@"InsufficientBalance")];
            return NO;
        }

    } else if (self.isMarketPrice && !KTrade.coinIsSell) { // 市价 买入

        // 1. 验证交易额
        if ([self.amountView.textField.text doubleValue] < [KTrade.coinTradeModel.minTradeAmount doubleValue]) {
            NSString *message = [NSString stringWithFormat:@"%@%@%@", LocalizedString(@"ThePurchaseQuantityCannotBeLessThan"), KTrade.coinTradeModel.minTradeAmount, KTrade.coinTradeModel.quoteTokenName];
            [MBProgressHUD showErrorMessage:message];
            return NO;
        }

        // 2. 验证余额
        if ([self.amountView.textField.text doubleValue] > [self.balance doubleValue]) {
            [MBProgressHUD showErrorMessage:LocalizedString(@"InsufficientBalance")];
            return NO;
        }
    } else { // 限价

        // 1. 是否输入价格
        if ([self.priceView.textField.text doubleValue] == 0) {
            [MBProgressHUD showErrorMessage:LocalizedString(@"PleaseEnterThePrice")];
            return NO;
        }

        // 2. 交易数量
        if ([self.amountView.textField.text doubleValue] < [KTrade.coinTradeModel.minTradeQuantity doubleValue]) {
            NSString *message = [NSString stringWithFormat:@"%@%@%@", LocalizedString(@"TheQuantityCannotBeLessThan"), KTrade.coinTradeModel.minTradeQuantity, KTrade.coinTradeModel.baseTokenName];
            [MBProgressHUD showErrorMessage:message];
            return NO;
        }

        // 3. 交易额
        double sumPrice = [self.priceView.textField.text doubleValue] * [self.amountView.textField.text doubleValue];
        if (sumPrice < [KTrade.coinTradeModel.minTradeAmount doubleValue]) {
            NSString *message = [NSString stringWithFormat:@"%@%@%@", LocalizedString(@"TheAmountCannotBeLessThan"), KTrade.coinTradeModel.minTradeAmount, KTrade.coinTradeModel.quoteTokenName];
            [MBProgressHUD showErrorMessage:message];
            return NO;
        }

        // 4. 验证余额是否充足
        if (KTrade.coinIsSell) { // 卖
            if ([self.amountView.textField.text doubleValue] > [self.balance doubleValue]) {
                [MBProgressHUD showErrorMessage:LocalizedString(@"InsufficientBalance")];
                return NO;
            }
        } else { // 买
            if (sumPrice > [self.balance doubleValue]) {
                [MBProgressHUD showErrorMessage:LocalizedString(@"InsufficientBalance")];
                return NO;
            }
        }
    }

    // 3. 数量输入
    if (self.isMarketPrice && !KTrade.coinIsSell) {
        if ([self.amountView.textField.text doubleValue] == 0) {
            [MBProgressHUD showErrorMessage:LocalizedString(@"PleaseEnterTheAmount")];
            return NO;
        }
    } else {
        if ([self.amountView.textField.text doubleValue] == 0) {
            [MBProgressHUD showErrorMessage:LocalizedString(@"PleaseEnterTheQuantity")];
            return NO;
        }
    }
    return YES;
}

#pragma mark - 9. 选择价格后刷新数据
- (void)selectPrice:(NSString *)price ReloadAmount:(double)amount isBuy:(BOOL)isBuy  {
    
    if (self.isMarketPrice) {
        return;
    }
    
    // 赋值Adx43sec 
    self.priceView.textField.text = [KDecimal decimalNumber:price RoundingMode:NSRoundDown scale:[KDecimal scale:KTrade.coinTradeModel.minPricePrecision]];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue=[NSNumber numberWithFloat:1.0];
    animation.toValue=[NSNumber numberWithFloat:1.15];
    animation.duration=0.1;
    animation.autoreverses=YES;
    animation.repeatCount=0;
    animation.removedOnCompletion=NO;
    animation.fillMode=kCAFillModeForwards;
    [self.priceView.textField.layer addAnimation:animation forKey:@"zoom"];
    
    // 刷新价格
    [self priceTextFieldChengedReloadUI];
    
    if (self.maxNumber == 0) {
        return;
    }
    
    if (amount == 0) {
        return;
    }
    
    if (isBuy != KTrade.coinIsSell) {
        return;
    }

    double showAmount = amount;
    if (amount > self.maxNumber) {
        showAmount = self.maxNumber;
    }

    // 4. 防止小数点后超过 最小数量的变动单位
    NSInteger maxValue = [KDecimal scale:KTrade.coinTradeModel.basePrecision];
    if (!KTrade.coinIsSell && self.isMarketPrice) { // 市价 买入
        maxValue = [KDecimal scale:KTrade.coinTradeModel.quotePrecision];
    }
    
    self.amountView.textField.text = [KDecimal decimalNumber:[NSString stringWithFormat:@"%.14f", showAmount] RoundingMode:NSRoundDown scale:maxValue];
    
    [self numberTextFieldChengedReloadUI];
}

#pragma mark - ================ 订单 ================

#pragma mark - 1. 表示图数据源代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.meunView.indexClass == 0) { // 当前委托
        return self.data.currentModelsArray.count;
    } else { // 历史委托
        return self.data.historyModelsArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.sectionView.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if ((self.meunView.indexClass == 0 && self.data.currentModelsArray.count == 0) || (self.meunView.indexClass == 1 && self.data.historyModelsArray.count == 0)) {
        return self.emptyView.height;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if ((self.meunView.indexClass == 0 && self.data.currentModelsArray == nil)) {
        self.emptyView.nameLabel.text = LocalizedString(@"Loading");
        return self.emptyView;
    } else if (self.meunView.indexClass == 1 && self.data.historyModelsArray == nil) {
        if (self.data.isHistoryFailure) {
            return self.failureView;
        } else {
            self.emptyView.nameLabel.text = LocalizedString(@"Loading");
            return self.emptyView;
        }
        
    } else if ((self.meunView.indexClass == 0 && self.data.currentModelsArray.count == 0) || (self.meunView.indexClass == 1 && self.data.historyModelsArray.count == 0)) {
        self.emptyView.nameLabel.text = LocalizedString(@"NoRecord");
        return self.emptyView;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.meunView.indexClass == 0 ? [XXCurrentOrderCell getCellHeight] : [XXHistoryOderCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.meunView.indexClass == 0) { // 当前委托

        XXCurrentOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.model = self.data.currentModelsArray[indexPath.row];
        return cell;

    } else if (self.meunView.indexClass == 1) { // 历史委托

        XXHistoryOderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir1];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.model = self.data.historyModelsArray[indexPath.row];
        return cell;

    } else {
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.meunView.indexClass == 1 && indexPath.row < self.data.historyModelsArray.count) {
        XXOrderDetailVC *vc = [[XXOrderDetailVC alloc] init];
        vc.type = SymbolTypeCoin;
        vc.coinModel = self.data.historyModelsArray[indexPath.row];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 2.1 加载委托订单
- (void)loadDataOrderOfCurrentOrder {

    MJWeakSelf
    [self.data loadCurrentOrderBlock:^{
        if (weakSelf.meunView.indexClass == 0) {
            [weakSelf.tableView reloadData];
        }
    }];

}

#pragma mark - 2.2 加载历史委托
- (void)loadDataOfHistoryOrderIsUserAction:(BOOL)isUserAction {
    MJWeakSelf
    [self.data loadHistoryOrderIsUserAction:isUserAction Block:^(BOOL canNextPaper) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (!canNextPaper) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
        if (weakSelf.meunView.indexClass == 1) {
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSString * _Nonnull msg) {
        weakSelf.failureView.msgLabel.text = KString(msg);
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - 10. scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    CGPoint point = [scrollView.panGestureRecognizer translationInView:self];
    if (point.y > 0) {
        if (_isUp == YES) {
            _isUp = NO;
            if (self.scrollBlock) {
                self.scrollBlock(YES);
            }
        }
    } else {
        if (_isUp == NO) {
            _isUp = YES;
            if (self.scrollBlock) {
                self.scrollBlock(NO);
            }
        }
    }
}


#pragma mark - || 懒加载
- (XXCoinTradeSectionHeaderView *)sectionView {
    if (_sectionView == nil) {
        _sectionView = [[XXCoinTradeSectionHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 64)];
    }
    return _sectionView;
}

- (XXMenuView *)meunView {
    if (_meunView == nil) {
        _meunView = [[XXMenuView alloc] initWithFrame:CGRectMake(0, 8, kScreen_Width - 70, self.sectionView.height - 8)];
        _meunView.lowLine.hidden = YES;
        _meunView.delegate = self;
        _meunView.minFont = kFontBold16;
        _meunView.maxFont = kFontBold16;
        _meunView.namesArray = [NSMutableArray arrayWithObjects:LocalizedString(@"OpenOrder"), LocalizedString(@"OrderHistory"), nil];
    }
    return _meunView;
}

/** 失败视图 */
- (XXFailureView *)failureView {
    if (_failureView == nil) {
        _failureView = [[XXFailureView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 300)];
        MJWeakSelf
        _failureView.reloadBlock = ^{
            weakSelf.data.isHistoryFailure = NO;
            [weakSelf.tableView reloadData];
            [weakSelf loadDataOfHistoryOrderIsUserAction:YES];
        };
    }
    return _failureView;
}

- (XXEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[XXEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 300) iamgeName:kIsNight ? @"noDataRecordDark" : @"noDataRecord" alert:LocalizedString(@"NoRecord")];
    }
    return _emptyView;
}

- (XXTradeCoinData *)data {
    if (_data == nil) {
        _data = [[XXTradeCoinData alloc] init];
    }
    return _data;
}
@end
