//
//  XXCoinQuoteView.m
//  Bhex
//
//  Created by Bhex on 2019/1/10.
//  Copyright © 2019年 Bhex. All rights reserved.
//

#import "XXCoinQuoteView.h"
#import "XXMenuView.h"
#import "XXSymbolView.h"
#import "XXSymbolModel.h"

@interface XXCoinQuoteView () <XXMenuViewDelegate, UIScrollViewDelegate> {
    BOOL _isShowing;
}

/** 菜单视图 */
@property (strong, nonatomic) XXMenuView *menuView;

/** 索引菜单栏 */
@property (assign, nonatomic) NSInteger indexMenu;

/** 索引菜单选项 */
@property (strong, nonatomic) NSString *marketKey;

/** 市场数组 */
@property (strong, nonatomic, nullable) NSMutableArray *keysArray;

/** 滚动视图 */
@property (strong, nonatomic) UIScrollView *scrollView;

/** 视图数组 */
@property (strong, nonatomic) NSMutableArray *viewsArray;

/** 提示视图 */
@property (strong, nonatomic) XXEmptyView *emptyView;

@end

@implementation XXCoinQuoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.masksToBounds = YES;
        
        [self initData];
        
        [self setupUI];
        
        // 币对列表需要更新
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadUI) name:SymbolList_NeedUpdate_NotificationName object:nil];

    }
    return self;
}

#pragma mark - 1.1 初始化数据
- (void)initData {

    // 1. 添加菜单视图
    [self addSubview:self.menuView];

    // 2. 添加滚动视图
    [self addSubview:self.scrollView];
    
    if ([KUser.netWorkStatus isEqualToString:@"notReachable"]) {
        [self addSubview:self.emptyView];
    }
}

#pragma mark - 1.2 初始化视图
- (void)setupUI {
    
    if (KMarket.isFinishMarketData) {
        
        // 1. 隐藏提示视图
        self.emptyView.hidden = YES;
        
        // 2. 市场数组
        if (KMarket.keysArray.count > 1) {
            self.keysArray = [NSMutableArray arrayWithArray:[KMarket.keysArray subarrayWithRange:NSMakeRange(1, KMarket.keysArray.count - 1)]];
            self.indexMenu = 0;
            self.marketKey = self.keysArray.firstObject;
            
        } else {
            return;
        }
        
        // 3. 设置菜单
        _menuView.namesArray = self.keysArray;
        
        // 4. 添加滚动视图
        for (NSInteger i=0; i < self.keysArray.count; i ++) {
            NSString *key = self.keysArray[i];
            XXSymbolView *marketView = [[XXSymbolView alloc] initWithFrame:CGRectMake(kScreen_Width*i, 0, kScreen_Width, self.scrollView.height)];
            marketView.model = KMarket.dataDict[key];
            [marketView.tableView reloadData];
            [self.scrollView addSubview:marketView];
            [self.viewsArray addObject:marketView];
        }
        
        self.scrollView.contentSize = CGSizeMake(kScreen_Width*self.viewsArray.count, 0);
        
        // 5. 订阅
        XXSymbolView *marketView = self.viewsArray[0];
        if (_isShowing) {
            [marketView openWebsocket];
        }
    }
}

#pragma mark - 1.3 刷新UI
- (void)reloadUI {
    if (self.viewsArray.count == 0) {
        [self setupUI];
    } else {
        // 1. 隐藏提示视图
        self.emptyView.hidden = YES;
        
        // 2. 市场数组
        if (KMarket.keysArray.count > 1) {
            self.keysArray = [NSMutableArray arrayWithArray:[KMarket.keysArray subarrayWithRange:NSMakeRange(1, KMarket.keysArray.count - 1)]];
        } else {
            self.keysArray = [NSMutableArray array];
        }
        
        // 2. 设置菜单
        _menuView.namesArray = self.keysArray;
        
        // 3. 添加滚动视图
        NSString *showKey = self.menuView.namesArray[self.indexMenu];
        for (NSInteger i=0; i < self.keysArray.count; i ++) {
            NSString *key = self.keysArray[i];
            if ([key isEqualToString:showKey]) {
                self.indexMenu = i;
            }
            XXSymbolView *marketView;
            if (i < self.viewsArray.count) {
                marketView = self.viewsArray[i];
            } else {
                marketView = [[XXSymbolView alloc] initWithFrame:CGRectMake(kScreen_Width*i, 0, kScreen_Width, self.scrollView.height)];
                [self.scrollView addSubview:marketView];
                [self.viewsArray addObject:marketView];
            }
            marketView.model = KMarket.dataDict[key];
            [marketView.tableView reloadData];
        }
        
        self.scrollView.contentSize = CGSizeMake(kScreen_Width*self.viewsArray.count, 0);
        
        // 4. 判断之前索引的是否符合条件
        if (self.indexMenu < self.viewsArray.count) {
            XXSymbolView *marketView = self.viewsArray[self.indexMenu];
            self.menuView.changeToIndex = self.indexMenu;
            [self.scrollView setContentOffset:CGPointMake(kScreen_Width*self.indexMenu, 0)];
            if (_isShowing) {
                [marketView openWebsocket];
            }
        } else {
            XXSymbolView *marketView = self.viewsArray[0];
            self.marketKey = self.keysArray[0];
            self.menuView.changeToIndex = 0;
            if (_isShowing) {
                [marketView openWebsocket];
            }
        }
    }
}

#pragma mark - 2. <分类按钮代理回调>
- (void)menuViewItemDidselctIndex:(NSInteger)index name:(NSString *)name  {
    
    XXSymbolView *indexView = self.viewsArray[self.indexMenu];
    [indexView closeWebsocket];
    
    self.indexMenu = index;
    self.marketKey = name;
    XXSymbolView *marketView = self.viewsArray[index];
    if ([self.marketKey isEqualToString:@"自选"]) {
        [marketView.tableView reloadData];
    }
    [marketView openWebsocket];
    [self.scrollView setContentOffset:CGPointMake(index*kScreen_Width, 0) animated:YES];
}

#pragma mark - 4. 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offX = scrollView.contentOffset.x/kScreen_Width;
    self.menuView.changeToIndex = offX;
}

// 滚动停止时，触发该函数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger count = scrollView.contentOffset.x/kScreen_Width;
    if (count != self.indexMenu) {
        XXSymbolView *indexView = self.viewsArray[self.indexMenu];
        [indexView closeWebsocket];
        
        self.indexMenu = count;
        self.marketKey = self.keysArray[count];
        XXSymbolView *marketView = self.viewsArray[count];
        [marketView openWebsocket];
    }
}


#pragma mark - II 视图将要出现 和 消失 事件
- (void)show {
   
    _isShowing = YES;
    if (self.viewsArray.count > 0) {
        XXSymbolView *indexView = self.viewsArray[self.indexMenu];
        if ([self.marketKey isEqualToString:@"自选"]) {
            [indexView.tableView reloadData];
        }
        [indexView openWebsocket];
    }
}
- (void)dismiss {
    
    _isShowing = NO;
    if (self.viewsArray.count > self.indexMenu) {
        XXSymbolView *indexView = self.viewsArray[self.indexMenu];
        [indexView closeWebsocket];
    }
}

#pragma mark - || 懒加载
- (XXEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[XXEmptyView alloc] initWithFrame:self.bounds
                                              iamgeName:nil alert:LocalizedString(@"NoNetworking")];
    }
    return _emptyView;
}

- (XXMenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [[XXMenuView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 40)];
        _menuView.delegate = self;
        _menuView.minFont = kFontBold16;
        _menuView.maxFont = kFontBold16;
        _menuView.lowLine.width = kScreen_Width;
        _menuView.alignment = NSTextAlignmentCenter;
    }
    return _menuView;
}

/** 滚动视图 */
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.menuView.height, kScreen_Width, self.height - self.menuView.height)];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

- (NSMutableArray *)viewsArray {
    if (_viewsArray == nil) {
        _viewsArray = [NSMutableArray array];
    }
    return _viewsArray;
}

- (void)dealloc {
    NSLog(@"==+==市场释放了");
}
@end
