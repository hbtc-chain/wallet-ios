//
//  XXAboutUsVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/20.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAboutUsVC.h"
#import "XXSettingCell.h"
#import "XYHAlertView.h"
#import "XXUserHomeCell.h"
#import "XXAboutUsHeaderView.h"
#import "XXWebViewController.h"

@interface XXAboutUsVC()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) XXAboutUsHeaderView *headerView;
@end

@implementation XXAboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"AboutUs");
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    self.itemsArray = [NSMutableArray array];
    NSArray *itemOne = @[LocalizedString(@"ContactUs")];
    [self.itemsArray addObject:itemOne];
    [self.tableView registerClass:[XXUserHomeCell class] forCellReuseIdentifier:@"XXUserHomeCell"];
    self.tableView.tableHeaderView = self.headerView;
}

/// 联系我们
- (void)contactUs {
    XXWebViewController *webVC = [[XXWebViewController alloc] init];
    if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"zh-"]) {
        webVC.urlString = @"https://hbtcwallet.gitbook.io/hbtc-chain-guide/qian-bao-app/lian-xi-wo-men";
    } else {
        webVC.urlString = @"https://hbtcwallet.gitbook.io/hbtc-chain-guide/v/english/wallet-app/contact-us";
    }
    webVC.navTitle = LocalizedString(@"ContactUs");
    [self.navigationController pushViewController:webVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *array = self.itemsArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXSettingCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return section == 0 ? 0 : 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = kGray50;
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXUserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXUserHomeCell"];
    if (!cell) {
        cell = [[XXUserHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXUserHomeCell"];
    }
    NSArray *namesArray = self.itemsArray[indexPath.section];
    NSString *name = namesArray[indexPath.row];
    cell.nameLabel.text = name;
    cell.rightIconImageView.hidden = NO;
    cell.valueLabel.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *itemsArray = @[];
    if (indexPath.section < self.itemsArray.count) {
        itemsArray = self.itemsArray[indexPath.section];
    } else {
        return;
    }
    NSString *itemString = @"";
    if (indexPath.row < itemsArray.count) {
        itemString = itemsArray[indexPath.row];
    } else {
        return;
    }
    if ([itemString isEqualToString:LocalizedString(@"ContactUs")]) {
        [self contactUs];
    }
}

#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (XXAboutUsHeaderView *)headerView {
    if (_headerView == nil) {
        _headerView = [[XXAboutUsHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 250)];
    }
    return _headerView;
}
@end
