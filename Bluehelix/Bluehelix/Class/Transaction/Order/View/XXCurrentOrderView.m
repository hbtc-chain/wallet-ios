//
//  XXCurrentOrderView.m
//  Bhex
//
//  Created by BHEX on 2018/7/22.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXCurrentOrderView.h"
#import "XXCurrentOrderCell.h"

@interface XXCurrentOrderView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *fromId;
@property (assign, nonatomic) NSInteger limit;
@property (strong, nonatomic) NSString *baseToken;
@property (strong, nonatomic) NSString *quoteToken;
@property (strong, nonatomic) NSString *side;

/** 模型数组 */
@property (strong, nonatomic) NSMutableArray *modelsArray;

/** 标示图 */
@property (strong, nonatomic) UITableView *tableView;

/** 区空提示 */
@property (strong, nonatomic) XXEmptyView *sectionAlertView;

@end

@implementation XXCurrentOrderView
static NSString *identifirid = @"XXCurrentOrderCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupUI];
        [self loadData];
        
//        MJWeakSelf
//        KUserSocket.currentOrderOrderManagerBlock = ^(id data) {
//            [weakSelf receiveData:data];
//        };
    }
    return self;
}

#pragma mark - 10.2 接收到socket数据
- (void)receiveData:(NSDictionary *)data {
    
    // 插入
    if ([data[@"status"] isEqualToString:@"NEW"]) { // 新增
        XXOrderModel *model = [XXOrderModel mj_objectWithKeyValues:data];
        if (self.modelsArray) {
            [self.modelsArray insertObject:model atIndex:0];
            [self.tableView reloadData];
        }
    } else if ([data[@"status"] isEqualToString:@"CANCELED"] || [data[@"status"] isEqualToString:@"FILLED"]) { // 删除
        NSString *orderId = data[@"orderId"];
        NSInteger index = -1;
        for (NSInteger i=0; i < self.modelsArray.count; i ++) {
            XXOrderModel *model = self.modelsArray[i];
            if ([model.orderId isEqualToString:orderId]) {
                index = i;
                break;
            }
        }
        if (index > -1) {
            [self.modelsArray removeObjectAtIndex:index];
            [self.tableView reloadData];
        }
        
    } else { // 更新
        NSString *orderId = data[@"orderId"];
        NSInteger index = -1;
        for (NSInteger i=0; i < self.modelsArray.count; i ++) {
            XXOrderModel *model = self.modelsArray[i];
            if ([model.orderId isEqualToString:orderId]) {
                index = i;
                break;
            }
        }
        
        if (index > -1) {
            self.modelsArray[index] = [XXOrderModel mj_objectWithKeyValues:data];
            [self.tableView reloadData];
        } else {
            if (self.modelsArray) {
                [self.modelsArray insertObject:[XXOrderModel mj_objectWithKeyValues:data] atIndex:0];
                [self.tableView reloadData];
            }
        }
    }
}

#pragma mark - 0. 初始化数据
- (void)initData {
    self.fromId = @"0";
    self.limit = 20;
    self.baseToken = @"";
    self.quoteToken = @"";
    self.side = @"";
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    [self addSubview:self.tableView];
}

#pragma mark - 2. 加载数据
- (void)loadData {
    [self currentDelegateCoinOrder];
}
#pragma mark - 2.1 当前币币委托订单
- (void)currentDelegateCoinOrder{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"account_id"] = KUser.defaultAccountId;
    params[@"from_order_id"] = self.fromId;
    params[@"base_token_id"] = self.baseToken;
    params[@"quote_token_id"] = self.quoteToken;
    params[@"side"] = self.side;
    params[@"limit"] = @(self.limit);
//    [HttpManager order_GetWithPath:@"order/open_orders" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        if (code == 0) {
//            NSMutableArray *dataArray = [XXOrderModel mj_objectArrayWithKeyValuesArray:data];
//            if ([self.fromId integerValue] == 0) {
//                self.modelsArray = dataArray;
//            } else {
//                [self.modelsArray addObjectsFromArray:dataArray];
//            }
//
//            if (dataArray.count < self.limit) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//
//            [self.tableView reloadData];
//        } else {
//            [MBProgressHUD showErrorMessage:msg];
//        }
//    }];
}
#pragma mark - 2.2 当前币币杠杆委托订单
- (void)currentDelegateCoinLeverOrder{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"account_id"] = KUser.defaultAccountId;
    params[@"from_order_id"] = self.fromId;
    params[@"base_token_id"] = self.baseToken;
    params[@"quote_token_id"] = self.quoteToken;
    params[@"side"] = self.side;
    params[@"limit"] = @(self.limit);
//    [HttpManager order_GetWithPath:@"v1/margin/order/open_orders" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//        [self.tableView.mj_header endRefreshing];
//        [self.tableView.mj_footer endRefreshing];
//        if (code == 0) {
//            NSMutableArray *dataArray = [XXOrderModel mj_objectArrayWithKeyValuesArray:data];
//            if ([self.fromId integerValue] == 0) {
//                self.modelsArray = dataArray;
//            } else {
//                [self.modelsArray addObjectsFromArray:dataArray];
//            }
//
//            if (dataArray.count < self.limit) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//
//            [self.tableView reloadData];
//        } else {
//            [MBProgressHUD showErrorMessage:msg];
//        }
//    }];
}
#pragma mark - 3. 表示图数据源代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.modelsArray.count == 0 ? self.sectionAlertView.height : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXCurrentOrderCell getCellHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.modelsArray.count == 0 ? self.sectionAlertView : [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXCurrentOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifirid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.modelsArray[indexPath.row];
    cell.type = SymbolTypeCoin;
    MJWeakSelf
    cell.deleteBlock = ^(XXOrderModel *model) {
        weakSelf.fromId = @"0";
        [weakSelf loadData];
    };
    return cell;
}

#pragma mark - 6. 数据筛选
- (void)screenWithBaseToken:(NSString *)baseToken quoteToken:(NSString *)quoteToken side:(NSString *)side {
    self.baseToken = baseToken;
    self.quoteToken = quoteToken;
    self.side = side;
    self.fromId = @"0";
    [self loadData];
}

#pragma mark - 7. 全部撤单按钮点击事件
- (void)allCancelButtonAction {
    [self cancelAllCoinOrders];
}
#pragma mark - 7.1 撤销币币订单
- (void)cancelAllCoinOrders{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"account_id"] = KUser.defaultAccountId;
//    [HttpManager order_PostWithPath:@"order/batch_cancel" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//        if (code == 0) {
//            [MBProgressHUD showErrorMessage:LocalizedString(@"AllOrderCommit")];
//            self.fromId = @"0";
//            [self loadData];
//        } else {
//            [MBProgressHUD showErrorMessage:msg];
//        }
//    }];
}
#pragma mark - 7.2 撤销币币杠杆订单
- (void)cancelAllCoinLeverOrders{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"account_id"] = KUser.defaultAccountId;
//    [HttpManager order_PostWithPath:@"v1/margin/order/batch_cancel" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
//        if (code == 0) {
//            [MBProgressHUD showErrorMessage:LocalizedString(@"AllOrderCommit")];
//            self.fromId = @"0";
//            [self loadData];
//        } else {
//            [MBProgressHUD showErrorMessage:msg];
//        }
//    }];
}
#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[XXCurrentOrderCell class] forCellReuseIdentifier:identifirid];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        MJWeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.fromId = @"0";
            [weakSelf loadData];
            
        }];
        
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            if (weakSelf.modelsArray.count > 0) {
                XXOrderModel *model = [weakSelf.modelsArray lastObject];
                weakSelf.fromId = model.orderId;
            }
            [weakSelf loadData];
            
        }];
    }
    return _tableView;
}

- (XXEmptyView *)sectionAlertView {
    if (_sectionAlertView == nil) {
        _sectionAlertView = [[XXEmptyView alloc] initWithFrame:self.tableView.bounds iamgeName:kIsNight ? @"noDataRecordDark" : @"noDataRecord" alert:LocalizedString(@"NoRecord")];
    }
    return _sectionAlertView;
}

@end
