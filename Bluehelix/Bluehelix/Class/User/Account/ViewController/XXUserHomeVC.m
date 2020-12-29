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
#import "XXBackupPrivateKeyTipVC.h"
#import "XXBackupKeystoreTipVC.h"
#import "XYHAlertView.h"
#import "XXWebViewController.h"
#import "XXAboutUsVC.h"

@interface XXUserHomeVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSMutableArray *itemsArray;

@property (strong, nonatomic) XXButton *settingButton;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) XXUserHeaderView *headerView;

@property (strong, nonatomic) NSTimer *timer;
@end

@implementation XXUserHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];
    MJWeakSelf
    self.timer = [NSTimer scheduledTimerWithTimeInterval:60 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf requestNotifications];
    }];
    [self.timer fire];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self requestNotifications];
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
    NSMutableArray *firstSectionArray = [NSMutableArray array];
    if (KUser.currentAccount.mnemonicPhrase && !KUser.currentAccount.backupFlag) {
        [firstSectionArray addObject:LocalizedString(@"BackupMnemonicPhrase")];
    }
    [firstSectionArray addObject:LocalizedString(@"BackupPrivateKey")];
    [firstSectionArray addObject:LocalizedString(@"BackupKeystore")];
    self.itemsArray[0] = firstSectionArray;
    self.itemsArray[1] = @[LocalizedString(@"Notice"),LocalizedString(@"HelpCenter")];
    self.itemsArray[2] = @[LocalizedString(@"AboutUs"),LocalizedString(@"Setting")];
}

/// 请求消息列表
- (void)requestNotifications {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@/notifications",KUser.address];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @"1";
    param[@"size"] = @"30";
    [HttpManager getWithPath:path params:param andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSNumber *unRead = data[@"unread"];
            [weakSelf.headerView setUnreadNum:unRead];
            NSLog(@"%@",data);
        }
    }];
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
    
    if ([itemString isEqualToString:LocalizedString(@"BackupMnemonicPhrase")]) { // 备份助记词
        [self pushBackupPhrase];
    }
    if ([itemString isEqualToString:LocalizedString(@"BackupKeystore")]) { // 备份Keystore
        [self pushBackupKeystore];
    }
    if ([itemString isEqualToString:LocalizedString(@"BackupPrivateKey")]) { // 备份私钥
        [self pushBackupPrivateKey];
    }
    if ([itemString isEqualToString:LocalizedString(@"Setting")]) {
        [self pushSetting];
    }
    if ([itemString isEqualToString:LocalizedString(@"Notice")]) {
        [self pushNotice];
    }
    if ([itemString isEqualToString:LocalizedString(@"HelpCenter")]) {
        [self pushHelpCenter];
    }
    if ([itemString isEqualToString:LocalizedString(@"AboutUs")]) {
        [self pushAboutUs];
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

/// 备份Keystore
- (void)pushBackupKeystore {
    MJWeakSelf
    [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
        XXBackupKeystoreTipVC *tipVC = [[XXBackupKeystoreTipVC alloc] init];
        tipVC.text = text;
        [weakSelf.navigationController pushViewController:tipVC animated:YES];
    }];
}

/// 备份Private
- (void)pushBackupPrivateKey {
    MJWeakSelf
    [XXPasswordView showWithSureBtnBlock:^(NSString * _Nonnull text) {
        XXBackupPrivateKeyTipVC *privateKeyTipVC = [[XXBackupPrivateKeyTipVC alloc] init];
        privateKeyTipVC.text = text;
        [weakSelf.navigationController pushViewController:privateKeyTipVC animated:YES];
    }];
}

/// 设置
- (void)pushSetting {
    XXSettingVC *settingVC = [[XXSettingVC alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}


/// 关于我们
- (void)pushAboutUs {
    XXAboutUsVC *aboutUs = [[XXAboutUsVC alloc] init];
    [self.navigationController pushViewController:aboutUs animated:YES];
}

// 公告
- (void)pushNotice {
    XXWebViewController *webVC = [[XXWebViewController alloc] init];
    if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"zh-"]) {
        webVC.urlString = @"https://hbtcwallet.gitbook.io/hbtc-chain-guide/gong-gao/";
    } else {
        webVC.urlString = @"https://hbtcwallet.gitbook.io/hbtc-chain-guide/v/english/announcement/";
    }
    webVC.navTitle = LocalizedString(@"Notice");
    [self.navigationController pushViewController:webVC animated:YES];
}

// 帮助中心
- (void)pushHelpCenter {
    XXWebViewController *webVC = [[XXWebViewController alloc] init];
    if ([[[LocalizeHelper sharedLocalSystem] getLanguageCode] hasPrefix:@"zh-"]) {
        webVC.urlString = @"https://hbtcwallet.gitbook.io/hbtc-chain-guide/";
    } else {
        webVC.urlString = @"https://hbtcwallet.gitbook.io/hbtc-chain-guide/v/english/";
    }
    webVC.navTitle = LocalizedString(@"HelpCenter");
    [self.navigationController pushViewController:webVC animated:YES];
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
