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

@interface BHChooseLanguageVC ()

@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation BHChooseLanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = LocalizedString(@"Language");
    self.data = @[@"简体中文", @"English", @"한국어", @"Tiếng Việt",@"日本語",@"Türkçe"];
    [self buildLocalData];
}

- (void)buildLocalData {
//    BHChooseLanguageModel *zhModel = [[BHChooseLanguageModel alloc] initWithName:@"简体中文" code:@"zh-Hans"];
//    BHChooseLanguageModel *enModel = [[BHChooseLanguageModel alloc] initWithName:@"English" code:@"en"];
//    BHChooseLanguageModel *koModel = [[BHChooseLanguageModel alloc] initWithName:@"한국어" code:@"ko"];
//    BHChooseLanguageModel *viModel = [[BHChooseLanguageModel alloc] initWithName:@"Tiếng Việt" code:@"vi-VN"];
//    BHChooseLanguageModel *jaModel = [[BHChooseLanguageModel alloc] initWithName:@"日本語" code:@"ja"];
//    BHChooseLanguageModel *trModel = [[BHChooseLanguageModel alloc] initWithName:@"Türkçe" code:@"tr"];
//    self.data = @[zhModel,enModel,koModel,viModel,jaModel,trModel];
//
//    self.tableView.backgroundColor = KBigLine_Color;
//    [self.tableView registerClass:[BHChooseLanguageCell class] forCellReuseIdentifier:@"cell"];
}

//#pragma tableview
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [BHChooseLanguageCell getCellHeight];
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { return 1; }
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.data.count;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    BHChooseLanguageModel *model = self.data[indexPath.row];
//    LocalizationSetLanguage(model.languageCode);
//    [self refreshLanguage];
//    [KConfigure.shareModel loadShareConfig];
//    [KMarket loadDataOfSymbols];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    BHChooseLanguageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    BHChooseLanguageModel *model = self.data[indexPath.row];
//    cell.langeuageModel = model;
//    cell.lineView.hidden = indexPath.row == self.data.count - 1 ? YES : NO;
//    return cell;
//}
//
//- (void)refreshLanguage {
//    //There has two ways to update global language
//    
//    //The first is that create a new tabbar and that's what I choosed (like wechat)
//    XXTabBarController *tabVC = [[XXTabBarController alloc] init];
//    [tabVC setIndex:0];
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    delegate.window.rootViewController = tabVC;
//    
//    XXUserHomeVC *userVC = [[XXUserHomeVC alloc] init];
//    XXSettingVC *settingVC = [[XXSettingVC alloc] init];
//    [tabVC.selectedViewController pushViewController:userVC animated:NO];
//    [tabVC.selectedViewController pushViewController:settingVC animated:NO];
//    
//    //The second is that notification (like huobi)
//     self.titleLabel.text = LocalizedString(@"Language");
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
