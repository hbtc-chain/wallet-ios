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

/** 项目数组 */
@interface XXSettingVC()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSArray *itemsArray;
@property (strong, nonatomic) UITableView *tableView;
/** 登录退出按钮 */
@property (strong, nonatomic) XXButton *loginOutButton;

@property (strong, nonatomic) NSString *selectedLanguage;
@property (strong, nonatomic) NSString *selectedRate;

/** <#mark#> */
@property (assign, nonatomic) NSInteger clickCount;

@end

@implementation XXSettingVC
static NSString *identifir = @"XXSettingCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"Setting");
    
    // 1. 初始化UI
    [self setupUI];
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    [self.view addSubview:self.tableView];
    self.itemsArray = @[LocalizedString(@"Language"), LocalizedString(@"ExchangeRate")];
        [self.view addSubview:self.loginOutButton];
    [self.tableView registerClass:[XXSettingCell class] forCellReuseIdentifier:identifir];
}

#pragma mark - 2. 退出登录按钮点击事件
- (void)loginOutButtonClick:(UIButton *)sender {
    
//    MJWeakSelf
//    [XYHAlertView showAlertViewWithTitle:LocalizedString(@"ConfirmToLogout") message:nil titlesArray:@[LocalizedString(@"QueDing")] andBlock:^(NSInteger index) {
//        [HttpManager user_PostWithPath:@"user/authorize_cancel" params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
//            if (code == 0) {
//                KUser.isLogin = NO;
//                [NotificationManager postLoginOutSuccessNotification];
//                [MBProgressHUD showSuccessMessage:LocalizedString(@"LogoutSuccess")];
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            } else {
//                [MBProgressHUD showErrorMessage:msg];
//            }
//        }];
//    }];
}

#pragma mark - 3. 标示图
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
    cell.nameLabel.textColor = kDark100;
    cell.valueLabel.textColor = kDark50;
    cell.nameLabel.text = self.itemsArray[indexPath.row];
    cell.valueLabel.hidden = NO;
    
    if (indexPath.row == 0) {
        cell.rightIconImageView.hidden = NO;
        cell.valueLabel.text = [[LocalizeHelper sharedLocalSystem] getLanguageName];
    } else if (indexPath.row == 1) {
        cell.rightIconImageView.hidden = NO;
        cell.valueLabel.text = LocalizedString(KUser.ratesKey);
    } else if (indexPath.row == 2) {
        cell.rightIconImageView.hidden = NO;
    } else if (indexPath.row == 3) {
        cell.rightIconImageView.hidden = YES;
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        cell.valueLabel.text = [infoDic objectForKey:@"CFBundleShortVersionString"];
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
        _loginOutButton.backgroundColor = kBlue100;
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
        _tableView.backgroundColor = kWhite100;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

@end
