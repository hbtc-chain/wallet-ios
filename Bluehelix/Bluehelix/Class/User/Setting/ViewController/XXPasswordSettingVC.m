//
//  XXPasswordSettingVC.m
//  Bluehelix
//
//  Created by 袁振 on 2020/10/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXPasswordSettingVC.h"
#import "XXSettingCell.h"
#import "XXPasswordView.h"

@interface XXPasswordSettingVC()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) UITableView *tableView;
@end

@implementation XXPasswordSettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"SecuritySetting");
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.tableView];
    self.itemsArray = [NSMutableArray array];
    NSArray *itemOne = @[LocalizedString(@"NeedPasswordDefault"), LocalizedString(@"NoNeedPassword")];
    [self.itemsArray addObject:itemOne];
    [self.tableView registerClass:[XXSettingCell class] forCellReuseIdentifier:@"XXSettingCell"];
}

- (void)refreshSwitch {
    NSIndexPath *indexPath0 = [NSIndexPath indexPathForRow:0 inSection:0];
    XXSettingCell *cell0 = [self.tableView cellForRowAtIndexPath: indexPath0];
    [cell0.typeSwitch setOn:![XXUserData sharedUserData].isQuickTextOpen];

    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
    XXSettingCell *cell1 = [self.tableView cellForRowAtIndexPath: indexPath1];
    [cell1.typeSwitch setOn:[XXUserData sharedUserData].isQuickTextOpen];
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
        cell.rightIconImageView.hidden = YES;
        cell.typeSwitch.hidden = NO;
        cell.typeSwitch.on = ![XXUserData sharedUserData].isQuickTextOpen;
        MJWeakSelf
        cell.switchBlock = ^(BOOL isOn, NSInteger indexCell) {
            if (indexCell == 0) {
                if (isOn) {
                    [XXUserData sharedUserData].isQuickTextOpen = NO;
                } else {
                    [XXPasswordView showWithSureBtnBlock:^{
                        [XXUserData sharedUserData].isQuickTextOpen = YES;
                        KUser.lastPasswordTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                        [weakSelf refreshSwitch];
                    }];
                }
                [weakSelf refreshSwitch];
            }
        };
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.rightIconImageView.hidden = YES;
        cell.typeSwitch.hidden = NO;
        cell.typeSwitch.on = [XXUserData sharedUserData].isQuickTextOpen;
        MJWeakSelf
        cell.switchBlock = ^(BOOL isOn, NSInteger indexCell) {
            if (indexCell == 0) {
                if (isOn) {
                    [XXPasswordView showWithSureBtnBlock:^{
                        [XXUserData sharedUserData].isQuickTextOpen = YES;
                        KUser.lastPasswordTime = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]];
                        [weakSelf refreshSwitch];
                    }];
                } else {
                    [XXUserData sharedUserData].isQuickTextOpen = NO;
                }
                 [weakSelf refreshSwitch];
            }
        };
    }
    cell.lineView.hidden = indexPath.row == namesArray.count - 1 ? YES : NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end

