//
//  XXTradeHomeVC.m
//  Bhex
//
//  Created by Bhex on 2019/1/8.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXTradeHomeVC.h"
#import "XXCoinView.h"
@interface XXTradeHomeVC ()


@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSMutableArray *itemViewsArray;

/** 分段控件 */
@property (strong, nonatomic) XXSegmentView *segment;

/** 滚动式图 */
@property (strong, nonatomic) UIScrollView *scrollView;

/** 币币视图 */
@property (strong, nonatomic) XXCoinView *coinView;

@end

@implementation XXTradeHomeVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self updateInfoOfTrade];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.coinView dismiss];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    self.navView.hidden = YES;
    if (self.itemsArray.count > 1) {
        [self.view addSubview:self.segment];
    }
    [self.view addSubview:self.scrollView];
    for (NSInteger i=0; i < self.itemViewsArray.count; i ++) {
        [self.scrollView addSubview:self.itemViewsArray[i]];
    }
    
    UIView *h = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kStatusBarHeight)];
    h.backgroundColor = kWhite100;
    [self.view addSubview:h];
}

#pragma mark - 2. 分段事件
-(void)segmentChange:(XXSegmentView *)sender{

    KTrade.indexTrade = sender.selectedSegmentIndex;
    [self updateInfoOfTrade];
    [self.scrollView setContentOffset:CGPointMake(kScreen_Width*sender.selectedSegmentIndex, 0)];
}

#pragma mark - 3. 更新交易信息
- (void)updateInfoOfTrade {
    
    if (self.segment.selectedSegmentIndex != KTrade.indexTrade) {
        self.segment.selectedSegmentIndex = KTrade.indexTrade;
        [self changeTabShowStatus:YES];
        [self segmentChange:self.segment];
    } else {
        
        for (NSInteger i=0; i < self.itemViewsArray.count; i ++) {
            UIView *currentView = self.itemViewsArray[i];
            if (i != KTrade.indexTrade) {
                if ([currentView isKindOfClass:[XXCoinView class]]) {
                    [(XXCoinView *)currentView dismiss];
                }
            }
        }

        UIView *currentView = self.itemViewsArray[KTrade.indexTrade];
        if ([currentView isKindOfClass:[XXCoinView class]]) {
            [(XXCoinView *)currentView show];
        }
    }
    
}

#pragma mark - 4. 改变tab显示状态
- (void)changeTabShowStatus:(BOOL)isShow {
    
    if (self.itemsArray.count <= 1) {
        return;
    }
    
    if (isShow) {
        [UIView animateWithDuration:0.1 animations:^{
            self.segment.top = kStatusBarHeight + (kNavNormalHeight - kStatusBarHeight - 32) / 2;
            self.scrollView.top = kNavNormalHeight;
            self.segment.alpha = 1;
        } completion:^(BOOL finished) {
            self.segment.hidden = NO;
        }];
    } else {
        [UIView animateWithDuration:0.1 animations:^{
            self.segment.top = kStatusBarHeight - self.segment.height;
            self.scrollView.top = kStatusBarHeight;
            self.segment.alpha = 0;
        } completion:^(BOOL finished) {
            self.segment.hidden = YES;
        }];
    }
}

#pragma mark - 5. 后台进入前台
- (void)didBecomeActive {
    XXNavigationController *navigationVC = self.tabBarController.selectedViewController;
    if ([navigationVC isKindOfClass:[XXNavigationController class]] && navigationVC.viewControllers.lastObject == self) {
        [self updateInfoOfTrade];
    }
}


#pragma mark - 6. 前台台进入后
- (void)didEnterBackground {
    XXNavigationController *navigationVC = self.tabBarController.selectedViewController;
    if ([navigationVC isKindOfClass:[XXNavigationController class]] && navigationVC.viewControllers.lastObject == self) {
        [self.coinView dismiss];
    }
}

#pragma mark - || 懒加载
- (NSMutableArray *)itemsArray {
    if (_itemsArray == nil) {
        _itemsArray = [NSMutableArray array];
        [_itemsArray addObject:LocalizedString(@"CoinQuote")];
    }
    return _itemsArray;
}
//
- (XXSegmentView *)segment {
    if (_segment == nil) {

        CGFloat itemsWidth = K375(100);
        CGFloat segmentWidt = self.itemsArray.count*itemsWidth;
        _segment = [[XXSegmentView alloc] initWithFrame:CGRectMake((kScreen_Width - segmentWidt)/2, kStatusBarHeight + (kNavNormalHeight - kStatusBarHeight - 32) / 2, segmentWidt, 32) items:self.itemsArray];
        MJWeakSelf
        _segment.changeBlock = ^{
            [weakSelf segmentChange:weakSelf.segment];
        };
    }
    return _segment;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        CGFloat top = kNavNormalHeight;
        CGFloat height = kScreen_Height - kNavNormalHeight - kTabbarHeight + 44;
        if (self.itemsArray.count <= 1) {
            top = kStatusBarHeight;
            height = kScreen_Height - kStatusBarHeight - kTabbarHeight;
        }
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, kScreen_Width, height)];
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(kScreen_Width*self.itemsArray.count, 0);
    }
    return _scrollView;
}

- (NSMutableArray *)itemViewsArray {
    if (_itemViewsArray == nil) {
        _itemViewsArray = [NSMutableArray array];
        [_itemViewsArray addObject:self.coinView];
        CGFloat left = kScreen_Width;
    }
    return _itemViewsArray;
}

- (XXCoinView *)coinView {
    if (_coinView == nil) {
        _coinView = [[XXCoinView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrollView.height)];
        MJWeakSelf
        _coinView.scrollBlock = ^(BOOL isShowTab) {
            [weakSelf changeTabShowStatus:isShowTab];
        };
    }
    return _coinView;
}

@end
