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
#import "XXRewardView.h"
#import "XXMsg.h"
#import "XXMsgRequest.h"
#import "XXPasswordView.h"
#import "XXValidatorsHomeViewController.h"
#import "XYHPickerView.h"
#import "XXExchangeVC.h"
#import "XXTabBarController.h"

@interface XXSymbolDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXSymbolDetailFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *txs;
@property (nonatomic, strong) XXAssetModel *assetModel;
@property (nonatomic, strong) XXMainSymbolHeaderView *mainSymbolHeaderView; //主代币 有分红等信息
@property (nonatomic, strong) XXSymbolDetailHeaderView *symbolDetailHeaderView; //其它币没有分红等信息
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int pageSize;
@property (nonatomic, strong) XXEmptyView *emptyView;
@property (nonatomic, strong) XXAssetManager *assetManager; // 资产请求
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
    self.titleLabel.text = [self.tokenModel.symbol uppercaseString];
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
    param[@"size"] = [NSString stringWithFormat:@"%d",self.pageSize];
    [HttpManager getWithPath:path params:param andBlock:^(id data, NSString *msg, NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (code == 0) {
            NSLog(@"%@",data);
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
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
            }];
            [alert showAlert];
        }
    }];
}

/// 请求委托地址列表
- (void)requestDelegations:(BOOL)withdrawBonusFlag {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@/delegations",KUser.address];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSLog(@"%@",data);
            weakSelf.delegations = data;
            if (withdrawBonusFlag) {
                [weakSelf withdrawBonus];
            } else {
                [weakSelf depositBonus];
            }
            
        }
    }];
}

// 委托
- (void)pushDelegate {
    XXValidatorsHomeViewController *vc = [[XXValidatorsHomeViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 收款
- (void)pushDepositVC {
    XXDepositCoinVC *depositVC = [[XXDepositCoinVC alloc] init];
    depositVC.tokenModel = self.tokenModel;
    depositVC.InnerChain = YES;
    [self.navigationController pushViewController:depositVC animated:YES];
}

// 转账
- (void)pushTransferVC {
    XXTransferVC *transferVC = [[XXTransferVC alloc] init];
    transferVC.tokenModel = self.tokenModel;
    transferVC.InnerChain = YES;
    [self.navigationController pushViewController:transferVC animated:YES];
}

/// 底部第三个按钮点击事件
- (void)thirdBtnAction {
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        [self requestDelegations:YES];
    } else {
        [self chainAction];
    }
}

/// 底部第四个按钮点击事件
- (void)forthBtnAction {
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        [self pushDelegate];
    } else {
        [self exchangeAndTradeAction];
    }
}

// 跨链
- (void)chainAction {
    MJWeakSelf
    [XYHPickerView showPickerViewWithNamesArray:@[LocalizedString(@"ChainReceiveMoney"),LocalizedString(@"ChainPayMoney")] selectIndex:100 Block:^(NSString *title, NSInteger index) {
        if (index == 0) {
            if (!weakSelf.tokenModel.is_native) {
                [weakSelf chainInAction];
            }
        } else if (index == 1) {
            if (!weakSelf.tokenModel.is_native) {
                [weakSelf chainOutAction];
            }
        } else {}
    }];
}

// 兑换 && 交易
- (void)exchangeAndTradeAction {
    MJWeakSelf
    [XYHPickerView showPickerViewWithNamesArray:@[LocalizedString(@"Exchange"),LocalizedString(@"TradesTabbar")] selectIndex:100 Block:^(NSString *title, NSInteger index) {
        if (index == 0) {
            if (!weakSelf.tokenModel.is_native) {
                [weakSelf exchangeAction];
            }
        } else if (index == 1) {
            if (!weakSelf.tokenModel.is_native) {
                [weakSelf tradeAction];
            }
        } else {}
    }];
}

// 兑换
- (void)exchangeAction {
    XXExchangeVC *exchangeVC = [[XXExchangeVC alloc] init];
    [self.navigationController pushViewController:exchangeVC animated:YES];
}

// 交易
- (void)tradeAction {
    [self.navigationController popToRootViewControllerAnimated:NO];
    XXTabBarController *tabBarVC = (XXTabBarController *)KWindow.rootViewController;
    [tabBarVC setIndex:1];
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
    NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (NSDictionary *dic in self.delegations) {
        NSString *unclaimedReward = dic[@"unclaimed_reward"];
        NSDecimalNumber *unclaimedRewardDecimal = [NSDecimalNumber decimalNumberWithString:unclaimedReward];
        sum = [sum decimalNumberByAdding:unclaimedRewardDecimal];
    }
    NSString *content = NSLocalizedFormatString(LocalizedString(@"WithdrawMoneyContent"),sum.stringValue,kMinFee);
    MJWeakSelf
    [XXRewardView showWithTitle:LocalizedString(@"WithdrawMoney") icon:@"withdrawMoneyAlert" content:content sureBlock:^{
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            [weakSelf requestWithdrawBonus:text];
        }];
    }];
}

/// 发送提取分红请求
- (void)requestWithdrawBonus:(NSString *)text {
    XXMsg *model = [[XXMsg alloc] initWithfrom:@"" to:@"" amount:@"" denom:kMainToken feeAmount:@"2000000000000000000" feeGas:@"2000000" feeDenom:kMainToken memo:@"" type:kMsgWithdrawalDelegationReward withdrawal_fee:@"" text:text];
    NSMutableArray *msgs = [NSMutableArray array];
    for (NSDictionary *dic in self.delegations) {
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"delegator_address"] = KUser.address;
        value[@"validator_address"] = dic[@"validator"];
        
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = kMsgWithdrawalDelegationReward;
        msg[@"value"] = value;
        [msgs addObject:msg];
    }
    model.msgs = msgs;
    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
}

/// 复投分红
- (void)depositBonus {
    NSDecimalNumber *sum = [NSDecimalNumber decimalNumberWithString:@"0"];
    for (NSDictionary *dic in self.delegations) {
        NSString *unclaimedReward = dic[@"unclaimed_reward"];
        NSDecimalNumber *unclaimedRewardDecimal = [NSDecimalNumber decimalNumberWithString:unclaimedReward];
        sum = [sum decimalNumberByAdding:unclaimedRewardDecimal];
    }
    NSString *content = NSLocalizedFormatString(LocalizedString(@"InMoneyContent"),sum.stringValue,kMinFee);
    MJWeakSelf
    [XXRewardView showWithTitle:LocalizedString(@"InMoney") icon:@"InMoneyAlert" content:content sureBlock:^{
        [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
            [weakSelf requestDepositBonus:text];
        }];
    }];
}

/// 发送复投分红请求
- (void)requestDepositBonus:(NSString *)text {
    XXMsg *model = [[XXMsg alloc] initWithfrom:@"" to:@"" amount:@"" denom:kMainToken feeAmount:@"2000000000000000000" feeGas:@"2000000" feeDenom:kMainToken memo:@"" type:kMsgWithdrawalDelegationReward withdrawal_fee:@"" text:text];
    NSMutableArray *msgs = [NSMutableArray array];
    for (NSDictionary *dic in self.delegations) {
        //提取
        NSMutableDictionary *value = [NSMutableDictionary dictionary];
        value[@"delegator_address"] = KUser.address;
        value[@"validator_address"] = dic[@"validator"];
        NSMutableDictionary *msg = [NSMutableDictionary dictionary];
        msg[@"type"] = kMsgWithdrawalDelegationReward;
        msg[@"value"] = value;
        [msgs addObject:msg];
        
        //代理
        NSDecimalNumber *unclaimedRewardDecimal = [NSDecimalNumber decimalNumberWithString:dic[@"unclaimed_reward"]];
        XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
        NSString *amountStr = [[unclaimedRewardDecimal decimalNumberByMultiplyingBy:kPrecisionDecimalPower(tokenModel.decimals)] stringValue];
        NSMutableDictionary *amount1 = [NSMutableDictionary dictionary];
        amount1[@"amount"] = amountStr;
        amount1[@"denom"] = kMainToken;
        
        NSMutableDictionary *value1 = [NSMutableDictionary dictionary];
        value1[@"amount"] = amount1;
        value1[@"delegator_address"] = KUser.address;
        value1[@"validator_address"] = dic[@"validator"];
        
        NSMutableDictionary *msg1 = [NSMutableDictionary dictionary];
        msg1[@"type"] = kMsgDelegate;
        msg1[@"value"] = value1;
        [msgs addObject:msg1];
    }
    model.msgs = msgs;
    _msgRequest = [[XXMsgRequest alloc] init];
    [_msgRequest sendMsg:model];
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
    NSDictionary *tx = self.txs[indexPath.row];
    XXTransferDetailVC *detailVC = [[XXTransferDetailVC alloc] init];
    detailVC.hashString = tx[@"hash"];
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
