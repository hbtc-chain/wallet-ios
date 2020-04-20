//
//  XXRatesListVC.m
//  Bhex
//
//  Created by Bhex on 2018/8/24.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXRatesListVC.h"
#import "BHChooseLanguageCell.h"
#import "XXTabBarController.h"
#import "XXUserHomeVC.h"
#import "XXSettingVC.h"

@interface XXRatesListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation XXRatesListVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.titleLabel.text = LocalizedString(@"ExchangeRate");
    
    self.data = @[
  @{@"rateName":LocalizedString(@"CNY"), @"rateMark":@"cny"},
  @{@"rateName":LocalizedString(@"JPY"), @"rateMark":@"jpy"},
  @{@"rateName":LocalizedString(@"KRW"), @"rateMark":@"krw"},
  @{@"rateName":LocalizedString(@"USD"), @"rateMark":@"usd"},
  @{@"rateName":LocalizedString(@"VND"), @"rateMark":@"vnd"}
    ];
    [self.view addSubview:self.tableView];
   
}

#pragma tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BHChooseLanguageCell getCellHeight];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KUser.ratesKey = self.data[indexPath.row][@"rateMark"];
    XXTabBarController *tabVC = [[XXTabBarController alloc] init];
    [tabVC setIndex:3];
    KWindow.rootViewController = tabVC;
    XXSettingVC *settingVC = [[XXSettingVC alloc] init];
    [tabVC.selectedViewController pushViewController:settingVC animated:NO];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BHChooseLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary *dict = self.data[indexPath.row];
    cell.leftLabel.text = dict[@"rateName"];
    cell.arrowImageView.hidden = ![KUser.ratesKey isEqualToString:dict[@"rateMark"]];
    cell.lineView.hidden = indexPath.row == self.data.count - 1 ? YES : NO;
    return cell;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight) style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = KBigLine_Color;
        [_tableView registerClass:[BHChooseLanguageCell class] forCellReuseIdentifier:@"cell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

@end
