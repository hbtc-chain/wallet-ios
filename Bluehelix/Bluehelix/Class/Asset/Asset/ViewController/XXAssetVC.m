//
//  XXAssetVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetVC.h"
#import "XXAssetHeaderView.h"
#import "XXSecurityAlertView.h"
#import "XXPasswordView.h"
#import "XXBackupMnemonicPhraseVC.h"
#import "XXAssetCell.h"
#import "XXAssetModel.h"
#import "XXTokenModel.h"
#import "XXAssetSearchView.h"
#import "XXSymbolDetailVC.h"
#import "RatesManager.h"
#import "XXEmptyView.h"

@interface XXAssetVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXAssetHeaderView *headerView;
@property (nonatomic, strong) XXAssetModel *assetModel; //资产数据
@property (nonatomic, strong) NSArray *tokenList; //资产币列表
@property (nonatomic, strong) XXAssetSearchView *searchView; //搜索
@property (nonatomic, strong) NSMutableArray *showArray; //展示的币
@property (nonatomic, strong) XXAssetManager *assetManager;
@property (nonatomic, strong) XXEmptyView *emptyView;
@property (nonatomic, strong) NSTimer *timer; //定时刷新交易记录
@end

@implementation XXAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
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
    [self.assetManager requestAsset];
}

- (void)setupUI {
    self.navView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = KLine_Color;
    [self.headerView addSubview:self.searchView];
    self.tableView.tableHeaderView = self.headerView;
    if (!KUser.currentAccount.backupFlag) {
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
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
        return self.emptyView.height;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.showArray.count == 0) {
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
    NSArray *sqliteArray = [[XXSqliteManager sharedSqlite] showTokens];
    NSString *searchString = self.searchView.searchTextField.text;
    [self.showArray removeAllObjects];
    for (XXTokenModel *sModel in sqliteArray) {
        sModel.amount = @"0";
        if (searchString.length > 0) {
            if ([sModel.symbol containsString:searchString]) {
                [self.showArray addObject:sModel];
            }
        } else {
            [self.showArray addObject:sModel];
        }
    }
    
    for (XXTokenModel *assetsToken in self.assetModel.assets) {
        for (XXTokenModel *token in self.showArray) {
            if ([assetsToken.symbol isEqualToString:token.symbol]) {
                token.amount = kAmountTrim(assetsToken.amount);
                token.external_address = assetsToken.external_address;
            }
        }
    }
    if (KUser.isHideSmallCoin) {
        NSMutableArray *resultArray = [NSMutableArray array];
        for (XXTokenModel *token in self.showArray) {
            if (token.amount.doubleValue > 0) {
                [resultArray addObject:token];
            }
        }
        self.showArray = resultArray;
    }
    [self.tableView reloadData];
}

/// 刷新资产
- (void)refreshAsset {
    [self.tableView.mj_header endRefreshing];
    self.assetModel = self.assetManager.assetModel;
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
            [weakSelf.assetManager  requestAsset];
        }];
    }
    return _tableView;
}

- (XXAssetHeaderView  *)headerView {
    if (!_headerView) {
        MJWeakSelf
        _headerView = [[XXAssetHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(312))];
        _headerView.actionBlock = ^{
            [weakSelf.headerView configData:weakSelf.assetModel];
            [weakSelf.tableView reloadData];
        };
    }
    return _headerView;
}

- (XXAssetSearchView *)searchView {
    if (!_searchView) {
         _searchView = [[XXAssetSearchView alloc] initWithFrame:CGRectMake(0, K375(260), kScreen_Width, K375(52))];
               _searchView.backgroundColor = kWhiteColor;
               [_searchView.searchTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
               MJWeakSelf
               _searchView.actionBlock = ^{
                   [weakSelf reloadData];
               };
    }
    return _searchView;
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
