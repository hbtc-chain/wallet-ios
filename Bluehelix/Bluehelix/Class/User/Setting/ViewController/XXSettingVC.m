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
#import <LocalAuthentication/LAContext.h>
#import <LocalAuthentication/LAError.h>
#import <LocalAuthentication/LAPublicDefines.h>
#import "SecurityHelper.h"
#import "YZAuthID.h"
#import "XYHAlertView.h"
#import "XXTabBarController.h"
#import "XXPasswordSettingVC.h"

@interface XXSettingVC()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) UITableView *tableView;
/** 登录退出按钮 */
@property (strong, nonatomic) XXButton *loginOutButton;

@property (strong, nonatomic) NSString *selectedLanguage;
@property (strong, nonatomic) NSString *selectedRate;

@end

@implementation XXSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"Setting");
    [self setupUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    self.itemsArray = [NSMutableArray array];
    NSArray *itemOne = @[LocalizedString(@"Language"), LocalizedString(@"ExchangeRate"),LocalizedString(@"NightMode")];
    [self.itemsArray addObject:itemOne];
    if (SecurityHelperSupportFaceID) {
        [self.itemsArray addObject:@[LocalizedString(@"FaceUnlock")]];
    } else {
        [self.itemsArray addObject:@[LocalizedString(@"FingerprintUnlock")]];
    }
    [self.itemsArray addObject:@[LocalizedString(@"SecuritySetting")]];
    [self.view addSubview:self.loginOutButton];
    [self.tableView registerClass:[XXSettingCell class] forCellReuseIdentifier:@"XXSettingCell"];
}

- (void)loginOutButtonClick:(UIButton *)sender {
    XXLoginVC *loginVC = [[XXLoginVC alloc] init];
    XXNavigationController *loginNav = [[XXNavigationController alloc] initWithRootViewController:loginVC];
    KWindow.rootViewController = loginNav;
}

- (void)switchBlockFaceID:(BOOL)isOn {
    if (isOn) {
        [self openFaceID];
    } else {
        [self closeFaceID];
    }
}

- (void)closeFingerprint {
    KUser.isTouchIDLockOpen = NO;
}

#pragma mark - 3.1 开启指纹
- (void)openFingerprint {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    XXSettingCell *cell = [self.tableView cellForRowAtIndexPath: indexPath];
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
    } else {
        if (@available(iOS 11.0, *)) {
            if (authError.code == LAErrorBiometryLockout) {
                
            } else if (authError.code == LAErrorBiometryNotAvailable) {
                [MBProgressHUD showInfoMessage:LocalizedString(@"NotSupportTouchID")];
                [cell.typeSwitch setOn:NO];
                return;
            } else {
                [MBProgressHUD showInfoMessage:LocalizedString(@"NotSetTouchID")];
                [cell.typeSwitch setOn:NO];
                return;
            }
        }
    }
    
    YZAuthID *authID = [[YZAuthID alloc] init];
    [authID yz_showAuthIDWithDescribe:nil block:^(YZAuthIDState state, NSError *error) {
        if (state == YZAuthIDStateNotSupport) {
            [cell.typeSwitch setOn:NO];
            [MBProgressHUD showInfoMessage:LocalizedString(@"NotSupportTouchID")];
        } else if (state == YZAuthIDStateSuccess) {
            KUser.isTouchIDLockOpen = YES;
            [[SecurityHelper sharedSecurityHelper] saveBiometricData];
            [MBProgressHUD showSuccessMessage:LocalizedString(@"TouchIdIsOn")];
        } else if (state == YZAuthIDStatePasswordNotSet) {
            [MBProgressHUD showInfoMessage:LocalizedString(@"NotSetTouchID")];
            [cell.typeSwitch setOn:NO];
        } else {
            [cell.typeSwitch setOn:NO];
        }
    }];
}

#pragma mark open faceID
- (void)openFaceID {
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    XXSettingCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError])
    {
    } else {
        if (@available(iOS 11.0, *)) {
            if (authError.code == LAErrorBiometryLockout) {
                
            } else if (authError.code == LAErrorBiometryNotAvailable) {
                [MBProgressHUD showInfoMessage:NSLocalizedFormatString(LocalizedString(@"NotAllowFaceID"), kApp_Name)];
                [cell.typeSwitch setOn:NO];
                return;
            } else {
                [MBProgressHUD showInfoMessage:LocalizedString(@"NotSetFaceID")];
                [cell.typeSwitch setOn:NO];
                return;
            }
        }
    }
    
    YZAuthID *authID = [[YZAuthID alloc] init];
    [authID yz_showAuthIDWithDescribe:nil block:^(YZAuthIDState state, NSError *error) {
        if (state == YZAuthIDStateNotSupport) {
            [cell.typeSwitch setOn:NO];
            [XYHAlertView showAlertViewWithTitle:LocalizedString(@"NotSupportFaceID") message:nil titlesArray:nil andBlock:nil];
        } else if (state == YZAuthIDStateSuccess) {
            KUser.isFaceIDLockOpen = YES;
            [[SecurityHelper sharedSecurityHelper] saveBiometricData];
        } else if (state == YZAuthIDStatePasswordNotSet) {
            [XYHAlertView showAlertViewWithTitle:LocalizedString(@"NotSetFaceID") message:nil titlesArray:nil andBlock:nil];
            [cell.typeSwitch setOn:NO];
        } else {
            [cell.typeSwitch setOn:NO];
        }
    }];
}

#pragma mark close faceID
- (void)closeFaceID {
    KUser.isFaceIDLockOpen = NO;
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
    NSArray *namesArray = self.itemsArray[indexPath.section];
    XXSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXSettingCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = kViewBackgroundColor;
    cell.lineView.backgroundColor = KLine_Color;
    cell.nameLabel.textColor = kGray900;
    cell.valueLabel.textColor = kGray500;
    cell.nameLabel.text = namesArray[indexPath.row];
    cell.valueLabel.hidden = NO;
    cell.typeSwitch.hidden = YES;
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.rightIconImageView.hidden = NO;
        cell.valueLabel.text = [[LocalizeHelper sharedLocalSystem] getLanguageName];
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.rightIconImageView.hidden = NO;
        cell.valueLabel.text = LocalizedString([KUser.ratesKey uppercaseString]);
    } else if (indexPath.section == 0 && indexPath.row == 2) {
        cell.rightIconImageView.hidden = YES;
        cell.typeSwitch.hidden = NO;
        cell.typeSwitch.on = KUser.isNightType;
        cell.switchBlock = ^(BOOL isOn, NSInteger indexCell) {
            if (indexPath.section == 0 && indexPath.row == 2) {
                KUser.isNightType = isOn;
                KUser.isSettedNightType = YES;
                XXTabBarController *tabVC = [[XXTabBarController alloc] init];
                [tabVC setIndex:3];
                KWindow.rootViewController = tabVC;
                XXSettingVC *vc = [[XXSettingVC alloc] init];
                [tabVC.selectedViewController pushViewController:vc animated:NO];
            }
        };
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.rightIconImageView.hidden = YES;
        cell.typeSwitch.hidden = NO;
        if (SecurityHelperSupportFaceID) {
            [cell.typeSwitch setOn:KUser.isFaceIDLockOpen];
        } else {
            [cell.typeSwitch setOn:KUser.isTouchIDLockOpen];
        }
        MJWeakSelf
        cell.switchBlock = ^(BOOL isOn, NSInteger indexCell) {
            if (indexCell == 0) { // 指纹解锁
                if (SecurityHelperSupportFaceID) {
                    [weakSelf switchBlockFaceID:isOn];
                } else {
                    if (isOn) {
                        [weakSelf openFingerprint];
                    } else {
                        [weakSelf closeFingerprint];
                    }
                }
            }
        };
    } else if(indexPath.section == 2 && indexPath.row == 0) {
        cell.rightIconImageView.hidden = NO;
        if (kShowPassword) {
            cell.valueLabel.text = LocalizedString(@"NeedPassword");
        } else {
            cell.valueLabel.text = LocalizedString(@"NoNeedPassword");
        }
    }
    cell.lineView.hidden = indexPath.row == namesArray.count - 1 ? YES : NO;
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
    if ([itemString isEqualToString:LocalizedString(@"Language")]) {
        BHChooseLanguageVC *languageVC = [[BHChooseLanguageVC alloc] init];
        [self.navigationController pushViewController:languageVC animated:YES];
    } else if ([itemString isEqualToString:LocalizedString(@"ExchangeRate")]) {
        XXRatesListVC *vc = [[XXRatesListVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([itemString isEqualToString:LocalizedString(@"SecuritySetting")]) {
        XXPasswordSettingVC *vc = [[XXPasswordSettingVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        
    }
}

#pragma mark - || 懒加载
- (XXButton *)loginOutButton {
    if (_loginOutButton == nil) {
        MJWeakSelf
        _loginOutButton = [XXButton buttonWithFrame:CGRectMake(K375(24), kScreen_Height - 70 - (self.tabBarController.tabBar.height - 49), kScreen_Width - K375(48), 48) title:LocalizedString(@"LogOut") font:kFont16 titleColor:[UIColor whiteColor] block:^(UIButton *button) {
            [weakSelf loginOutButtonClick:button];
        }];
        _loginOutButton.backgroundColor = kPrimaryMain;
        _loginOutButton.layer.cornerRadius = kBtnBorderRadius;
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
