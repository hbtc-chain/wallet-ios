//
//  XXTradeView.h
//  Bhex
//
//  Created by Bhex on 2019/1/8.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXBusinessPriceView.h"
#import "XXBusinessAmountView.h"
#import "XXBusinessProgressView.h"
#import "XXDepthView.h"
#import "XXBuySellButton.h"
#import "XXTradeLeverBar.h"

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, XXTradeViewType) {
    XXTradeViewTypeCoin = 0,//币币现货
};

@interface XXTradeView : UIView <UITableViewDataSource, UITableViewDelegate>

/** 标题按钮 */
@property (strong, nonatomic) XXButton *titleButton;

/** 涨跌幅标签 */
@property (strong, nonatomic) XXLabel *riseFallLabel;

/** 头视图 */
@property (strong, nonatomic) UIView *headerView;

/** 买卖方式按钮 */
@property (strong, nonatomic) XXBuySellButton *typeButton;

/** 限价按钮 */
@property (strong, nonatomic) XXButton *fixedPriceButton;

/** 价格视图 */
@property (strong, nonatomic) XXBusinessPriceView *priceView;

/** 法币 */
@property (strong, nonatomic) XXLabel *aboutPriceLabel; // xxxx

/** 数量视图 */
@property (strong, nonatomic) XXBusinessAmountView *amountView;

/** 可用余额 */
@property (strong, nonatomic) XXLabel *availableNameLabel;
@property (strong, nonatomic) XXLabel *availableValueLabel;
@property (strong, nonatomic) XXLabel *availableMoneyLabel;

/** 进度条 */
@property (strong, nonatomic) XXBusinessProgressView *progressView;

@property (strong, nonatomic) XXLabel *tradeTitleLabel;
/** 交易额 */
@property (strong, nonatomic) XXLabel *tradeNameLabel;

/** 交易金额 */
@property (strong, nonatomic) XXLabel *tradeValueLabel;

/** 资金划转按钮 */
@property (strong, nonatomic) XXButton *transferButton;

/** 买卖 登录按钮 */
@property (strong, nonatomic) XXButton *actionButton;

/** 表示图 */
@property (strong, nonatomic) UITableView *tableView;

/** 盘口深度视图 */
@property (strong, nonatomic) XXDepthView *depthView;


/** 标题按钮赋值 */
- (void)setTitleButtonTitle:(NSString *)title;

#pragma mark - 1. 添加行权价、指标、交割时间视图
- (void)addOptionTimeView;

/** 0. 跳转详情 */
- (void)tradeViewPushToDetailVC;

/** 1. 标题按钮点击事件 */
- (void)tradeViewTitleButtonAction:(UIButton *)sender;

/** 2. 交易类型【买、买切换】 */
- (void)tradeViewSwitchTradeType;

/** 3. 价格类型按钮点击事件【限价、市价】 */
- (void)tradeViewTradePriceTypeButtonAction:(UIButton *)sender;

/** 4. 价格变化 */
- (void)tradeViewPriceViewTextChange:(UITextField *)textField;

/** 5. 数量变化 */
- (void)tradeViewAmountViewTextChange:(UITextField *)textField;

/** 6. 滑块值变化 */
- (void)progressProportionChenge:(double)proportion;

/** 7. 深度按钮点击事件 */
- (void)depthViewButtonAction;

/** 8. 买入、卖出、登录事件按钮 */
- (void)tradeActionButtonAction:(UIButton *)sender;

/** 9. 选择价格后刷新数据 */
- (void)selectPrice:(NSString *)price ReloadAmount:(double)amount isBuy:(BOOL)isBuy;

/**杠杆风险*/
- (void)riskRatioAction:(UIButton *)sender;
/**借还币 事件按钮*/
- (void)borrowOrReturnAction:(UIButton *)sender;

/**杠杆更多按钮事件*/
- (void)leverMoreButtonAction:(UIButton *)sender;

/**资金划转按钮事件 */
- (void)transferButtonAction:(UIButton *)sender;

- (instancetype)initWithFrame:(CGRect)frame withType:(XXTradeViewType)tradeType;
@end

NS_ASSUME_NONNULL_END
