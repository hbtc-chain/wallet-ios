//
//  XXSymbolDetailVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSymbolDetailVC.h"
#import "XXTransactionCell.h"
#import "XXSymbolDetailFooterView.h"
#import "XXDepositCoinVC.h"
#import "XXSymbolDetailHeaderView.h"
#import "XXTransferVC.h"
#import "XXTokenModel.h"
#import "XXTransferDetailVC.h"
#import "XXWithdrawChainVC.h"
#import "XXMainSymbolHeaderView.h"
#import "XXEmptyView.h"

int pageSize = 30;
@interface XXSymbolDetailVC ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXSymbolDetailFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *txs;
@property (nonatomic, strong) XXAssetModel *assetModel;
@property (nonatomic, strong) XXMainSymbolHeaderView *mainSymbolHeaderView;
@property (nonatomic, strong) XXSymbolDetailHeaderView *symbolDetailHeaderView;
@property (nonatomic, assign) int page;
@property (nonatomic, strong) XXEmptyView *emptyView;
@property (nonatomic, strong) XXAssetManager *assetManager;

@end

@implementation XXSymbolDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.page = 1;
    [self requestHistory];
    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.assetManager requestAsset];
}

/// 资产请求回来 刷新header
- (void)refreshHeader {
    self.assetModel = self.assetManager.assetModel;
    [self.tableView.mj_header endRefreshing];
    for (XXTokenModel *tokenModel in self.assetModel.assets) {
        if ([tokenModel.symbol isEqualToString:self.tokenModel.symbol]) {
            self.assetModel.amount = kAmountTrim(tokenModel.amount);
            self.assetModel.symbol = self.tokenModel.symbol;
            self.tokenModel.external_address = tokenModel.external_address;
        }
    }
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        self.mainSymbolHeaderView.assetModel = self.assetModel;
    } else {
        self.symbolDetailHeaderView.assetModel = self.assetModel;
    }
}

- (void)buildUI {
    self.titleLabel.text = self.tokenModel.symbol;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        self.tableView.tableHeaderView = self.mainSymbolHeaderView;
    } else {
        self.tableView.tableHeaderView = self.symbolDetailHeaderView;
    }
}

/// 请求交易记录
- (void)requestHistory {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@/txs",KUser.address];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = self.tokenModel.symbol;
    param[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    param[@"size"] = [NSString stringWithFormat:@"%d",pageSize];
    [HttpManager getWithPath:path params:param andBlock:^(id data, NSString *msg, NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (code == 0) {
            NSLog(@"%@",data);
            NSArray *tempArr = [data objectForKey:@"txs"];
            if (self.page == 1) {
                weakSelf.txs = [NSMutableArray arrayWithArray:tempArr];;
            } else {
                [weakSelf.txs addObjectsFromArray:tempArr];
            }
            if (tempArr.count < pageSize) {
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            [weakSelf.tableView reloadData];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }];
}

- (void)pushDepositVC {
    XXDepositCoinVC *depositVC = [[XXDepositCoinVC alloc] init];
    depositVC.tokenModel = self.tokenModel;
    depositVC.InnerChain = YES;
    [self.navigationController pushViewController:depositVC animated:YES];
}

- (void)pushTransferVC {
    XXTransferVC *transferVC = [[XXTransferVC alloc] init];
    transferVC.tokenModel = self.tokenModel;
    transferVC.InnerChain = YES;
    [self.navigationController pushViewController:transferVC animated:YES];
}

/// 底部第三个按钮点击事件
- (void)thirdBtnAction {
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        [self withdrawBonus];
    } else {
        if (self.tokenModel.is_native) {
            [self withdrawBonus];
        } else {
            [self chainInAction];
        }
    }
}

/// 底部第四个按钮点击事件
- (void)forthBtnAction {
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        [self depositBonus];
    } else {
        if (self.tokenModel.is_native) {
            [self depositBonus];
        } else {
            [self chainOutAction];
        }
    }
}

/// 跨链转出
- (void)chainOutAction {
    if (IsEmpty(self.tokenModel.external_address)) { //判断是否存在外链地址
        XXWithdrawChainVC *chain = [[XXWithdrawChainVC alloc] init];
        chain.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:chain animated:YES];
    } else {
        XXTransferVC *transferVC = [[XXTransferVC alloc] init];
        transferVC.tokenModel = self.tokenModel;
        transferVC.InnerChain = NO;
        [self.navigationController pushViewController:transferVC animated:YES];
    }
}

/// 跨链收款
- (void)chainInAction {
    if (IsEmpty(self.tokenModel.external_address)) { //判断是否存在外链地址
        XXWithdrawChainVC *chain = [[XXWithdrawChainVC alloc] init];
        chain.tokenModel = self.tokenModel;
        [self.navigationController pushViewController:chain animated:YES];
    } else {
        XXDepositCoinVC *depositVC = [[XXDepositCoinVC alloc] init];
        depositVC.tokenModel = self.tokenModel;
        depositVC.InnerChain = NO;
        [self.navigationController pushViewController:depositVC animated:YES];
    }
}

/// 提取分红
- (void)withdrawBonus {
    
}


/// 复投分红
- (void)depositBonus {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.txs.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.txs.count == 0) {
        return self.emptyView.height;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.txs.count == 0) {
        return self.emptyView ;
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
    [cell configData:dic];
    cell.backgroundColor = kWhiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXTransferDetailVC *detailVC = [[XXTransferDetailVC alloc] init];
    detailVC.dic = self.txs[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 104) style:UITableViewStylePlain];
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
            [weakSelf.assetManager requestAsset];
            [weakSelf requestHistory];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++;
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

- (XXMainSymbolHeaderView *)mainSymbolHeaderView {
    if (!_mainSymbolHeaderView) {
        _mainSymbolHeaderView = [[XXMainSymbolHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 248)];
    }
    return _mainSymbolHeaderView;
}

- (XXSymbolDetailFooterView *)footerView {
    if (!_footerView) {
        MJWeakSelf
        _footerView = [[XXSymbolDetailFooterView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 104, kScreen_Width, 104)];
        _footerView.tokenModel = self.tokenModel;
        _footerView.actionBlock = ^(NSInteger index) {
            if (index == 0) {
                [weakSelf pushDepositVC];
            } else if(index == 1) {
                [weakSelf pushTransferVC];
            } else if(index == 2) {
                [weakSelf thirdBtnAction];
            } else if(index == 3) {
                [weakSelf forthBtnAction];
            } else {
                
            }
        };
    }
    return _footerView;
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

- (XXAssetManager *)assetManager {
    if (!_assetManager) {
        MJWeakSelf
        _assetManager = [[XXAssetManager alloc] init];
        _assetManager.assetChangeBlock = ^{
            [weakSelf refreshHeader];
        };
    }
    return _assetManager;
}
@end
