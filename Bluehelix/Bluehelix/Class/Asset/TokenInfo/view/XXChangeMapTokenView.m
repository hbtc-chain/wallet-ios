//
//  XXChangeMapTokenView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/10/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChangeMapTokenView.h"
#import "XXAccountCell.h"
#import "XXChooseTokenCell.h"
#import "XXAssetSingleManager.h"
#import "XXTokenModel.h"
#import "XXAssetSearchView.h"

@interface XXChangeMapTokenView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) XXLabel *titleLabel;
@property (nonatomic, strong) XXAssetSearchView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXButton *cancelBtn;
@property (nonatomic, assign) CGFloat contentViewHeight;
@property (nonatomic, strong) NSMutableArray *showArray;
@property (nonatomic, strong) UIButton *dismissBtn;
@end

@implementation XXChangeMapTokenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentViewHeight = 430;
    }
    return self;
}

#pragma mark 构造数据
- (void)reloadData {
    NSArray *sqliteArray = [[XXSqliteManager sharedSqlite] mappingTokens];
    // 赋值 logo name chain decimals
    for (XXTokenModel *token in [[XXSqliteManager sharedSqlite] tokens]) {
        for (XXMappingModel *map in sqliteArray) {
            if ([token.symbol isEqualToString:map.target_symbol]) {
                map.amount = @"0";
                map.name = token.name;
                map.logo = token.logo;
                map.chain = token.chain;
                map.decimals = token.decimals;
            }
        }
    }
    
    // 赋值 数量
    for (XXTokenModel *assetsToken in [XXAssetSingleManager sharedManager].assetModel.assets) {
        for (XXMappingModel *token in sqliteArray) {
            if ([assetsToken.symbol isEqualToString:token.target_symbol]) {
                token.amount = kAmountTrim(assetsToken.amount);
            }
        }
    }
    
    // 过滤search
    [self.showArray removeAllObjects];
    NSString *searchString = [self.searchView.searchTextField.text lowercaseString];
       for (XXMappingModel *map in sqliteArray) {
           if (searchString.length > 0) {
               if ([map.name containsString:searchString]) {
                   [self.showArray addObject:map];
               }
           } else {
               [self.showArray addObject:map];
           }
       }
    [self.tableView reloadData];
}

- (void)buildUI {
    [self addSubview:self.backView];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.dismissBtn];
    [self.contentView addSubview:self.searchView];
    [self.contentView addSubview:self.tableView];
//    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.cancelBtn];
    [self reloadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:kNotificationAssetRefresh object:nil];
}

+ (void)showWithSureBlock:(void (^)(XXMappingModel *model))sureBlock {
    
    XXChangeMapTokenView *alert = [[XXChangeMapTokenView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
    [KWindow addSubview:alert];
    [alert buildUI];
    alert.sureBlock = sureBlock;
    
    alert.contentView.alpha = 1;
    alert.backView.alpha = 0;
    alert.contentView.top = kScreen_Height;
    [UIView animateWithDuration:0.3 animations:^{
        alert.backView.alpha = 0.3;
        alert.contentView.top = kScreen_Height - alert.contentViewHeight;
    } completion:^(BOOL finished) {
        
    }];
}

+ (void)dismiss {
    XXChangeMapTokenView *view = (XXChangeMapTokenView *)[self currentView];
    if (view) {
        [UIView animateWithDuration:0.25 animations:^{
            view.contentView.top = kScreen_Height;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.2 animations:^{
                view.backView.alpha = 0;
                view.contentView.alpha = 0;
            } completion:^(BOOL finished) {
                [view removeFromSuperview];
            }];
        }];
    }
}

+ (UIView *)currentView {
    for (UIView *view in [KWindow subviews]) {
        if ([view isKindOfClass:[self class]]) {
            return view;
        }
    }
    return nil;
}

- (void)cancelAction {
    [[self class] dismiss];
}

#pragma mark tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXAccountCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXChooseTokenCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XXChooseTokenCell"];
    if (!cell) {
        cell = [[XXChooseTokenCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"XXChooseTokenCell"];
    }
    XXMappingModel *model = self.showArray[indexPath.row];
    [cell configData:model];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    XXMappingModel *model = self.showArray[indexPath.row];
    if (self.sureBlock) {
        self.sureBlock(model);
        [[self class] dismiss];
    }
}

/// 搜索
/// @param textField  输入框
- (void)textFieldValueChange:(UITextField *)textField {
    textField.text = [textField.text trimmingCharacters];
    [self reloadData];
}

#pragma mark 控件
- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    }
    return _backView;
}

- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - self.contentViewHeight, kScreen_Width, self.contentViewHeight)];
        _contentView.backgroundColor = kWhiteColor;
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (XXLabel*)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [XXLabel labelWithFrame:CGRectMake(0, 24, kScreen_Width, 24) font:kFontBold(20) textColor:kGray900];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = LocalizedString(@"ChooseToken");
    }
    return _titleLabel;
}

- (UIButton *)dismissBtn {
    if (_dismissBtn == nil ) {
        _dismissBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreen_Width - K375(50), 7, K375(50), K375(50))];
        [_dismissBtn setImage:[UIImage imageNamed:@"dismiss"] forState:UIControlStateNormal];
        [_dismissBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dismissBtn;
}

- (XXAssetSearchView *)searchView {
    if (!_searchView) {
         _searchView = [[XXAssetSearchView alloc] initWithFrame:CGRectMake(0, 64, kScreen_Width, 48)];
               _searchView.backgroundColor = kWhiteColor;
               [_searchView.searchTextField addTarget:self action:@selector(textFieldValueChange:) forControlEvents:UIControlEventEditingChanged];
               MJWeakSelf
               _searchView.actionBlock = ^{
                   [weakSelf reloadData];
               };
    }
    return _searchView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 112, kScreen_Width, self.contentViewHeight - 112) style:UITableViewStylePlain];
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

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentViewHeight - 76, kScreen_Width, 8)];
        _lineView.backgroundColor = kGray50;
    }
    return _lineView;
}

- (NSMutableArray *)showArray {
    if (!_showArray) {
        _showArray = [[NSMutableArray alloc] init];
    }
    return _showArray;
}

//- (XXButton *)cancelBtn {
//    if (_cancelBtn == nil) {
//        _cancelBtn = [XXButton buttonWithFrame:CGRectMake(0, self.contentViewHeight - 68, kScreen_Width, 68) title:LocalizedString(@"Cancel") font:kFontBold(17) titleColor:kPrimaryMain block:^(UIButton *button) {
//            [[self class] dismiss];
//        }];
//        _cancelBtn.backgroundColor = kWhiteColor;
//    }
//    return _cancelBtn;
//}

@end
