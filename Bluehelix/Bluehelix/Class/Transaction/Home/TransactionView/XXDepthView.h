//
//  XXDepthView.h
//  Bhex
//
//  Created by BHEX on 2018/7/16.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTickerModel.h"

@interface XXDepthView : UIView <UITableViewDataSource, UITableViewDelegate>

/** 类型买卖索引 0. 默认 1. 买单 2. 卖单 */
@property (assign, nonatomic) NSInteger orderIndex;
@property (assign, nonatomic) NSInteger numberIndex;

/** 合并深度选项数组 */
@property (strong, nonatomic, nullable) NSMutableArray *itemsArray;

/** 合并深度值数组 */
@property (strong, nonatomic, nullable) NSMutableArray *valuesArray;

/** 股票行情数据模型 */
@property (strong, nonatomic, nullable) XXTickerModel *tickerModel;

/** 价格标签【单位】 */
@property (strong, nonatomic, nullable) XXLabel *priceLabel;

/** 数量标签【单位】 */
@property (strong, nonatomic, nullable) XXLabel *numberLabel;
@property (strong, nonatomic, nullable) XXButton *amountButton;

/** 最新价标签【最新价、法币】 */
@property (strong, nonatomic, nullable) XXLabel *closeLabel;

/** 表示图 */
@property (strong, nonatomic, nullable) UITableView *tableView;

/** 回调价格 */
@property (strong, nonatomic, nullable) void(^depthPriceBlcok)(NSString *_Nullable price, double sumAmount, BOOL isBuy);

/** 按钮事件回调 */
@property (strong, nonatomic, nullable) void(^depthActionBlcok)(void);

/** 当前委托数组 */
@property (strong, nonatomic, nullable) NSMutableArray *ordersArray;

- (void)reloadNumberButtonTitle;

/** 刷新盘口列表 */
- (void)reloadDepthListData:(nullable NSDictionary *)listData;

@end
