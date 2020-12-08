//
//  XXAccountManageVC.m
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAccountManageVC.h"
#import "XXAccountCell.h"
#import "XXAccountFooterView.h"
#import "XXTabBarController.h"
#import "AppDelegate.h"

@interface XXAccountManageVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *itemsArray;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *iconArray;

@property (strong, nonatomic) XXAccountFooterView *footView;

@property (strong, nonatomic) NSString *currentAddress; //记录进来的地址 和返回的地址是否一样 如果不一样 刷新整个app
@end

@implementation XXAccountManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.currentAddress = KUser.address;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    if (![KUser.address isEqualToString:self.currentAddress]) {
        KUser.isQuickTextOpen = NO;
        XXTabBarController *tabVC = [[XXTabBarController alloc] init];
        [tabVC setIndex:3];
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController = tabVC;
    }
}

- (void)setupUI {
    self.titleLabel.text = LocalizedString(@"AccountManage");
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.footView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return KUser.accounts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXAccountCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXUserHomeCell"];
    if (!cell) {
        cell = [[XXAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXAccountCell"];
    }
    [cell configData:KUser.accounts[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XXAccountModel *model = KUser.accounts[indexPath.row];
    KUser.address = model.address;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (KUser.accounts.count > 1) {
        return YES;
    } else {
        return NO;
    }
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:LocalizedString(@"Delete") handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        XXAccountModel *selectedAccount = KUser.accounts[indexPath.row];
        if ([selectedAccount.address isEqualToString:KUser.address]) {
            XXAccountModel *firstAccount = [KUser.accounts firstObject];
            KUser.address = firstAccount.address;
        }
        [[XXSqliteManager sharedSqlite] deleteAccountByAddress:selectedAccount.address];
        [self.tableView reloadData];
    }];
    deleteAction.backgroundColor = kPrimaryMain;
    return @[deleteAction];
}

#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - 80) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = kWhiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (XXAccountFooterView *)footView {
    if (!_footView) {
        _footView = [[XXAccountFooterView alloc] initWithFrame:CGRectMake(0, self.tableView.bottom, kScreen_Width, 80)];
    }
    return _footView;
}
@end
