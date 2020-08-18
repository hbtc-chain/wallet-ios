//
//  XXSymbolView.h
//  Bhex
//
//  Created by Bhex on 2018/10/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//
// 行情单个币种列表View
#import <UIKit/UIKit.h>
#import "XXMarketCell.h"
#import "XXQuoteTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXSymbolView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

/** 模型数组 */
@property (strong, nonatomic) XXQuoteTokenModel *model;

- (void)openWebsocket;
- (void)closeWebsocket;

@end

NS_ASSUME_NONNULL_END
