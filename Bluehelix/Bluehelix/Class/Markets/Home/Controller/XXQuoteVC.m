//
//  XXQuoteVC.m
//  Bhex
//
//  Created by Bhex on 2019/1/10.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXQuoteVC.h"
#import "XXCoinQuoteView.h"
#import <UIImageView+WebCache.h>
#import "XXFavoriteQuoteView.h"
#import "XXFavoriteEditingVC.h"
#import "XXBitcoinSearchVC.h"
#import "XXBitcoinDetailVC.h"

@interface XXQuoteVC ()

@property (strong, nonatomic) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSMutableArray *itemViewsArray;

/** 分段空间 */
@property (strong, nonatomic) XXSegmentView *segment;

/** 滚动式图 */
@property (strong, nonatomic) UIScrollView *scrollView;

/** 自选视图 */
@property (strong, nonatomic, nullable) XXFavoriteQuoteView *favoriteView;

/** 行情视图 */
@property (strong, nonatomic) XXCoinQuoteView *coinView;

@end

@implementation XXQuoteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    
    self.navView.backgroundColor = kWhite100;
    self.navView.height = kStatusBarHeight + 44;
    self.leftButton.frame = CGRectMake(K375(8), kStatusBarHeight, K375(56), 44);
    [self.leftButton setImage:[UIImage textImageName:@"editing"] forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(kScreen_Width - K375(64), kStatusBarHeight, K375(56), 44);
    [self.rightButton setImage:[UIImage textImageName:@"icon_search_0"] forState:UIControlStateNormal];
    self.titleLabel.frame = CGRectMake(K375(64), kStatusBarHeight, kScreen_Width - K375(128), 44);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = LocalizedString(@"Markets");
    
    if (self.itemsArray.count > 1) {
        [self.view addSubview:self.segment];
    }
    [self.view addSubview:self.scrollView];
    for (NSInteger i=0; i < self.itemViewsArray.count; i ++) {
        [self.scrollView addSubview:self.itemViewsArray[i]];
    }
    
    XXQuoteTokenModel *quoteModel = KMarket.dataDict[@"自选"];
    if (quoteModel.symbolsArray.count == 0) {
        self.segment.selectedSegmentIndex = 1;
    }
}

#pragma mark - 2. 分段事件
-(void)segmentChange:(XXSegmentView *)sender{

    if (sender.selectedSegmentIndex == 0) {
        self.leftButton.hidden = NO;
    } else {
        self.leftButton.hidden = YES;
    }

    for (NSInteger i=0; i < self.itemViewsArray.count; i ++) {
        XXQuoteView *currentView = self.itemViewsArray[i];
        if (i != sender.selectedSegmentIndex) {
            [currentView dismiss];
        }
    }
    if (sender.selectedSegmentIndex >= self.itemViewsArray.count) {
        return;
    }
    XXQuoteView *currentView = self.itemViewsArray[sender.selectedSegmentIndex];
    [currentView show];

    [self.scrollView setContentOffset:CGPointMake(kScreen_Width*sender.selectedSegmentIndex, 0)];
}

#pragma mark - 3. 左侧按钮点击事件
- (void)leftButtonClick:(UIButton *)sender {
    XXFavoriteEditingVC *vc = [[XXFavoriteEditingVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 4. 右侧按钮点击事件
- (void)rightButtonClick:(UIButton *)sender {
    XXBitcoinSearchVC *vc = [[XXBitcoinSearchVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
    MJWeakSelf
    vc.searchSymbolBlock = ^(XXSymbolModel *model) {
        XXBitcoinDetailVC *vc = [[XXBitcoinDetailVC alloc] init];
        KDetail.symbolModel = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - 5. 后台进入前台
- (void)didBecomeActive {
    
    XXNavigationController *navigationVC = self.tabBarController.selectedViewController;
    if ([navigationVC isKindOfClass:[XXNavigationController class]] && navigationVC.viewControllers.lastObject == self) {
        if (self.segment.selectedSegmentIndex >= self.itemViewsArray.count) {
            return;
        }
        [self segmentChange:self.segment];
    }
}

#pragma mark - 6. 前台台进入后
- (void)didEnterBackground {
    XXNavigationController *navigationVC = self.tabBarController.selectedViewController;
    if ([navigationVC isKindOfClass:[XXNavigationController class]] && navigationVC.viewControllers.lastObject == self) {
        if (self.segment.selectedSegmentIndex >= self.itemViewsArray.count) {
            return;
        }
        
        XXQuoteView *quoteView = self.itemViewsArray[self.segment.selectedSegmentIndex];
        [quoteView dismiss];
    }
}

#pragma mark - II 视图将要出现 和 消失 事件
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.segment.selectedSegmentIndex >= self.itemViewsArray.count) {
        return;
    }
    [self segmentChange:self.segment];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.segment.selectedSegmentIndex >= self.itemViewsArray.count) {
        return;
    }
    
    XXQuoteView *quoteView = self.itemViewsArray[self.segment.selectedSegmentIndex];
    [quoteView dismiss];
}

#pragma mark - || 懒加载
- (NSMutableArray *)itemsArray {
    if (_itemsArray == nil) {
        _itemsArray = [NSMutableArray array];
        [_itemsArray addObject:LocalizedString(@"Favorites")];
        [_itemsArray addObject:LocalizedString(@"CoinQuote")];
    }
    return _itemsArray;
}

- (XXSegmentView *)segment {
    if (_segment == nil) {
    
        _segment = [[XXSegmentView alloc] initWithFrame:CGRectMake(KSpacing, kNavNormalHeight + 8, kScreen_Width - KSpacing*2, 32) items:self.itemsArray];
        _segment.selectedSegmentIndex = 0;
        MJWeakSelf
        _segment.changeBlock = ^{
            [weakSelf segmentChange:weakSelf.segment];
        };
    }
    return _segment;
}

- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        
        CGFloat top = CGRectGetMaxY(self.segment.frame) + 8;
        CGFloat height = kScreen_Height - (CGRectGetMaxY(self.segment.frame) + 8) - kTabbarHeight;
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, top, kScreen_Width, height)];
        _scrollView.scrollEnabled = NO;
        _scrollView.contentSize = CGSizeMake(kScreen_Width*self.itemsArray.count, 0);
    }
    return _scrollView;
}

- (NSMutableArray *)itemViewsArray {
    if (_itemViewsArray == nil) {
        _itemViewsArray = [NSMutableArray array];
        [_itemViewsArray addObject:self.favoriteView];
        CGFloat left = kScreen_Width;
        
        self.coinView.left = left;
        [_itemViewsArray addObject:self.coinView];
        left += kScreen_Width;
    }
    return _itemViewsArray;
}


/** 自选视图 */
- (XXFavoriteQuoteView *)favoriteView {
    if (_favoriteView == nil) {
        _favoriteView = [[XXFavoriteQuoteView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrollView.height)];
    }
    return _favoriteView;
}

- (XXCoinQuoteView *)coinView {
    if (_coinView == nil) {
        _coinView = [[XXCoinQuoteView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.scrollView.height)];
    }
    return _coinView;
}
@end
