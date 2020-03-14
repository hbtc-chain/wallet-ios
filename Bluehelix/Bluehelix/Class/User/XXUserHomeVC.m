//
//  XXUserHomeVC.m
//  Bhex
//
//  Created by BHEX on 2018/6/12.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXUserHomeVC.h"
#import "XXUserHeaderView.h"
#import "XXUserHomeCell.h"
#import "XXTabBarController.h"
#import <IQKeyboardManager.h>

@interface XXUserHomeVC () <UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

/** 项目数组 */
@property (strong, nonatomic) NSMutableArray *itemsArray;

/** 设置按钮 */
@property (strong, nonatomic) XXButton *settingButton;

/** 头视图 */
@property (strong, nonatomic) XXUserHeaderView *headView;

/* 表示图 */
@property (strong, nonatomic) UITableView *tableView;

/** icon name */
@property (strong, nonatomic) NSMutableArray *iconArray;

@end

@implementation XXUserHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self setupUI];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

#pragma mark - 1. 初始化数据
- (void)initData {
    self.itemsArray = [NSMutableArray array];
    self.iconArray = [NSMutableArray array];
    self.itemsArray[0] = @[LocalizedString(@"BackupMnemonicPhrase"), LocalizedString(@"ModifyPassword"), LocalizedString(@"BindNotification")];
    
    self.itemsArray[1] = @[LocalizedString(@"HelpCenter"), LocalizedString(@"TermsOfUse"), LocalizedString(@"AboutUs")];
}

#pragma mark - 2. 初始化UI
- (void)setupUI {
    [self.rightButton setImage:[UIImage subTextImageName:@"Me_setting"] forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headView;
    self.tableView.separatorColor = KLine_Color;
}

#pragma mark - 3. 标示图
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
    NSArray *imagesArray = self.iconArray[indexPath.section];
    cell.nameLabel.text = namesArray[indexPath.row];
    cell.contentView.backgroundColor = kViewBackgroundColor;
    cell.nameLabel.textColor = kDark100;
    cell.lineView.backgroundColor = KLine_Color;
    UIImage *image = [UIImage textImageName:imagesArray[indexPath.row]];;
    [cell.leftIconImageView setImage:image forState:UIControlStateNormal];
    
    if (indexPath.row == namesArray.count - 1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
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
    
//    if ([itemString isEqualToString:LocalizedString(@"SafeManagement")]) { // 安全
//        [self pushSecurityVC];
//    } else if ([itemString isEqualToString:LocalizedString(@"Verified")]) { // 实名认证
//        [self headViewClick];
//    } else if ([itemString isEqualToString:LocalizedString(@"OrderManagement")]) { // 订单
//        [self pushOrderVC];
//    } else if ([itemString isEqualToString:LocalizedString(@"WithdrawAddress")]) { // 提币地址
//        [self pushAddressVC];
//    } else if ([itemString isEqualToString:LocalizedString(@"MyInvitation")]) { // 我的邀请
//        [self pushMyInvitation];
//    }  else if ([itemString isEqualToString:LocalizedString(@"MyVoucher")]) { // 卡券
//        [self pushMyVoucher];
//    } else if ([itemString isEqualToString:LocalizedString(@"My_PointCard")]) { // 点卡
//        [self pushPointCardVC];
//    } else if ([itemString isEqualToString:LocalizedString(@"Notice")]) { // 公告
//        [self pushNoticeVC];
//    } else if ([itemString isEqualToString:LocalizedString(@"SubmitATicket")]) { // 提交工单
//        [self pushSubmitATicketVC];
//    } else if ([itemString isEqualToString:LocalizedString(@"Support")]) { // 支持
//        [self pushBeginnerGuide];
//    }
}

#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = KBigLine_Color;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 60)];
    }
    return _tableView;
}

- (XXUserHeaderView *)headView {
    if (_headView == nil) {
        _headView = [[XXUserHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 184)];
    }
    return _headView;
}

@end
