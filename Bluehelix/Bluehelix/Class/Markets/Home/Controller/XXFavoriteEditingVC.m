//
//  XXFavoriteEditingVC.m
//  Bhex
//
//  Created by YiHeng on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXFavoriteEditingVC.h"
#import "XXFavoriteEditingCell.h"
#import "XXBitcoinSearchVC.h"
#import "XXBitcoinDetailVC.h"

@interface XXFavoriteEditingVC () <UITableViewDelegate, UITableViewDataSource, XXFavoriteEditingCellDelegate>

@property (strong, nonatomic, nullable) NSString *showString;
@property (strong, nonatomic, nullable) NSString *doneString;

@property (strong, nonatomic, nullable) NSMutableArray *dataArray;
@property (strong, nonatomic, nullable) UITableView *tableView;
@property (strong, nonatomic, nullable) UIView *lowView;
@property (strong, nonatomic, nullable) XXButton *selectButton;
@property (strong, nonatomic, nullable) XXButton *deleteButton;

@end

@implementation XXFavoriteEditingVC
static NSString *identifirid = @"XXFavoriteEditingCell";

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadCurrentPageData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self setupUI];
    
    // 币对列表需要更新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:SymbolList_NeedUpdate_NotificationName object:nil];
}

#pragma mark - 1. 初始化数据
- (void)initData {
    NSArray *keysArray = [KMarket.symbolsDict allKeys];
    for (NSString *symbolId in keysArray) {
        XXSymbolModel *model = KMarket.symbolsDict[symbolId];
        model.isSelect = NO;
    }
}

#pragma mark - 2. 初始化UI
- (void)setupUI {
    
    self.titleLabel.text = LocalizedString(@"FavoriteEditing");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.leftButton setImage:nil forState:UIControlStateNormal];
    [self.leftButton setTitle:LocalizedString(@"Add") forState:UIControlStateNormal];
    [self.leftButton setTitleColor:kDark100 forState:UIControlStateNormal];
    self.leftButton.titleLabel.font = kFontBold16;
    [self.rightButton setTitle:LocalizedString(@"Done") forState:UIControlStateNormal];
    [self.rightButton setTitleColor:kBlue100 forState:UIControlStateNormal];
    self.rightButton.titleLabel.font = kFontBold16;
    self.navLineView.hidden = NO;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.lowView];
    [self.lowView addSubview:self.selectButton];
    [self.lowView addSubview:self.deleteButton];
}

#pragma mark - 3. 左侧按钮点击事件
- (void)leftButtonClick:(UIButton *)sender {
    XXBitcoinSearchVC *vc = [[XXBitcoinSearchVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    MJWeakSelf
    vc.searchSymbolBlock = ^(XXSymbolModel *model) {
        XXBitcoinDetailVC *vc = [[XXBitcoinDetailVC alloc] init];
        KDetail.symbolModel = model;
        [weakSelf.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - 4. 右侧按钮点击事件
- (void)rightButtonClick:(UIButton *)sender {
    
    NSMutableArray *dismissArray = [NSMutableArray array];
    for (NSInteger i=0; i < self.dataArray.count; i ++) {
        XXSymbolModel *model = self.dataArray[i];
        [dismissArray addObject:KString(model.symbolId)];
    }
    self.doneString = [dismissArray mj_JSONString];
    if ([self.showString isEqualToString:self.doneString]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    NSMutableArray *parmasArray = [NSMutableArray array];
    NSMutableArray *symbolsArray = [NSMutableArray array];
    for (NSInteger i=0; i < self.dataArray.count; i ++) {
        XXSymbolModel *model = self.dataArray[i];
        [parmasArray addObject:@{@"exchangeId":KString(model.exchangeId), @"symbolId":model.symbolId}];
        [symbolsArray addObject:model.symbolId];
    }
    
//    if (KUser.isLogin) {
//        [MBProgressHUD showActivityMessageInView:@""];
//        MJWeakSelf
//        [HttpManager postWithPath:@"user/favorite/sort" params:@{@"items":[parmasArray mj_JSONString]} andBlock:^(id data, NSString *msg, NSInteger code) {
//            [MBProgressHUD hideHUD];
//            if (code == 0) {
//                [KMarket reloadFavoriteSymbol:symbolsArray];
//                [weakSelf.navigationController popViewControllerAnimated:YES];
//            } else {
//                [MBProgressHUD showErrorMessage:msg];
//            }
//        }];
//    } else {
//        [KMarket reloadFavoriteSymbol:symbolsArray];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
}

#pragma mark - 5.1 <UITableViewDelegate, UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXFavoriteEditingCell *cell = [tableView dequeueReusableCellWithIdentifier:identifirid];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    cell.indexPath = indexPath;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - 5.2 拖拽排序
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath {

    if (sourceIndexPath.row < self.dataArray.count && destinationIndexPath.row < self.dataArray.count) {
        id obj = self.dataArray[sourceIndexPath.row];
        [self.dataArray removeObject:obj];
        [self.dataArray insertObject:obj atIndex:destinationIndexPath.row];
    }
    [self.tableView reloadData];
}

#pragma mark - 5. 【XXFavoriteEditingCellDelegate】选中
- (void)favoriteEditingCellDidSelectAtIndexPath:(NSIndexPath *)indexPath {
    XXSymbolModel *symbolModel = self.dataArray[indexPath.row];
    symbolModel.isSelect = !symbolModel.isSelect;
    [self reloadFavoriteData];
}

#pragma mark - 6. 【XXFavoriteEditingCellDelegate】置顶
- (void)favoriteEditingCellDidTopAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < self.dataArray.count) {
        XXSymbolModel *model = self.dataArray[indexPath.row];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.dataArray insertObject:model atIndex:0];
    }
    [self.tableView reloadData];
}

#pragma mark - 7. 刷新数据
- (void)reloadCurrentPageData {
    XXQuoteTokenModel *quoteModel = KMarket.dataDict[@"自选"];
    self.dataArray = [NSMutableArray arrayWithArray:quoteModel.symbolsArray];
    
    NSMutableArray *showsArray = [NSMutableArray array];
    for (NSInteger i=0; i < self.dataArray.count; i ++) {
        XXSymbolModel *model = self.dataArray[i];
        [showsArray addObject:KString(model.symbolId)];
    }
    self.showString = [showsArray mj_JSONString];
    [self.tableView reloadData];
}

#pragma mark - 8. 全选按钮点击事件
- (void)selectAllButtonClick:(UIButton *)sender {
    self.selectButton.selected = !self.selectButton.selected;
    for (XXSymbolModel *model in self.dataArray) {
        model.isSelect = self.selectButton.selected;
    }
    [self reloadFavoriteData];
}

#pragma mark - 9.1 删除按钮点击事件
- (void)deleteButtonClick:(UIButton *)sender {
    
//    if (!KUser.isLogin) {
//        [self deleteFavoriteSymbol];
//        return;
//    }
//    NSMutableArray *parmasArray = [NSMutableArray array];
//    for (NSInteger i=0; i < self.dataArray.count; i ++) {
//        XXSymbolModel *model = self.dataArray[i];
//        if (model.isSelect == NO) {
//            [parmasArray addObject:@{@"exchangeId":KString(model.exchangeId), @"symbolId":model.symbolId}];
//        }
//    }
//    [MBProgressHUD showActivityMessageInView:@""];
//    MJWeakSelf
//    [HttpManager postWithPath:@"user/favorite/sort" params:@{@"items":[parmasArray mj_JSONString]} andBlock:^(id data, NSString *msg, NSInteger code) {
//        [MBProgressHUD hideHUD];
//        if (code == 0) {
//            [weakSelf deleteFavoriteSymbol];
//        } else {
//            [MBProgressHUD showErrorMessage:msg];
//        }
//    }];
}

#pragma mark - 9.2 删除同步到缓存
- (void)deleteFavoriteSymbol {
    for (NSInteger i=0; i < self.dataArray.count; i ++) {
        XXSymbolModel *model = self.dataArray[i];
        if (model.isSelect) {
            model.isSelect = NO;
            [KMarket cancelFavoriteSymbolId:model.symbolId];
        }
    }
    [self reloadCurrentPageData];
    [self reloadFavoriteData];
}

#pragma mark - 10. 刷新自选数据
- (void)reloadFavoriteData {
    NSInteger count = 0;
    for (XXSymbolModel *model in self.dataArray) {
        if (model.isSelect) {
            count ++;
        }
    }
    if (count > 0) {
        self.deleteButton.enabled = YES;
    } else {
        self.deleteButton.enabled = NO;
    }
    [self.deleteButton setTitle:NSLocalizedFormatString(LocalizedString(@"DeleteAndAmount"), count) forState:UIControlStateNormal];
    
    if (self.dataArray.count == count) {
        self.selectButton.selected = YES;
    } else {
        self.selectButton.selected = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark - || 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kNavHeight, kScreen_Width, kScreen_Height - kNavHeight - kTabbarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.editing = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[XXFavoriteEditingCell class] forCellReuseIdentifier:identifirid];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}


- (UIView *)lowView {
    if (_lowView == nil) {
        _lowView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height - kTabbarHeight, kScreen_Width, kTabbarHeight)];
        _lowView.backgroundColor = kWhite100;
        _lowView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        _lowView.layer.shadowRadius = 10.0;
        _lowView.layer.shadowOpacity = 1;
        _lowView.layer.shadowColor = (KBigLine_Color).CGColor;
        
    }
    return _lowView;
}

- (XXButton *)selectButton {
    if (_selectButton == nil) {
        MJWeakSelf
        _selectButton = [XXButton buttonWithFrame:CGRectMake(KSpacing, 0, K375(100), 49) title:[NSString stringWithFormat:@"  %@", LocalizedString(@"SelectAll")] font:kFontBold14 titleColor:kDark100 block:^(UIButton *button) {
            [weakSelf selectAllButtonClick:button];
        }];
        [_selectButton setImage:[UIImage subTextImageName:@"uncheck"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage mainImageName:@"checked"] forState:UIControlStateSelected];
        _selectButton.selected = NO;
        _selectButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    }
    return _selectButton;
}

- (XXButton *)deleteButton {
    if (_deleteButton == nil) {
        MJWeakSelf
        _deleteButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - K375(130) - KSpacing, self.selectButton.top, K375(130), self.selectButton.height) title:NSLocalizedFormatString(LocalizedString(@"DeleteAndAmount"), 0) font:kFontBold14 titleColor:kBlue100 block:^(UIButton *button) {
            [weakSelf deleteButtonClick:button];
        }];
        [_deleteButton setTitleColor:kDark50 forState:UIControlStateDisabled];
        _deleteButton.backgroundColor = kWhite100;
        _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _deleteButton.enabled = NO;
    }
    return _deleteButton;
}

@end
