//
//  XXTransferDetailVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferDetailVC.h"
#import "XXTransferHeaderView.h"

@interface XXTransferDetailVC ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXTransferHeaderView *headerView;

@end

@implementation XXTransferDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildUI];
}

- (void)buildUI {
    self.titleLabel.text = LocalizedString(@"Transfer");
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
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
    }
    return _tableView;
}

- (XXTransferHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XXTransferHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 112) data:self.dic];
    }
    return _headerView;
}

@end
