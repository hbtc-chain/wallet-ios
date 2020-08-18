//
//  XXHistoryOderView.m
//  Bhex
//
//  Created by BHEX on 2018/7/22.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXHistoryOderView.h"
#import "XXHistoryOderCell.h"
#import "XXOrderDetailVC.h"

@interface XXHistoryOderView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *fromId;
@property (assign, nonatomic) NSInteger limit;
@property (strong, nonatomic) NSString *baseToken;
@property (strong, nonatomic) NSString *quoteToken;
@property (strong, nonatomic) NSString *side;

/** 模型数组 */
@property (strong, nonatomic) NSMutableArray *modelsArray;

/** 表示图 */
@property (strong, nonatomic) UITableView *tableView;

/** 区空提示 */
@property (strong, nonatomic) XXEmptyView *sectionAlertView;

/**当前币币订单类型*/
//@property (nonatomic, assign) XXCoinTradeType coinTradeType;
@end

@implementation XXHistoryOderView
static NSString *identifirid = @"XXHistoryOderCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupUI];
//        self.coinTradeType = coinTradeType;
        [self loadData];
    }
    return self;
}


#pragma mark - 1.1 初始化数据
- (void)initData {
    
    self.fromId = @"0";
    self.limit = 20;
    self.baseToken = @"";
    self.quoteToken = @"";
    self.side = @"";
}

#pragma mark - 1.2 初始化UI
- (void)setupUI {
    
    [self addSubview:self.tableView];
}

#pragma mark - 3. 加载数据
- (void)loadData {
    [self loadCoinHistory];
}
#pragma mark - 3.1 币币交易历史订单
- (void)loadCoinHistory{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"account_id"] = KUser.defaultAccountId;
    params[@"from_order_id"] = self.fromId;
    params[@"base_token_id"] = self.baseToken;
    params[@"quote_token_id"] = self.quoteToken;
    params[@"side"] = self.side;
    params[@"limit"] = @(self.limit);
//    [HttpManager order_GetWithPath:@"order/trade_orders" params:params andBlock:^(id data, NSString *msg, NSInteger code) {
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
//            [self.tableView reloadData];
//
//            if (dataArray.count < self.limit) {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
//        } else {
//            self.baseToken = @"";
//            self.quoteToken = @"";
//            [self.modelsArray removeAllObjects];
//            [self.tableView reloadData];
//            [MBProgressHUD showErrorMessage:msg];
//        }
//    }];
}

#pragma mark - 4. 表示图数据源代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return self.modelsArray.count == 0 ? self.sectionAlertView.height : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXHistoryOderCell getCellHeight];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.modelsArray.count == 0 ? self.sectionAlertView : [UIView new];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XXHistoryOderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifirid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.modelsArray[indexPath.row];
    if (indexPath.row == self.modelsArray.count - 1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.modelsArray.count) {
        XXOrderDetailVC *vc = [[XXOrderDetailVC alloc] init];
        vc.coinModel = self.modelsArray[indexPath.row];
        [self.viewController.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - 5. 数据筛选
- (void)screenWithBaseToken:(NSString *)baseToken quoteToken:(NSString *)quoteToken side:(NSString *)side {
    self.baseToken = baseToken;
    self.quoteToken = quoteToken;
    self.side = side;
    self.fromId = @"0";
    [self loadData];
}

#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[XXHistoryOderCell class] forCellReuseIdentifier:identifirid];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        MJWeakSelf;
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.fromId = @"0";
            [weakSelf loadData];
            
        }];
        
        // 5. 上啦加载
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

- (NSMutableArray *)modelsArray {
    if (_modelsArray == nil) {
        _modelsArray = [NSMutableArray array];
    }
    return _modelsArray;
}


- (void)dealloc {
    NSLog(@"==+==历史委托释放了");
}
@end
