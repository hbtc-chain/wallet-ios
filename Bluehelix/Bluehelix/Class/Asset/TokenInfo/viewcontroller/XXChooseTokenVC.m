//
//  XXChooseTokenVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChooseTokenVC.h"
#import "XXTokenModel.h"
#import "XXAddAssetCell.h"
#import "XXAssetSearchHeaderView.h"
#import "XXFailureView.h"
#import "XXEmptyView.h"
#import "XXChooseSymbolCell.h"

@interface XXChooseTokenVC () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tokenList;
@property (nonatomic, strong) XXAssetSearchHeaderView *headerView;
@property (nonatomic, strong) XXFailureView *failureView; //无网络
@property (nonatomic, strong) XXEmptyView *emptyView;
@property (nonatomic, strong) NSMutableArray *symbols;

@end

@implementation XXChooseTokenVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self requestTokenList];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat top = kNavHeight;
    if (@available(iOS 13.0, *)) {
        top = 52;
    }
    self.tableView.frame = CGRectMake(0, top, kScreen_Width, self.view.height - top);
}

- (void)rightButtonClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupUI {
    self.titleLabel.text = LocalizedString(@"ChooseToken");
    self.rightButton.hidden = NO;
    self.leftButton.hidden = YES;
    [self.rightButton setImage:[UIImage textImageName:@"dismiss"] forState:UIControlStateNormal];
    if (@available(iOS 13.0, *)) {
        self.navView.top = - kStatusBarHeight;
    }
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = KLine_Color;
    self.tableView.tableHeaderView = self.headerView;
    [self reloadData];
}

- (void)reloadData {
//    NSArray *tokens = [XXTokenModel mj_objectArrayWithKeyValuesArray:[XXUserData sharedUserData].verifiedTokens];
    [self.tokenList removeAllObjects];
//    [self.symbols removeAllObjects];
//    for (XXTokenModel *model in tokens) {
//        if ([model.chain isEqualToString:self.chain]) {
//            [self.tokenList addObject:model];
//            [self.symbols addObject:model.symbol];
//        }
//    }
    for (XXTokenModel *token in [[XXSqliteManager sharedSqlite] showTokens]) {
        [self.tokenList addObject:token];
    }
    [self.tableView reloadData];
}

#pragma mark request
/// 请求推荐列表
- (void)requestTokenList {
    MJWeakSelf
    [MBProgressHUD showActivityMessageInView:@""];
    [HttpManager getWithPath:@"/api/v1/verified_tokens" params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUD];
        [weakSelf.tableView.mj_header endRefreshing];
        if (code == 0) {
            NSString *verifiedString = [data mj_JSONString];
            NSString *localString = [XXUserData sharedUserData].verifiedTokens;
            if (!IsEmpty(verifiedString) && ![localString isEqualToString:verifiedString]) {
                [XXUserData sharedUserData].verifiedTokens = verifiedString;
            }
            [weakSelf reloadData];
        }
    }];
}

/// 搜索币
- (void)requestSearchToken:(NSString *)text {
    MJWeakSelf
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"token"] = text;
//    dic[@"chain"] = self.chain;
    [MBProgressHUD showActivityMessageInView:@""];
    [HttpManager getWithPath:@"/api/v1/search_tokens" params:dic andBlock:^(id data, NSString *msg, NSInteger code) {
        [MBProgressHUD hideHUD];
        [weakSelf.tableView.mj_header endRefreshing];
        if (code == 0) {
            weakSelf.tokenList = [XXTokenModel mj_objectArrayWithKeyValuesArray:data];
            [[XXSqliteManager sharedSqlite] insertTokens:weakSelf.tokenList];
            [weakSelf.tableView reloadData];
        }
    }];
}

#pragma mark textField delegate
- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if (reason == UITextFieldDidEndEditingReasonCommitted && !IsEmpty(textField.text)) {
        [self requestSearchToken:textField.text];
    } else {
        [self reloadData];
    }
}

- (void)textFieldValueChange:(UITextField *)textField {
    if (IsEmpty(textField.text)) {
        [self reloadData];
    }
}

#pragma mark tableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tokenList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.tokenList.count == 0) {
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
    if (self.tokenList.count == 0) {
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
    return [XXChooseSymbolCell  getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXChooseSymbolCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXChooseSymbolCell"];
    if (!cell) {
        cell = [[XXChooseSymbolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXChooseSymbolCell"];
    }
    XXTokenModel *model = self.tokenList[indexPath.row];
    [cell configModel:model];
    cell.backgroundColor = kWhiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXTokenModel *model = self.tokenList[indexPath.row];
    if (self.changeSymbolBlock) {
        self.changeSymbolBlock(model.symbol);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark property
- (UITableView *)tableView {
    if (_tableView == nil) {
        MJWeakSelf
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, self.view.height - kNavHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            if (!IsEmpty(weakSelf.headerView.searchTextField.text)) {
                [weakSelf requestSearchToken:weakSelf.headerView.searchTextField.text];
            } else {
                [weakSelf requestTokenList];
            }
        }];
    }
    return _tableView;
}

- (XXAssetSearchHeaderView  *)headerView {
    if (!_headerView) {
        _headerView = [[XXAssetSearchHeaderView alloc] initWithFrame:CGRectMake(K375(16), 0, kScreen_Width - K375(32), 32 + 16)];
        _headerView.searchTextField.placeholder = LocalizedString(@"MoreTokenSearch");
        _headerView.searchTextField.delegate = self;
        [_headerView.searchTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];

    }
    return _headerView;
}

- (XXEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[XXEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.tableView.height - K375(32)) iamgeName:@"noData" alert:LocalizedString(@"NoData")];
    }
    return _emptyView;
}

- (XXFailureView *)failureView {
    if (_failureView == nil) {
        _failureView = [[XXFailureView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.tableView.height - K375(32))];
        MJWeakSelf
        _failureView.reloadBlock = ^{
            [weakSelf requestTokenList];
        };
    }
    return _failureView;
}

- (NSMutableArray *)tokenList {
    if (!_tokenList) {
        _tokenList = [[NSMutableArray alloc] init];
    }
    return _tokenList;
}

- (NSMutableArray *)symbols {
    if (!_symbols) {
        _symbols = [[NSMutableArray alloc] init];
    }
    return _symbols;
}

@end

