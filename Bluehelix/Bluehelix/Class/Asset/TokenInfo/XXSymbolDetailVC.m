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

@interface XXSymbolDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXSymbolDetailFooterView *footerView;
@property (nonatomic, strong) NSMutableArray *txs;

@end

@implementation XXSymbolDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self requestHistory];
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = self.tokenModel.symbol;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footerView];
    self.tableView.tableHeaderView = [self headerView];
}

/// 请求交易记录
- (void)requestHistory {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@/txs",KUser.address];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"token"] = self.tokenModel.symbol;
    [HttpManager getWithPath:path params:param andBlock:^(id data, NSString *msg, NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (code == 0) {
            NSLog(@"%@",data);
            weakSelf.txs = [data objectForKey:@"txs"];
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
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
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
    cell.backgroundColor = kWhite100;
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
        _tableView.backgroundColor = kWhite100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        MJWeakSelf
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf requestHistory];
        }];
    }
    return _tableView;
}

- (UIView *)headerView {
    if ([self.tokenModel.symbol isEqualToString:kMainToken]) {
        XXMainSymbolHeaderView *headerView = [[XXMainSymbolHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 248)];
        headerView.tokenModel = self.tokenModel;
        headerView.assetModel = self.assetModel;
        return headerView;
        
    } else {
        XXSymbolDetailHeaderView * headerView = [[XXSymbolDetailHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 112)];
        headerView.tokenModel = self.tokenModel;
        return headerView;
    }
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
@end
