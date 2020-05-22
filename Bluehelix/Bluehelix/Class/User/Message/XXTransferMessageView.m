//
//  XXTransferMessageView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/21.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferMessageView.h"
#import "XXEmptyView.h"
#import "XXTransactionCell.h"
#import "XXMessageModel.h"
#import "XXMessageCell.h"
#import "XXTransferDetailVC.h"

@interface XXTransferMessageView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *txs;
@property (nonatomic, strong) XXEmptyView *emptyView;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) int pageSize;

@end

@implementation XXTransferMessageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.page = 1;
        self.pageSize = 30;
        [self addSubview:self.tableView];
        [self requestNotifications];
    }
    return self;
}

- (void)requestNotifications {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@/notifications",KUser.address];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = [NSString stringWithFormat:@"%d",self.page];
    param[@"size"] = [NSString stringWithFormat:@"%d",self.pageSize];
    param[@"type"] = @"1";
    [HttpManager getWithPath:path params:param andBlock:^(id data, NSString *msg, NSInteger code) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (code == 0) {
            NSLog(@"%@",data);
            NSArray *tempArr = [XXMessageModel mj_objectArrayWithKeyValuesArray:data[@"items"]];
            if (self.page == 1) {
                weakSelf.txs = [NSMutableArray arrayWithArray:tempArr];
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
    return [XXMessageCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXMessageCell  *cell = [tableView dequeueReusableCellWithIdentifier:@"XXMessageCell"];
    if (!cell) {
        cell = [[XXMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXMessageCell"];
    }
    XXMessageModel *model = self.txs[indexPath.row];
    [cell configData:model];
    cell.backgroundColor = kWhiteColor;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXMessageModel *model = self.txs[indexPath.row];
    XXTransferDetailVC *detailVC = [[XXTransferDetailVC alloc] init];
    detailVC.hashString = model.tx_hash;
    detailVC.idString = model.ID;
    [self.viewController.navigationController pushViewController:detailVC animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
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
            [weakSelf requestNotifications];
        }];
        _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.page ++;
            [weakSelf requestNotifications];
        }];
    }
    return _tableView;
}

@end
