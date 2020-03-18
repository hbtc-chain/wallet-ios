//
//  XXUserHomeVC.m
//  Bhex
//
//  Created by BHEX on 2018/6/12.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXUserHomeVC.h"
#import "XXUserHomeCell.h"
#import "XXTabBarController.h"
#import <IQKeyboardManager.h>
#import "XXAccountManageVC.h"
#import "XXUserHeaderView.h"
#import "XXBackupMnemonicPhraseVC.h"

@interface XXUserHomeVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *itemsArray;

@property (strong, nonatomic) XXButton *settingButton;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *iconArray;

@property (strong, nonatomic) XXUserHeaderView *headerView;
@end

@implementation XXUserHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - 1. 初始化数据
- (void)initData {
    self.itemsArray = [NSMutableArray array];
    self.iconArray = [NSMutableArray array];
    self.itemsArray[0] = @[LocalizedString(@"BackupMnemonicPhrase"), LocalizedString(@"ModifyPassword")];
    
//    self.itemsArray[1] = @[LocalizedString(@"HelpCenter"), LocalizedString(@"TermsOfUse"), LocalizedString(@"AboutUs")];
}

#pragma mark - 2. 初始化UI
- (void)setupUI {
    self.navView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = KLine_Color;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)rightButtonClick:(UIButton *)sender {
    XXAccountManageVC *accountVC = [[XXAccountManageVC alloc] init];
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.itemsArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXUserHomeCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXUserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXUserHomeCell"];
    if (!cell) {
        cell = [[XXUserHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXUserHomeCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSArray *namesArray = self.itemsArray[indexPath.section];
    cell.nameLabel.text = namesArray[indexPath.row];
    cell.contentView.backgroundColor = kViewBackgroundColor;
    cell.nameLabel.textColor = kDark100;
    cell.lineView.backgroundColor = KLine_Color;
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
    
    if ([itemString isEqualToString:LocalizedString(@"BackupMnemonicPhrase")]) { // 备份助记词
        [self pushBackupPhrase];
    }
}

- (void)pushBackupPhrase {
    XXBackupMnemonicPhraseVC *backup = [[XXBackupMnemonicPhraseVC alloc] init];
    [self.navigationController pushViewController:backup animated:YES];
}

#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kTabbarHeight) style:UITableViewStylePlain];
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

- (XXUserHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XXUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(256))];
    }
    return _headerView;
}
@end
