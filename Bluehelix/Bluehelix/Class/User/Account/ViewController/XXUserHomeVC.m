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
#import "IQKeyboardManager.h"
#import "XXAccountManageVC.h"
#import "XXUserHeaderView.h"
#import "XXBackupMnemonicPhraseVC.h"
#import "XXPasswordView.h"
#import "XXSettingVC.h"
#import "XXChangePasswordVC.h"

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [KSystem statusBarSetUpWhiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [KSystem statusBarSetUpDefault];
}

- (void)initData {
    self.itemsArray = [NSMutableArray array];
    self.iconArray = [NSMutableArray array];
    if (KUser.currentAccount.mnemonicPhrase && !KUser.currentAccount.backupFlag) {
        self.itemsArray[0] = @[LocalizedString(@"BackupMnemonicPhrase"), LocalizedString(@"ModifyPassword")];
    } else {
        self.itemsArray[0] = @[LocalizedString(@"ModifyPassword")];
    }
    self.itemsArray[1] = @[LocalizedString(@"Setting"),LocalizedString(@"Version")];
}

- (void)setupUI {
    self.navView.hidden = YES;
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = KLine_Color;
    self.tableView.tableHeaderView = self.headerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.itemsArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *array = self.itemsArray[section];
    return array.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section>0) {
        return 8;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] init];
    sectionView.backgroundColor = kGray50;
    return sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXUserHomeCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXUserHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXUserHomeCell"];
    if (!cell) {
        cell = [[XXUserHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXUserHomeCell"];
    }
    NSArray *namesArray = self.itemsArray[indexPath.section];
    NSString *name = namesArray[indexPath.row];
    cell.nameLabel.text = name;
    if ([name isEqualToString:LocalizedString(@"Version")]) {
        cell.rightIconImageView.hidden = YES;
        cell.valueLabel.hidden = NO;
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSString *version = [info objectForKey:@"CFBundleShortVersionString"];
        cell.valueLabel.text = [NSString stringWithFormat:@"v%@",version];
    } else {
        cell.rightIconImageView.hidden = NO;
        cell.valueLabel.hidden = YES;
    }
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
    if ([itemString isEqualToString:LocalizedString(@"ModifyPassword")]) {
        XXChangePasswordVC *vc = [[XXChangePasswordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([itemString isEqualToString:LocalizedString(@"Setting")]) {
        [self pushSetting];
    }
}

/// 备份助记词
- (void)pushBackupPhrase {
    MJWeakSelf
    [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
        XXBackupMnemonicPhraseVC *backup = [[XXBackupMnemonicPhraseVC alloc] init];
        backup.text = text;
        [weakSelf.navigationController pushViewController:backup animated:YES];
    }];
}

/// 设置
- (void)pushSetting {
    XXSettingVC *settingVC = [[XXSettingVC alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kTabbarHeight) style:UITableViewStylePlain];
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

- (XXUserHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[XXUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, K375(256))];
    }
    return _headerView;
}

@end
