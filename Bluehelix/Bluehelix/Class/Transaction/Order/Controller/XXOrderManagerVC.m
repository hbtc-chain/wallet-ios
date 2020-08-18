//
//  XXOrdermanagerVC.m
//  Bhex
//
//  Created by Bhex on 2018/10/21.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXOrderManagerVC.h"
#import "XXOrderTypeView.h"
#import "XXCurrentOrderView.h"
#import "XXHistoryOderView.h"
#import "XXScreenOrderView.h"

@interface XXOrderManagerVC () <UIScrollViewDelegate>

/** 订单类型 */
@property (strong, nonatomic) XXOrderTypeView *typeView;

/** 滚动式图 */
@property (strong, nonatomic) UIScrollView *scrollView;

/** 当前订单 */
@property (strong, nonatomic) XXCurrentOrderView *currentView;

/** 当前筛选 */
@property (strong, nonatomic) XXScreenOrderView *currenttScreen;

/** 历史订单 */
@property (strong, nonatomic) XXHistoryOderView *historyView;

/** 历史筛选 */
@property (strong, nonatomic) XXScreenOrderView *historyScreen;

@end

@implementation XXOrderManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self setupUI];
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    [self.rightButton setImage:[UIImage textImageName:@"slider_0"] forState:UIControlStateNormal];
    self.titleLabel.text = LocalizedString(@"OrderManagement");
    [self.view addSubview:self.typeView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.currentView];
    [self.scrollView addSubview:self.historyView];
    
    [self.view addSubview:self.currenttScreen];
    [self.view addSubview:self.historyScreen];
}

#pragma mark - 2. 导航栏筛选按钮
- (void)rightButtonClick:(UIButton *)sender {
    
    if (self.typeView.indexType == 0) {
        if (self.currenttScreen.isShowing) {
            [self.currenttScreen dismiss];
        } else {
            [self.currenttScreen show];
        }
    } else if (self.typeView.indexType == 1) {
        if (self.historyScreen.isShowing) {
            [self.historyScreen dismiss];
        } else {
            [self.historyScreen show];
        }
    }
}

#pragma mark - 4. 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offX = scrollView.contentOffset.x/kScreen_Width + 0.5;
    self.typeView.changeIndex = (NSInteger)offX;
}

#pragma mark - || 懒加载
/** 订单类型 */
- (XXOrderTypeView *)typeView {
    if (_typeView == nil) {
        _typeView = [[XXOrderTypeView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, 40)];
        MJWeakSelf
        _typeView.selectOrderTypeBlock = ^(NSInteger index) {
            [weakSelf.scrollView setContentOffset:CGPointMake(kScreen_Width*index, 0) animated:YES];
        };
        
        _typeView.allOrdersCancelBlock = ^{
            [weakSelf.currentView allCancelButtonAction];
        };
    }
    return _typeView;
}

/** 滚动式图 */
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.typeView.frame), kScreen_Width, kScreen_Height - CGRectGetMaxY(self.typeView.frame))];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(kScreen_Width*2, 0);
    }
    return _scrollView;
}

/** 当前订单 */
- (XXCurrentOrderView *)currentView {
    if (_currentView == nil) {
//        _currentView = [[XXCurrentOrderView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrollView.height) withType:1];
    }
    return nil;
}

/** 当前筛选 */
- (XXScreenOrderView *)currenttScreen {
    if (_currenttScreen == nil) {
        _currenttScreen = [[XXScreenOrderView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight)];
        MJWeakSelf
        _currenttScreen.finishBlock = ^(NSString *baseToken, NSString *quoteToken, NSString *side) {
            [weakSelf.currentView screenWithBaseToken:baseToken quoteToken:quoteToken side:side];
        };
    }
    return _currenttScreen;
}


/** 历史订单 */
- (XXHistoryOderView *)historyView {
    if (_historyView == nil) {
//        _historyView = [[XXHistoryOderView alloc] initWithFrame:CGRectMake(kScreen_Width, 0, kScreen_Width, self.scrollView.height) withType:self.coinTradeType];
    }
    return _historyView;
}

/** 历史筛选 */
- (XXScreenOrderView *)historyScreen {
    if (_historyScreen == nil) {
        _historyScreen = [[XXScreenOrderView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight)];
        MJWeakSelf
        _historyScreen.finishBlock = ^(NSString *baseToken, NSString *quoteToken, NSString *side) {
            [weakSelf.historyView screenWithBaseToken:baseToken quoteToken:quoteToken side:side];
        };
    }
    return _historyScreen;
}
@end
