//
//  XXChainDetailVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/3.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainDetailVC.h"
#import "XXSecurityAlertView.h"
#import "XXBackupMnemonicPhraseVC.h"
#import "XXAssetCell.h"
#import "XXAssetModel.h"
#import "XXTokenModel.h"
#import "XXSymbolDetailVC.h"
#import "RatesManager.h"
#import "XXEmptyView.h"
#import "XXFailureView.h"
#import "XXChainHeaderView.h"
#import "XXAssetSingleManager.h"
#import "XXMainChainHeaderView.h"
#import "XXAssetSearchHeaderView.h"
#import "XXAddNewAssetVC.h"
#import "XXChainDetailFooterView.h"
#import "XXTransferVC.h"
#import "XXTabBarController.h"
#import "XXExchangeVC.h"
#import "XXWithdrawVC.h"
#import "XXTradeViewController.h"
#import "XXMsgRequest.h"
#import "XXDepositCrossVC.h"
#import "XXDepositCoinVC.h"
#import "XXWithdrawChainVC.h"

@interface XXChainDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXChainHeaderView *headerView;
@property (nonatomic, strong) XXChainDetailFooterView *footerView;
@property (nonatomic, strong) XXAssetModel *assetModel; //资产数据
@property (nonatomic, strong) NSArray *tokenList; //资产币列表
@property (nonatomic, strong) NSMutableArray *showArray; //展示的币
@property (nonatomic, strong) XXEmptyView *emptyView;
@property (nonatomic, strong) XXFailureView *failureView; //无网络
@property (nonatomic, strong) UIView *sectionHeader;

@end

@implementation XXChainDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self refreshAsset];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAsset) name:kNotificationAssetRefresh object:nil];
}

#pragma mark 刷新资产
- (void)refreshAsset {
    [self.tableView.mj_header endRefreshing];
    self.assetModel = [XXAssetSingleManager sharedManager].assetModel;
    [self reloadData];
}

#pragma mark UI
- (void)setupUI {
    self.titleLabel.text = [self.chainModel.chain uppercaseString];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    self.tableView.separatorColor = KLine_Color;
    self.tableView.tableHeaderView = self.headerView;
}

#pragma mark 右上角点击事件
- (void)rightButtonClick:(UIButton *)sender {

}

#pragma mark 底部第一个按钮充值
- (void)firstAction {
    if ([self.chainModel.chain isEqualToString:kMainToken]) {
        XXDepositCoinVC *depositVC = [[XXDepositCoinVC alloc] init];
        [self.navigationController pushViewController:depositVC animated:YES];
    } else {
        NSString *address = [[XXAssetSingleManager sharedManager] externalAddressBySymbol:self.chainModel.chain];
        if (IsEmpty(address)) {
            XXWithdrawChainVC *chainVC = [[XXWithdrawChainVC alloc] init];
            chainVC.tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:self.chainModel.chain];
            [self.navigationController pushViewController:chainVC animated:YES];
        } else {
            XXDepositCrossVC *depositVC = [[XXDepositCrossVC alloc] init];
            depositVC.chain = self.chainModel.chain;
            [self.navigationController pushViewController:depositVC animated:YES];
        }
    }
}

#pragma mark 底部第二个按钮点击事件 转账或者提币
- (void)secondAction {
    if ([self.chainModel.chain isEqualToString:kMainToken]) {
        XXTransferVC *transferVC = [[XXTransferVC alloc] init];
        transferVC.symbol = self.chainModel.chain;
        [self.navigationController pushViewController:transferVC animated:YES];
    } else {
        XXWithdrawVC  *withdrawVC = [[XXWithdrawVC alloc] init];
        withdrawVC.symbol = self.chainModel.chain;
        [self.navigationController pushViewController:withdrawVC animated:YES];
    }
}

#pragma mark 兑换
- (void)exchangeAction {
    XXExchangeVC *exchangeVC = [[XXExchangeVC alloc] init];
    exchangeVC.swapToken = self.chainModel.chain;
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

#pragma mark 交易
- (void)tradeAction {
    XXTabBarController *tabBarVC = (XXTabBarController *)KWindow.rootViewController;
    XXNavigationController *nav = tabBarVC.viewControllers[1];
    XXTradeViewController *tradeVC = nav.viewControllers[0];
    tradeVC.urlString = [NSString stringWithFormat:@"%@/%@",kWebUrl,self.chainModel.chain];
    [tradeVC loadRequest];
    [tabBarVC setIndex:1];
}

#pragma mark tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
        if ([KUser.netWorkStatus isEqualToString:@"notReachable"]) {
            return self.failureView.height;
        } else {
            return self.emptyView.height;
        }
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
        if ([KUser.netWorkStatus isEqualToString:@"notReachable"]) {
            return self.failureView;
        } else {
            return self.emptyView ;
        }
        return self.emptyView ;
    } else {
        return self.sectionHeader;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXAssetCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXAssetCell"];
    if (!cell) {
        cell = [[XXAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXAssetCell"];
    }
    XXTokenModel *model = [XXTokenModel mj_objectWithKeyValues:self.showArray[indexPath.row]];
    [cell configData:model];
    cell.backgroundColor = kWhiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXSymbolDetailVC *detailVC = [[XXSymbolDetailVC alloc] init];
    detailVC.tokenModel = self.showArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark 资产列表 构造数据
- (void)reloadData {
    NSArray *sqliteArray = [[XXSqliteManager sharedSqlite] showTokens];
    [self.showArray removeAllObjects];
    for (XXTokenModel *sModel in sqliteArray) {
        if ([sModel.chain isEqualToString:self.chainModel.chain]) {
            sModel.amount = @"0";
            [self.showArray addObject:sModel];
        }
    }
    for (XXTokenModel *assetsToken in self.assetModel.assets) {
        for (XXTokenModel *token in self.showArray) {
            if ([assetsToken.symbol isEqualToString:token.symbol]) {
                token.amount = kAmountLongTrim(assetsToken.amount);
            }
        }
    }
    self.headerView.chainModel = self.chainModel;
    [self.tableView reloadData];
}

#pragma mark 控件
- (UITableView *)tableView {
    if (_tableView == nil) {
        MJWeakSelf
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight + 10, kScreen_Width, kScreen_Height - kNavHeight - 104) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [[XXSqliteManager sharedSqlite] requestDefaultTokens];
            [weakSelf refreshAsset];
        }];
    }
    return _tableView;
}

- (XXChainHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XXChainHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 210)];
        _headerView.chainModel = self.chainModel;
    }
    return _headerView;
}

- (NSMutableArray *)showArray {
    if (!_showArray) {
        _showArray = [[NSMutableArray alloc] init];
    }
    return _showArray;
}

- (XXEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[XXEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(300)) iamgeName:@"noAsset" alert:LocalizedString(@"NoAsset")];
    }
    return _emptyView;
}

- (XXFailureView *)failureView {
    if (_failureView == nil) {
        _failureView = [[XXFailureView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(300))];
        MJWeakSelf
        _failureView.reloadBlock = ^{
            [weakSelf refreshAsset];
        };
    }
    return _failureView;
}

- (UIView *)sectionHeader {
    if (!_sectionHeader) {
        _sectionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0)];
        _sectionHeader.backgroundColor = kWhiteColor;
    }
    return _sectionHeader;
}

- (XXChainDetailFooterView *)footerView {
    if (!_footerView) {
        MJWeakSelf
        _footerView = [[XXChainDetailFooterView alloc] initWithFrame:CGRectMake(0, kScreen_Height - 104, kScreen_Width, 104)];
        _footerView.chain = self.chainModel.chain;
        _footerView.actionBlock = ^(NSInteger index) {
            if (index == 0) {
                [weakSelf firstAction];
            } else if(index == 1) {
                [weakSelf secondAction];
            } else if(index == 2) {
                [weakSelf tradeAction];
            } else if(index == 3) {
                [weakSelf exchangeAction];
            } else {
                
            }
        };
    }
    return _footerView;
}
@end
