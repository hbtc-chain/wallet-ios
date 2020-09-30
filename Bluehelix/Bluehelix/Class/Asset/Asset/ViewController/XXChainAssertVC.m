//
//  XXChainAssertVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/3.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainAssertVC.h"
#import "XXChainDetailVC.h"
#import "XXAssetHeaderView.h"
#import "XXSecurityAlertView.h"
#import "XXPasswordView.h"
#import "XXBackupMnemonicPhraseVC.h"
#import "XXChainCell.h"
#import "XXAssetModel.h"
#import "XXTokenModel.h"
#import "XXSymbolDetailVC.h"
#import "RatesManager.h"
#import "XXEmptyView.h"
#import "SWTableViewCell.h"
#import "XXFailureView.h"
#import "SecurityHelper.h"
#import "XXVersionManager.h"
#import "XXAssetSingleManager.h"

@interface XXChainAssertVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXAssetHeaderView *headerView;
@property (nonatomic, strong) XXAssetModel *assetModel; //资产数据
@property (nonatomic, strong) NSArray *tokenList; //资产币列表
@property (nonatomic, strong) NSMutableArray *chainArray; //展示的链
@property (nonatomic, strong) XXEmptyView *emptyView;
@property (nonatomic, strong) XXFailureView *failureView; //无网络
@end

@implementation XXChainAssertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [XXVersionManager checkVersion];
    self.assetModel = [XXAssetSingleManager sharedManager].assetModel;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAsset) name:kNotificationAssetRefresh object:nil];
//    MJWeakSelf
//    [XXAssetSingleManager sharedManager].assetChangeBlock = ^{
//        [weakSelf refreshAsset];
//    };
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KSystem statusBarSetUpDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [KSystem statusBarSetUpWhiteColor];
}

- (void)setupUI {
    self.navView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = KLine_Color;
    self.tableView.tableHeaderView = self.headerView;
    if (!KUser.currentAccount.backupFlag && !IsEmpty(KUser.currentAccount.mnemonicPhrase)) {
        MJWeakSelf
        [XXSecurityAlertView showWithSureBlock:^{
            [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
                XXBackupMnemonicPhraseVC *backupVC = [[XXBackupMnemonicPhraseVC alloc] init];
                backupVC.text = text;
                [weakSelf.navigationController pushViewController:backupVC animated:YES];
            }];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chainArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.chainArray.count == 0) {
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
    if (self.chainArray.count == 0) {
        if ([KUser.netWorkStatus isEqualToString:@"notReachable"]) {
            return self.failureView;
        } else {
            return self.emptyView ;
        }
        return self.emptyView ;
    } else {
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXChainCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXChainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXAssetCell"];
    if (!cell) {
        cell = [[XXChainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXAssetCell"];
    }
    NSString *symbol = self.chainArray[indexPath.row];
    [cell configData:symbol];
    cell.backgroundColor = kWhiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXChainDetailVC *detailVC = [[XXChainDetailVC alloc] init];
    detailVC.chainName = self.chainArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

/// 搜索
/// @param textField  输入框
- (void)textFieldValueChange:(UITextField *)textField {
    textField.text = [textField.text trimmingCharacters];
    [self reloadData];
}

/// 资产列表 构造数据
- (void)reloadData {
    [self.tableView reloadData];
}

/// 刷新资产
- (void)refreshAsset {
    [self.tableView.mj_header endRefreshing];
    self.assetModel = [XXAssetSingleManager sharedManager].assetModel;
    [self reloadData];
    [self.headerView configData:self.assetModel];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        MJWeakSelf
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kTabbarHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf refreshAsset];
        }];
    }
    return _tableView;
}

- (XXAssetHeaderView  *)headerView {
    if (!_headerView) {
        MJWeakSelf
        _headerView = [[XXAssetHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(280))];
        _headerView.actionBlock = ^{
            [weakSelf.headerView configData:weakSelf.assetModel];
            [weakSelf.tableView reloadData];
        };
    }
    return _headerView;
}

- (NSMutableArray *)chainArray {
    if (!_chainArray) {
        _chainArray = [[NSMutableArray alloc] initWithObjects:@"hbc",@"btc",@"eth",@"trx", nil];
    }
    return _chainArray;
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

@end
