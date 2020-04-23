//
//  XXSettingVC.m
//  Bhex
//
//  Created by BHEX on 2018/6/15.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXSettingVC.h"
#import "XXSettingCell.h"
#import "BHChooseLanguageVC.h"
#import "XXRatesListVC.h"
#import "XXLoginVC.h"

@interface XXSettingVC()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *itemsArray;
@property (strong, nonatomic) UITableView *tableView;
/** 登录退出按钮 */
@property (strong, nonatomic) XXButton *loginOutButton;

@property (strong, nonatomic) NSString *selectedLanguage;
@property (strong, nonatomic) NSString *selectedRate;

@end

@implementation XXSettingVC
static NSString *identifir = @"XXSettingCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"Setting");
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    self.itemsArray = @[LocalizedString(@"Language"), LocalizedString(@"ExchangeRate"),LocalizedString(@"NightMode")];
    [self.view addSubview:self.loginOutButton];
    [self.tableView registerClass:[XXSettingCell class] forCellReuseIdentifier:identifir];
}

#pragma mark 退出登录按钮点击事件
- (void)loginOutButtonClick:(UIButton *)sender {
    XXLoginVC *loginVC = [[XXLoginVC alloc] init];
    XXNavigationController *loginNav = [[XXNavigationController alloc] initWithRootViewController:loginVC];
    KWindow.rootViewController = loginNav;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXSettingCell getCellHeight];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifir];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = kViewBackgroundColor;
    cell.lineView.backgroundColor = KLine_Color;
    cell.nameLabel.textColor = kGray900;
    cell.valueLabel.textColor = kGray500;
    cell.nameLabel.text = self.itemsArray[indexPath.row];
    cell.valueLabel.hidden = NO;
    cell.typeSwitch.hidden = YES;
    if (indexPath.row == 0) {
        cell.rightIconImageView.hidden = NO;
        cell.valueLabel.text = [[LocalizeHelper sharedLocalSystem] getLanguageName];
    } else if (indexPath.row == 1) {
        cell.rightIconImageView.hidden = NO;
        cell.valueLabel.text = LocalizedString([KUser.ratesKey uppercaseString]);
    } else if (indexPath.row == 2) {
        cell.rightIconImageView.hidden = YES;
        cell.typeSwitch.hidden = NO;
        cell.typeSwitch.on = KUser.isNightType;
    }
    cell.lineView.hidden = indexPath.row == self.itemsArray.count - 1 ? YES : NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        BHChooseLanguageVC *languageVC = [[BHChooseLanguageVC alloc] init];
        [self.navigationController pushViewController:languageVC animated:YES];
    } else if (indexPath.row == 1) {
        XXRatesListVC *vc = [[XXRatesListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
    }
}

#pragma mark - || 懒加载
/** 登录退出按钮 */
- (XXButton *)loginOutButton {
    if (_loginOutButton == nil) {
        MJWeakSelf
        _loginOutButton = [XXButton buttonWithFrame:CGRectMake(K375(24), kScreen_Height - 70 - (self.tabBarController.tabBar.height - 49), kScreen_Width - K375(48), 40) title:LocalizedString(@"LogOut") font:kFont16 titleColor:kMainTextColor block:^(UIButton *button) {
            [weakSelf loginOutButtonClick:button];
        }];
        _loginOutButton.backgroundColor = kPrimaryMain;
        _loginOutButton.layer.cornerRadius = 2;
        _loginOutButton.layer.masksToBounds = YES;
    }
    return _loginOutButton;
}

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

@end
