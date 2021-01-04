//
//  XXSymbolDetailVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSymbolDetailVC.h"
#import "XXTransactionCell.h"
#import "XXSymbolDetailHeaderView.h"
#import "XXTokenModel.h"
#import "XXTransferDetailVC.h"
#import "XXEmptyView.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXAssetSingleManager.h"

@interface XXSymbolDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *txs;
@property (nonatomic, strong) XXAssetModel *assetModel;
@property (nonatomic, strong) XXSymbolDetailHeaderView *symbolDetailHeaderView; //其它币没有分红等信息
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) XXEmptyView *emptyView;
@property (nonatomic, strong) NSTimer *timer; //定时刷新交易记录
@property (nonatomic, strong) NSArray *delegations; //委托列表
@property (nonatomic, strong) XXMsgRequest *msgRequest; //提取分红

@end

@implementation XXSymbolDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    self.pageSize = 30;
    [self buildUI];
    [self refreshHeader];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshHeader) name:kNotificationAssetRefresh object:nil];
}

- (void)buildUI {
    self.titleLabel.text = [self.tokenModel.name uppercaseString];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.symbolDetailHeaderView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD showActivityMessageInView:@""];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)timerAction {
    [self requestHistory];
}

#pragma mark 网络请求 - 刷新资产
- (void)refreshHeader {
    self.assetModel = [[XXAssetModel alloc] init];
    self.assetModel.symbol = self.tokenModel.symbol;
    [self.tableView.mj_header endRefreshing];
    for (XXTokenModel *tokenModel in [XXAssetSingleManager sharedManager].assetModel.assets) {
        if ([tokenModel.symbol isEqualToString:self.tokenModel.symbol]) {
            self.assetModel.amount = kAmountLongTrim(tokenModel.amount);
        }
    }
    self.symbolDetailHeaderView.assetModel = self.assetModel;
}

#pragma mark 网络请求 - 交易记录
- (void)requestHistory {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@/txs",KUser.address];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = self.tokenModel.symbol;
    param[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    param[@"size"] = [NSString stringWithFormat:@"%d",self.pageSize];
    [HttpManager getWithPath:path params:param andBlock:^(id data, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUD];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (code == 0) {
            NSArray *tempArr = [data objectForKey:@"items"];
            if (self.page == 1) {
                weakSelf.txs = [NSMutableArray arrayWithArray:tempArr];;
            } else {
                [weakSelf.txs addObjectsFromArray:tempArr];
            }
            if (tempArr.count < self.pageSize) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        } else {
            if (![KUser.netWorkStatus isEqualToString:@"notReachable"]) {
                Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
                }];
                [alert showAlert];
            }
        }
    }];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.txs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.txs && self.txs.count == 0) {
        return self.emptyView.height;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.txs && self.txs.count == 0) {
        return self.emptyView;
    } else {
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXTransactionCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXTransactionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXTransactionCell"];
    if (!cell) {
        cell = [[XXTransactionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXTransactionCell"];
    }
    NSDictionary *dic = self.txs[indexPath.row];
    [cell configData:dic symbol:self.tokenModel.symbol];
    cell.backgroundColor = kWhiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *tx = self.txs[indexPath.row];
    XXTransferDetailVC *detailVC = [[XXTransferDetailVC alloc] init];
    detailVC.hashString = tx[@"hash"];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 控件
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        MJWeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            weakSelf.page = 1;
            [weakSelf refreshHeader];
            [weakSelf requestHistory];
        }];
    }
    return _tableView;
}

- (XXSymbolDetailHeaderView *)symbolDetailHeaderView {
    if (!_symbolDetailHeaderView) {
        _symbolDetailHeaderView = [[XXSymbolDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 120)];
    }
    return _symbolDetailHeaderView;
}

- (XXEmptyView *)emptyView {
    if (_emptyView == nil) {
        if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
            _emptyView = [[XXEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(243)) iamgeName:@"noData" alert:LocalizedString(@"NoData")];
        } else {
            _emptyView = [[XXEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(379)) iamgeName:@"noData" alert:LocalizedString(@"NoData")];
        }
    }
    return _emptyView;
}

@end
