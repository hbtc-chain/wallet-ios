//
//  XXMarketSearchVC.m
//  Bhex
//
//  Created by BHEX on 2018/7/1.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXBitcoinSearchVC.h"
#import "XXMarketSearchCell.h"
#import "XXHistoryView.h"

@interface XXBitcoinSearchVC () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

/** 币对元数据数组 */
@property (strong, nonatomic, nullable) NSArray *symbolsArray;

/** 模型数组 */
@property (strong, nonatomic) NSMutableArray *modelsArray;

/** 搜索视图 */
@property (strong, nonatomic) UIView *searchView;

/** 搜索图标 */
@property (strong, nonatomic) UIImageView *searchIconImageView;

/** 搜索框 */
@property (strong, nonatomic) XXTextField *searchTextField;

/** 取消按钮 */
@property (strong, nonatomic) XXButton *cancelButton;

/** 区空提示 */
@property (strong, nonatomic) XXEmptyView *sectionAlertView;

/** 历史视图 */
@property (strong, nonatomic) XXHistoryView *historyView;

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation XXBitcoinSearchVC
static NSString *identifier = @"XXMarketSearchCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *symbolsString = [[NSUserDefaults standardUserDefaults] objectForKey:@"allSymbolsStringKey"];
    self.symbolsArray =  [symbolsString mj_JSONObject];
    
    self.leftButton.hidden = YES;
    self.navView.height = kStatusBarHeight + 44;
    self.navLineView.top = self.navView.height - 1;
    self.navLineView.hidden = YES;
    [self.navView addSubview:self.searchView];
    [self.searchView addSubview:self.searchIconImageView];
    [self.searchView addSubview:self.searchTextField];
    [self.navView addSubview:self.cancelButton];

    [self.view addSubview:self.tableView];
}

#pragma mark - 1.1 输入框值变化事件
- (void)textFiledValueChange:(UITextField *)textField {
    textField.text = [textField.text trimmingCharacters];
    if (textField.text.length > 0) {
        NSString *searchKey = [textField.text uppercaseString];
        self.tableView.userInteractionEnabled = NO;
        if (self.modelsArray) {
            [self.modelsArray removeAllObjects];
        } else {
            self.modelsArray = [NSMutableArray array];
        }
        
        for (NSDictionary *dict in self.symbolsArray) {
            NSString *symbolId = dict[@"symbolId"];
            XXSymbolModel *model = KMarket.symbolsDict[symbolId];
            if (IsEmpty(model)) {
                continue;
            }
            NSString *symbolName = [NSString stringWithFormat:@"%@%@", model.baseTokenName, model.quoteTokenName];
            if ([symbolName containsString:searchKey] && model.isInTradeSection == YES) {
                [self.modelsArray addObject:model];
            }
        }
        [self.tableView reloadData];
        self.tableView.userInteractionEnabled = YES;
    } else {
        [self.modelsArray removeAllObjects];
        [self.tableView reloadData];
    }
}

#pragma mark - 2. 输入框 Return 事件
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField.text trimmingCharacters].length > 0) {
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - 3. <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.searchTextField.text trimmingCharacters].length == 0 && self.historyView.modelsArray.count > 0) {
        return self.historyView.height;
    } else if (self.modelsArray.count == 0) {
        return self.sectionAlertView.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.searchTextField.text trimmingCharacters].length == 0 && self.historyView.modelsArray.count > 0) {
        return self.historyView;
    } else if (self.modelsArray.count == 0) {
        if ([self.searchTextField.text trimmingCharacters].length == 0) {
            self.sectionAlertView.nameLabel.text = LocalizedString(@"NoRecord");
        } else {
            self.sectionAlertView.nameLabel.text = LocalizedString(@"NoResultsMatched");
        }
        return self.sectionAlertView;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXMarketSearchCell getCellHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXMarketSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.modelsArray[indexPath.item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row >= self.modelsArray.count) {
        return;
    }
    XXSymbolModel *model = self.modelsArray[indexPath.row];
//    NSMutableArray *symbolsArray = [NSMutableArray arrayWithArray:KUser.searchSymbolsArray];
//    [symbolsArray removeObject:model.symbolId];
//    [symbolsArray insertObject:model.symbolId atIndex:0];
//    KUser.searchSymbolsArray = symbolsArray;
    
    [self.navigationController popViewControllerAnimated:NO];
    if (self.searchSymbolBlock) {
        self.searchSymbolBlock(model);
    }
}

#pragma mark - 11. 滑动代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offY = scrollView.contentOffset.y;
    if (offY > kNavShadowHeight) {
        self.navView.layer.shadowOpacity = 1;
    } else {
        self.navView.layer.shadowOpacity = offY/kNavShadowHeight;

    }
}

#pragma mark - 视图将要出现和消失
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchTextField becomeFirstResponder];
}

#pragma mark - 懒加载
- (UIView *)searchView {
    if (_searchView == nil) {
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(15, kStatusBarHeight + 6, kScreen_Width - 80, 32)];
        _searchView.backgroundColor = KBigLine_Color;
        _searchView.layer.cornerRadius = _searchView.height / 2.0f;
        _searchView.layer.masksToBounds = YES;
    }
    return _searchView;
}

- (UIImageView *)searchIconImageView {
    if (_searchIconImageView == nil) {
        _searchIconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, (self.searchView.height - 24)/2, 24, 24)];
        _searchIconImageView.image = [UIImage subTextImageName:@"icon_search_0"];
   
    }
    return _searchIconImageView;
}

- (XXTextField *)searchTextField {
    if (_searchTextField == nil) {
        _searchTextField = [[XXTextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.searchIconImageView.frame) + 8, 0, self.searchView.width - (CGRectGetMaxX(self.searchIconImageView.frame) + 10) - 44, self.searchView.height)];
        _searchTextField.delegate = self;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchTextField.textColor = kDark100;
        [_searchTextField addTarget:self action:@selector(textFiledValueChange:) forControlEvents:UIControlEventEditingChanged];
        _searchTextField.font = kFontBold18;
        _searchTextField.placeholder = LocalizedString(@"SearchPairs");
        _searchTextField.placeholderFont = kFont14;
        _searchTextField.placeholderColor = kDark50;
    }
    return _searchTextField;
}

- (XXButton *)cancelButton {
    if (_cancelButton == nil) {
        MJWeakSelf
        _cancelButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - 54, self.searchView.top + (self.searchView.height - 44)/2.0, 40, 44) block:^(UIButton *button) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
        }];
        [_cancelButton setImage:[UIImage subTextImageName:@"icon_dismiss_0"] forState:UIControlStateNormal];
    }
    return _cancelButton;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.searchView.frame), kScreen_Width, kScreen_Height - CGRectGetMaxY(self.searchView.frame)) style:UITableViewStylePlain];
        _tableView.backgroundColor = kViewBackgroundColor;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[XXMarketSearchCell class] forCellReuseIdentifier:identifier];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

/** 历史视图 */
- (XXHistoryView *)historyView {
    if (_historyView == nil) {
        _historyView = [[XXHistoryView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavHeight)];
        MJWeakSelf
        _historyView.historyBlock = ^(XXSymbolModel *model) {
        
//            NSMutableArray *symbolsArray = [NSMutableArray arrayWithArray:KUser.searchSymbolsArray];
//            [symbolsArray removeObject:model.symbolId];
//            [symbolsArray insertObject:model.symbolId atIndex:0];
//            KUser.searchSymbolsArray = symbolsArray;
            [weakSelf.navigationController popViewControllerAnimated:NO];
            if (weakSelf.searchSymbolBlock) {
                weakSelf.searchSymbolBlock(model);
            }
        };
        
        _historyView.clearBlock = ^{
            [weakSelf.tableView reloadData];
        };
    }
    return _historyView;
}

- (XXEmptyView *)sectionAlertView {
    if (_sectionAlertView == nil) {
        _sectionAlertView = [[XXEmptyView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - kNavHeight) iamgeName:kIsNight ? @"noDataTokenDark" : @"noDataToken" alert:LocalizedString(@"NoResultsMatched")];
    }
    return _sectionAlertView;
}
@end
