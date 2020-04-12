//
//  XXAddNewAssetVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/03.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAddNewAssetVC.h"
#import "XXTokenModel.h"
#import "XXAddAssetCell.h"

@interface XXAddNewAssetVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *tokenList; //资产币列表

@end

@implementation XXAddNewAssetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self requestTokenList];
}

- (void)setupUI {
    self.titleLabel.text = @"添加新资产";
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = KLine_Color;
//    self.tableView.tableHeaderView = self.headerView;
}

/// 请求币列表
- (void)requestTokenList {
    MJWeakSelf
    [HttpManager getWithPath:@"/api/v1/tokens" params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSLog(@"%@",data);
            weakSelf.tokenList = [XXTokenModel mj_objectArrayWithKeyValuesArray:data[@"tokens"]];
            [[XXSqliteManager sharedSqlite] insertTokens:weakSelf.tokenList];
            [weakSelf.tableView reloadData];
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
    return self.tokenList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXAddAssetCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXAddAssetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXAddAssetCell"];
    if (!cell) {
        cell = [[XXAddAssetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXAddAssetCell"];
    }
    XXTokenModel *model = self.tokenList[indexPath.row];
    [cell configData:model];
    cell.backgroundColor = kWhite100;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhite100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

//- (UIView  *)headerView {
//    if (!_headerView) {
//        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(312))];
//    }
//    return _headerView;
//}

@end
