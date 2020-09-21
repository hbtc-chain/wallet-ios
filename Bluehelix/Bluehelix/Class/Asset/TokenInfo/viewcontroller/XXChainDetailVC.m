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

@interface XXChainDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXChainHeaderView *headerView;
@property (nonatomic, strong) XXAssetModel *assetModel; //资产数据
@property (nonatomic, strong) NSArray *tokenList; //资产币列表
@property (nonatomic, strong) NSMutableArray *showArray; //展示的币
@property (nonatomic, strong) XXAssetManager *assetManager;
@property (nonatomic, strong) XXEmptyView *emptyView;
@property (nonatomic, strong) NSTimer *timer; //定时刷新交易记录
@property (nonatomic, strong) XXFailureView *failureView; //无网络

@end

@implementation XXChainDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KSystem statusBarSetUpDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [KSystem statusBarSetUpWhiteColor];
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
    [self.assetManager requestAsset];
}

- (void)setupUI {
    self.titleLabel.text = [self.chainName uppercaseString];
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = KLine_Color;
    self.tableView.tableHeaderView = self.headerView;
}

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
        return [UIView new];
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

/// 搜索
/// @param textField  输入框
- (void)textFieldValueChange:(UITextField *)textField {
    textField.text = [textField.text trimmingCharacters];
    [self reloadData];
}

/// 资产列表 构造数据
- (void)reloadData {
    NSArray *sqliteArray = [[XXSqliteManager sharedSqlite] tokens];
    [self.showArray removeAllObjects];
    for (XXTokenModel *sModel in sqliteArray) {
        if ([sModel.chain isEqualToString:self.chainName]) {
            sModel.amount = @"0";
            [self.showArray addObject:sModel];
        }
    }
    NSString *external_address;
    for (XXTokenModel *assetsToken in self.assetModel.assets) {
        for (XXTokenModel *token in self.showArray) {
            if ([assetsToken.symbol isEqualToString:token.symbol]) {
                token.amount = kAmountTrim(assetsToken.amount);
                token.external_address = assetsToken.external_address;
                if ([self.chainName isEqualToString:token.chain] && !IsEmpty(assetsToken.external_address)) {
                    external_address = assetsToken.external_address;
                }
            }
        }
    }
    if (IsEmpty(external_address)) {
        self.headerView.address = KUser.address;
    } else {
        self.headerView.address = external_address;
    }
    [self.tableView reloadData];
}

/// 刷新资产
- (void)refreshAsset {
    [self.tableView.mj_header endRefreshing];
    self.assetModel = self.assetManager.assetModel;
    [self reloadData];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        MJWeakSelf
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight + 10, kScreen_Width, kScreen_Height - kTabbarHeight -10) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf.assetManager  requestAsset];
        }];
    }
    return _tableView;
}

- (XXChainHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XXChainHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(88))];
        _headerView.chain = self.chainName;
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
            [weakSelf.assetManager requestAsset];
        };
    }
    return _failureView;
}

- (XXAssetManager *)assetManager {
    if (!_assetManager) {
        MJWeakSelf
        _assetManager = [[XXAssetManager alloc] init];
        _assetManager.assetChangeBlock = ^{
            [weakSelf refreshAsset];
        };
    }
    return _assetManager;
}

@end
