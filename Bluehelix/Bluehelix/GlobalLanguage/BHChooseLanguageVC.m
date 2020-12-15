//
//  BHChooseLanguageVC.m
//  Bhex
//
//  Created by Bhex on 2018/8/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "BHChooseLanguageVC.h"
#import "LocalizeHelper.h"
#import "AppDelegate.h"
#import "XXTabBarController.h"
#import "BHChooseLanguageModel.h"
#import "BHChooseLanguageCell.h"
#import "XXSettingVC.h"

@interface BHChooseLanguageVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIImageView *arrowImageView;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation BHChooseLanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"Language");
    [self.view addSubview:self.tableView];
    self.data = @[@"简体中文", @"English"];
    [self buildLocalData];
}

- (void)buildLocalData {
    BHChooseLanguageModel *zhModel = [[BHChooseLanguageModel alloc] initWithName:@"简体中文" code:@"zh-Hans"];
    BHChooseLanguageModel *enModel = [[BHChooseLanguageModel alloc] initWithName:@"English" code:@"en"];
    self.data = @[zhModel,enModel];

    self.tableView.backgroundColor = KBigLine_Color;
    [self.tableView registerClass:[BHChooseLanguageCell class] forCellReuseIdentifier:@"cell"];
}

#pragma tableview
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [BHChooseLanguageCell getCellHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BHChooseLanguageModel *model = self.data[indexPath.row];
    LocalizationSetLanguage(model.languageCode);
    [self refreshLanguage];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BHChooseLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    BHChooseLanguageModel *model = self.data[indexPath.row];
    cell.langeuageModel = model;
    cell.lineView.hidden = indexPath.row == self.data.count - 1 ? YES : NO;
    return cell;
}

- (void)refreshLanguage {
    //There has two ways to update global language
    
    //The first is that create a new tabbar and that's what I choosed (like wechat)
    XXTabBarController *tabVC = [[XXTabBarController alloc] init];
    [tabVC setIndex:2];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = tabVC;
    
    XXSettingVC *settingVC = [[XXSettingVC alloc] init];
    [tabVC.selectedViewController pushViewController:settingVC animated:NO];
    
    //The second is that notification (like huobi)
     self.titleLabel.text = LocalizedString(@"Language");
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
