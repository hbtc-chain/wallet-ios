//
//  XXFavoriteQuoteView.m
//  Bhex
//
//  Created by YiHeng on 2020/4/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXFavoriteQuoteView.h"
#import "XXSymbolView.h"

@interface XXFavoriteQuoteView () {
    BOOL _isShowing;
}

@property (strong, nonatomic, nullable) XXSymbolView *symbolView;

/** 提示视图 */
@property (strong, nonatomic) XXEmptyView *emptyView;
@end

@implementation XXFavoriteQuoteView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 1. 接收来网通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(comeNetNotification) name:ComeNet_NotificationName object:nil];
        
        self.layer.masksToBounds = YES;
        self.backgroundColor = kWhite100;
        
        [self setupUI];
        [self reloadDataAndUI];
        // 币对列表需要更新
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadDataAndUI) name:SymbolList_NeedUpdate_NotificationName object:nil];
    }
    return self;
}

- (void)comeNetNotification {
    self.emptyView.hidden = YES;
}

#pragma mark - 1. 初始化UI
- (void)setupUI {
    [self addSubview:self.symbolView];
    [self addSubview:self.emptyView];
    if ([KUser.netWorkStatus isEqualToString:@"notReachable"]) {
        self.emptyView.hidden = NO;
    }
}

#pragma mark - 2. 刷新UI
- (void)reloadDataAndUI {
    
    XXQuoteTokenModel *quoteModel = KMarket.dataDict[@"自选"];
    if (quoteModel) {
        self.emptyView.hidden = YES;
        self.symbolView.model = quoteModel;
        if (_isShowing) {
            [self.symbolView.tableView reloadData];
            [self.symbolView openWebsocket];
        }
    }
}

#pragma mark - II 视图将要出现 和 消失 事件
- (void)show {
   
    _isShowing = YES;
    [self.symbolView.tableView reloadData];
    [self.symbolView openWebsocket];
}
- (void)dismiss {
    
    _isShowing = NO;
    [self.symbolView closeWebsocket];
}

#pragma mark - || 懒加载
- (XXSymbolView *)symbolView {
    if (_symbolView == nil) {
        _symbolView = [[XXSymbolView alloc] initWithFrame:self.bounds];
    }
    return _symbolView;
}

- (XXEmptyView *)emptyView {
    if (_emptyView == nil) {
        _emptyView = [[XXEmptyView alloc] initWithFrame:self.bounds
                                              iamgeName:nil
                                                  alert:LocalizedString(@"NoNetworking")];
        _emptyView.hidden = YES;
    }
    return _emptyView;
}
@end
