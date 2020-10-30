//
//  XXTabBarController.m
//  Bhex
//
//  Created by BHEX on 2018/6/7.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXTabBarController.h"
#import "XXNavigationController.h"
#import "MainTabBtn.h"
#import "LocalizeHelper.h"
#import "XXBlurView.h"
#import <UIImageView+WebCache.h>
#import <UIButton+WebCache.h>

#import "XXBackupMnemonicPhraseVC.h"
#import "XXUserHomeVC.h"
#import "XXChainAssertVC.h"
#import "XXValidatorsHomeViewController.h"
#import "XXProposalsListViewController.h"
#import "XXWebViewController.h"

@interface XXTabBarController ()

/** 主视图 */
@property (strong, nonatomic) UIView *mainView;

/** 子试图属性数组 */
@property (strong, nonatomic) NSMutableArray *namesArray;

/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttonsArray;

/** 选中的分类按钮 */
@property (nonatomic, strong) MainTabBtn *senderBtn;

@end

@implementation XXTabBarController

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    
    CGRect tabFrame = self.tabBar.frame;
    CGFloat tab_H = 59;
    if (BH_IS_IPHONE_X) {
        tab_H = 83;
    }
    tabFrame.size.height = tab_H;
    tabFrame.origin.y = self.view.frame.size.height - tab_H;
    self.tabBar.frame = tabFrame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [KSystem statusBarSetUpDefault];
    self.view.backgroundColor = kWhiteColor;
    
    
    // 2. 初始化子试图控制器
    [self setupSubControllers];
    
    // 3. 添加分类按钮
    [self addItems];    
}

#pragma mark - 1. 初始化子控制器
- (void)setupSubControllers {
    
    NSMutableArray *controllers = [NSMutableArray array];
    
    XXNavigationController *nav0 = [[XXNavigationController alloc] initWithRootViewController:[[XXChainAssertVC alloc] init]];
    [controllers addObject:nav0];
    
    XXWebViewController *webVC = [[XXWebViewController alloc] init];
    webVC.urlString = kWebUrl;
    webVC.navTitle = LocalizedString(@"TradesTabbar");
    XXNavigationController *nav1 = [[XXNavigationController alloc] initWithRootViewController:webVC];
    [controllers addObject:nav1];
    
    XXNavigationController *nav3 = [[XXNavigationController alloc] initWithRootViewController:[[XXUserHomeVC alloc] init]];
    [controllers addObject:nav3];
    
    self.viewControllers = controllers;
}

#pragma mark - 2. 添加items
- (void)addItems {
    
    // 1. 创建版视图
    self.tabBar.backgroundImage = [UIImage createImageWithColor:kWhiteColor];
    [self.tabBar addSubview:self.mainView];
    
    // 2. 创建分类按钮
    self.buttonsArray = [NSMutableArray array];
    CGFloat kBtnW = kScreen_Width/self.namesArray.count;
    for (int i = 0; i < self.namesArray.count; i++) {
        MainTabBtn *mainBtn = [[MainTabBtn alloc] initWithFrame:CGRectMake(i*kBtnW, 0, kBtnW, 59)];
        if (i == 0) {
            mainBtn.selected = YES;
            self.senderBtn = mainBtn;
        }
        
        NSDictionary *dict = self.namesArray[i];
        [mainBtn setTitle:dict[@"title"] forState:UIControlStateNormal];
        [mainBtn setImage:dict[@"normalImage"] forState:UIControlStateNormal];
        [mainBtn setImage:dict[@"selectedImage"] forState:UIControlStateSelected];
        [mainBtn setTitleColor:kGray900 forState:UIControlStateNormal];
        [mainBtn setTitleColor:kPrimaryMain forState:UIControlStateSelected];
        mainBtn.tag = i;
        [mainBtn addTarget:self action:@selector(clickMainBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.mainView addSubview:mainBtn];
        [self.buttonsArray addObject:mainBtn];
    }
}


#pragma mark - 3. 分类按钮点击事件
- (void)clickMainBtn:(MainTabBtn *)sender {
    
        // 1. 改变选中状态
        self.senderBtn.selected = NO;
        
        sender.selected = YES;
        self.senderBtn = sender;
        
        // 2. 设置选中的索引的控制器
        self.selectedIndex = sender.tag;
}

#pragma mark - 5. 设置想要展现的视图
- (void)setIndex:(NSInteger)index {
    [self clickMainBtn:self.buttonsArray[index]];
}

#pragma mark - || 懒加载
- (UIView *)mainView {
    if (_mainView == nil) {
        NSInteger mainViewHeight = BH_IS_IPHONE_X ? 83 : 59;
        _mainView = [[UIView alloc] initWithFrame:CGRectMake(0, -1, kScreen_Width, mainViewHeight)];
        _mainView.backgroundColor = kWhiteColor;
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 1)];
        lineView.backgroundColor = kGray100;
        [_mainView addSubview:lineView];

    }
    return _mainView;
}

- (NSMutableArray *)namesArray {
    if (_namesArray == nil) {
        _namesArray = [NSMutableArray array];

        [_namesArray addObject:@{
                                 @"title":LocalizedString(@"Asset"),
                                 @"normalImage":[UIImage textImageName:@"tabbarNew_0"],
                                 @"selectedImage":[UIImage mainImageName:@"tabbarNew_0"]
                                 }];
        [_namesArray addObject:@{
                                        @"title":LocalizedString(@"TradesTabbar"),
                                        @"normalImage":[UIImage textImageName:@"tabbarNew_1"],
                                        @"selectedImage":[UIImage mainImageName:@"tabbarNew_1"]
                                        }];
        
//        [_namesArray addObject:@{
//        @"title":LocalizedString(@"TradesTabbar"),
//        @"normalImage":[UIImage textImageName:@"tabbarNew_2"],
//        @"selectedImage":[UIImage mainImageName:@"tabbarNew_2"]
//        }];
        
//        [_namesArray addObject:@{
//                                 @"title":LocalizedString(@"Validator"),
//                                 @"normalImage":[UIImage textImageName:@"tabbarNew_1"],
//                                 @"selectedImage":[UIImage mainImageName:@"tabbarNew_1"]
//                                 }];
//
//        [_namesArray addObject:@{
//                                 @"title":LocalizedString(@"Proposal"),
//                                 @"normalImage":[UIImage textImageName:@"tabbarNew_2"],
//                                 @"selectedImage":[UIImage mainImageName:@"tabbarNew_2"]
//                                 }];
        
        
        [_namesArray addObject:@{
                                 @"title":LocalizedString(@"Me"),
                                 @"normalImage":[UIImage textImageName:@"tabbarNew_3"],
                                 @"selectedImage":[UIImage mainImageName:@"tabbarNew_3"]
                                 }];
    }
    return _namesArray;
}

@end

