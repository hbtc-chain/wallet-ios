//
//  XXSwitchCoinView.m
//  Bhex
//
//  Created by Bhex on 2019/5/21.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXSwitchCoinView.h"
#import "XXSwitchPairsCell.h"
#import "XXHistoryView.h"
#import "XXMenuView.h"

@interface XXSwitchCoinView () <UITableViewDelegate, UITableViewDataSource, XXMenuViewDelegate, UITextFieldDelegate> {
    dispatch_queue_t serialQueue;
}

/** <#mark#> */
@property (strong, nonatomic) XXQuoteTokenModel *tokenModel;

/** 模型数组 */
@property (strong, nonatomic) NSMutableArray *modelsArray;

/** 蒙版 */
@property (strong, nonatomic) UIVisualEffectView *mengView;

@property (strong, nonatomic) XXButton *cancelButton;

/** 版式图 */
@property (strong, nonatomic) UIView *banView;

/** 名称标签 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 菜单视图 */
@property (strong, nonatomic) XXMenuView *menuView;

/** 搜索图标 */
@property (strong, nonatomic) UIImageView *iconImageView;

/** 搜索框 */
@property (strong, nonatomic) XXTextField *searchTextField;

/** 下线 */
@property (strong, nonatomic) UIView *lineView;

/** 表示图 */
@property (strong, nonatomic) UITableView *tableView;

/** 区空提示 */
@property (strong, nonatomic) XXEmptyView *sectionAlertView;

@end

@implementation XXSwitchCoinView
static NSString *identifier = @"XXSwitchPairsCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        serialQueue = dispatch_queue_create("com.marketView.selectSymbol", DISPATCH_QUEUE_SERIAL);
        
        [self addSubview:self.mengView];
        [self addSubview:self.cancelButton];
        [self addSubview:self.banView];
        [self.banView addSubview:self.nameLabel];
        [self.banView addSubview:self.menuView];
        [self.banView addSubview:self.iconImageView];
        [self.banView addSubview:self.searchTextField];
        [self.banView addSubview:self.lineView];
        [self.banView addSubview:self.tableView];
        
        
        self.tokenModel = KMarket.dataDict[@"自选"];
        if (self.tokenModel.symbolsArray.count == 0 && KMarket.keysArray.count > 1) {
            self.tokenModel = KMarket.dataDict[KMarket.keysArray[1]];
            self.menuView.changeToIndex = 1;
        }
    }
    return self;
}

#pragma mark - 1. <XXMenuViewDelegate>
- (void)menuViewItemDidselctIndex:(NSInteger)index name:(NSString *)name {
    
    self.menuView.selectIndex = index;
    [self.tokenModel closeWebsocket];
    self.tokenModel = KMarket.dataDict[name];
    [self uploadData];
    [self WebSocketSubscribe];
}

#pragma mark - 2. <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXSwitchPairsCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.modelsArray.count == 0) {
        return self.sectionAlertView.height;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.modelsArray.count == 0) {
        return self.sectionAlertView;
    } else {
        return nil;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXSwitchPairsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.isSymbolDetail = self.isSymbolDetail;
    cell.model = self.modelsArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row >= self.modelsArray.count) {
        return;
    }
    XXSymbolModel *symbolModel = self.modelsArray[indexPath.row];
    
    if (self.isSymbolDetail) {
        if (![symbolModel.symbolId isEqualToString:KDetail.symbolModel.symbolId]) {
            KDetail.symbolModel = symbolModel;
            if (self.detailSymbolBlock) {
                self.detailSymbolBlock(1);
            }
        }
    } else {
        KTrade.coinTradeModel = symbolModel;
    }
    [self dismiss];
}

#pragma mark - 3.1 show
- (void)show {
    
    self.banView.left = - self.banView.width;
    self.mengView.alpha = 0;
    [self uploadData];
    [KWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        self.mengView.alpha = 0.92f;
        self.banView.left = 0;
    } completion:^(BOOL finished) {
        [self WebSocketSubscribe];
    }];
}

#pragma mark - 3.2 订阅
- (void)WebSocketSubscribe {
   
    MJWeakSelf
    self.tokenModel.successBlock = ^(id data) {
        [weakSelf didReceiveData:data];
    };
    [self.tokenModel openWebsocket];
}

#pragma mark - 3.3 接收到数据
- (void)didReceiveData:(NSArray *)datasArray {
    dispatch_async(serialQueue, ^{
        @synchronized(self) {
            [self integrationReceiveWebsoketData:datasArray];
        }
    });
}

#pragma mark - 3.4 处理推送过来的数据
- (void)integrationReceiveWebsoketData:(NSArray *)datasArray {
    
    if (datasArray.count == 0) {
        return;
    }
    NSDictionary *quoteDict = [datasArray lastObject];
    NSString *symbolId = quoteDict[@"s"];
    if (!symbolId) {
        return;
    }
    for (NSInteger i=0; i < self.tokenModel.symbolsArray.count; i ++) {
        XXSymbolModel *model = self.tokenModel.symbolsArray[i];
        if ([model.symbolId isEqualToString:symbolId]) {
            model.quote.time = quoteDict[@"t"];
            model.quote.close = quoteDict[@"c"];
            model.quote.high = quoteDict[@"h"];
            model.quote.low = quoteDict[@"l"];
            model.quote.open = quoteDict[@"o"];
            model.quote.volume = quoteDict[@"v"];
            break;
        }
    }
    
    for (NSInteger i=0; i < self.modelsArray.count; i ++) {
        XXSymbolModel *model = self.modelsArray[i];
        if ([model.symbolId isEqualToString:symbolId]) {
            model.quote.time = quoteDict[@"t"];
            model.quote.close = quoteDict[@"c"];
            model.quote.high = quoteDict[@"h"];
            model.quote.low = quoteDict[@"l"];
            model.quote.open = quoteDict[@"o"];
            model.quote.volume = quoteDict[@"v"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                XXSwitchPairsCell *cell = [self.tableView cellForRowAtIndexPath:path];
                if (cell) {
                    cell.model = model;
                }
            });
            break;
        }
    }
}

#pragma mark - 4. dismiss
- (void)dismiss {
    
    // 1. 取消订阅
    [self.tokenModel closeWebsocket];
    self.tokenModel.successBlock = nil;
    
    // 2. 发送广播
    if (self.isSymbolDetail) {
        if (self.detailSymbolBlock) {
            self.detailSymbolBlock(2);
        }
    } else {
        if (KTrade.coinTradeModel) {
            [NotificationManager postSwitchTradeSymbolNotification];
        }
    }

    [UIView animateWithDuration:0.25f animations:^{
        self.banView.left = - self.banView.width;
        self.mengView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 5. 输入框值变化事件
- (void)textFiledValueChange:(UITextField *)textField {
    textField.text = [textField.text trimmingCharacters];
    [self uploadData];
}

#pragma mark - 6. 更新数据
- (void)uploadData {
    NSString *searchKey = [self.searchTextField.text uppercaseString];
    if (searchKey.length > 0) {
        NSMutableArray *dataArray = [NSMutableArray array];
        for (NSInteger i=0; i < self.tokenModel.symbolsArray.count; i ++) {
            XXSymbolModel *symbolModel = self.tokenModel.symbolsArray[i];
            if ([symbolModel.symbolName containsString:searchKey]) {
                [dataArray addObject:symbolModel];
            }
        }
        self.modelsArray = dataArray;
        [self.tableView reloadData];
    } else {
        self.modelsArray = self.tokenModel.symbolsArray;
        [self.tableView reloadData];
    }
}

#pragma mark - || 懒加载
/** 蒙版 */
- (UIVisualEffectView *)mengView {
    if (_mengView == nil) {
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:KUser.isNightType ? UIBlurEffectStyleLight : UIBlurEffectStyleDark];
        _mengView = [[UIVisualEffectView alloc] initWithEffect:blur];
        _mengView.alpha = 0.98f;
        _mengView.frame = self.bounds;;
    }
    return _mengView;
}

/** 按钮 */
- (XXButton *)cancelButton {
    if (_cancelButton == nil) {
        MJWeakSelf
        _cancelButton = [XXButton buttonWithFrame:self.bounds block:^(UIButton *button) {
            [weakSelf dismiss];
        }];
        _cancelButton.backgroundColor = [UIColor clearColor];
    }
    return _cancelButton;
}


/** 版式图 */
- (UIView *)banView {
    if (_banView == nil) {
        _banView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, K375(275), kScreen_Height)];
        _banView.backgroundColor = kWhite100;
    }
    return _banView;
}

/** 名称标签 */
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), kStatusBarHeight, K375(200), 50) text:LocalizedString(@"CoinQuote") font:kFontBold24 textColor:kDark100];
    }
    return _nameLabel;
}

/** 菜单视图 */
- (XXMenuView *)menuView {
    if (_menuView == nil) {
        _menuView = [[XXMenuView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), self.banView.width, 50)];
        _menuView.layer.masksToBounds = YES;
        _menuView.delegate = self;
        _menuView.maxFont = kFontBold16;
        _menuView.minFont = kFontBold16;
        _menuView.namesArray = [NSMutableArray arrayWithArray:KMarket.keysArray];
    }
    return _menuView;
}

/** 搜索图标icon_search_0*/
- (UIImageView *)iconImageView {
    if (_iconImageView == nil) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(KSpacing, CGRectGetMaxY(self.menuView.frame) + (40 - 22)/2, 22, 22)];
        _iconImageView.image = [UIImage subTextImageName:@"icon_search_0"];
    }
    return _iconImageView;
}

/** 搜索框 */
- (XXTextField *)searchTextField {
    if (_searchTextField == nil) {
        _searchTextField = [[XXTextField alloc] initWithFrame:CGRectMake(KSpacing + 25, CGRectGetMaxY(self.menuView.frame), self.banView.width - K375(60), 40)];
        _searchTextField.backgroundColor = kViewBackgroundColor;
        _searchTextField.delegate = self;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchTextField.textColor = kDark100;
        [_searchTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
        _searchTextField.font = kFont18;
        _searchTextField.placeholder = LocalizedString(@"SearchPairs");
        _searchTextField.placeholderColor = kDark50;
        _searchTextField.placeholderFont = kFont14;
    }
    return _searchTextField;
}

/** 下线 */
- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchTextField.frame), self.banView.width, 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

/** 表示图 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), self.banView.width, self.banView.height - CGRectGetMaxY(self.lineView.frame)) style:UITableViewStylePlain];
        _tableView.backgroundColor = kWhite100;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XXSwitchPairsCell class] forCellReuseIdentifier:identifier];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

/** 区空提示 */
- (XXEmptyView *)sectionAlertView {
    if (_sectionAlertView == nil) {
        _sectionAlertView = [[XXEmptyView alloc] initWithFrame:self.tableView.bounds iamgeName:nil alert:LocalizedString(@"NoRecord")];
    }
    return _sectionAlertView;
}
@end
