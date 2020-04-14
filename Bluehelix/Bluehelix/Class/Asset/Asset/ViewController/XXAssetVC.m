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

@interface XXAssetVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXAssetHeaderView *headerView;
@property (nonatomic, strong) XXAssetModel *assetModel; //资产数据
@property (nonatomic, strong) NSArray *tokenList; //资产币列表
@property (nonatomic, strong) XXAssetSearchView *searchView; //搜索
@property (nonatomic, strong) NSMutableArray *showArray; //展示的币
@end

@implementation XXAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self requestAsset];
//    [self requestTokenList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
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

/// 请求资产信息
- (void)requestAsset {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@",KUser.address];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (code == 0) {
            NSLog(@"%@",data);
            weakSelf.assetModel = [XXAssetModel mj_objectWithKeyValues:data];
            [weakSelf reloadData];
            [weakSelf.headerView configData:weakSelf.assetModel];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
                       }];
            [alert showAlert];
        }
    }];
}

/// 请求币列表
- (void)requestTokenList {
    MJWeakSelf
    [HttpManager getWithPath:@"/api/v1/tokens" params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSLog(@"%@",data);
            weakSelf.tokenList = [XXTokenModel mj_objectArrayWithKeyValuesArray:data[@"tokens"]];
        } else {
            Alert *alert = [[Alert alloc] initWithTitle:msg duration:kAlertDuration completion:^{
                       }];
            [alert showAlert];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
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
    cell.backgroundColor = kWhite100;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXSymbolDetailVC *detailVC = [[XXSymbolDetailVC alloc] init];
    detailVC.assetModel = self.assetModel;
    detailVC.tokenModel = self.showArray[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)textFieldValueChange:(UITextField *)textField {
    textField.text = [textField.text trimmingCharacters];
    [self reloadData];
}

- (void)reloadData {
    NSArray *sqliteArray = [[XXSqliteManager sharedSqlite] showTokens];
    NSString *searchString = self.searchView.searchTextField.text;
    [self.showArray removeAllObjects];
    for (XXTokenModel *sModel in sqliteArray) {
        if (searchString.length > 0) {
            if ([sModel.symbol containsString:searchString]) {
                [self.showArray addObject:sModel];
            }
        } else {
            [self.showArray addObject:sModel];
        }
    }
    
    for (NSDictionary *dic in self.assetModel.assets) {
        for (XXTokenModel *token in self.showArray) {
            if ([dic[@"symbol"] isEqualToString:token.symbol]) {
//                double amount = [dic[@"amount"] doubleValue];
//                NSString *amountStr = amount;
//                [KDecimal decimalNumber:[NSString stringWithFormat:@"%f",(double)amount] RoundingMode:NSRoundDown scale:token.decimals];
                token.amount = dic[@"amount"];
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

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kTabbarHeight) style:UITableViewStylePlain];
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
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
            [weakSelf requestAsset];
        }];
    }
    return _tableView;
}

- (XXAssetHeaderView  *)headerView {
    if (!_headerView) {
        _headerView = [[XXAssetHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(312))];
    }
    return _headerView;
}

- (XXAssetSearchView *)searchView {
    if (!_searchView) {
         _searchView = [[XXAssetSearchView alloc] initWithFrame:CGRectMake(0, K375(260), kScreen_Width, K375(52))];
               _searchView.backgroundColor = kWhite100;
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

@end
