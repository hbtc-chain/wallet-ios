//
//  XXDepthView.m
//  Bhex
//
//  Created by BHEX on 2018/7/16.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXDepthView.h"
#import "XXTradeDepthCell.h"
#import "YBPopupMenu.h"
#import "XXDepthTool.h"
#import "XXPickerView.h"
#import "XXBitcoinDetailVC.h"
#import "XXOrderModel.h"

@interface XXDepthView () <YBPopupMenuDelegate>

/** 单元格数组 */
@property (strong, nonatomic) NSMutableArray *cellsArray;

/** 盘口平均值 */
@property (assign, nonatomic) double ordersAverage;

/** 盘口单挡最大值 */
@property (assign, nonatomic) double maxAmount;

/** 卖家挂单数组 */
@property (strong, nonatomic) NSMutableArray *rightModelsArray;

/** 买家挂单数组 */
@property (strong, nonatomic) NSMutableArray *leftModelsArray;

/** 位数按钮 */
@property (strong, nonatomic, nullable) XXButton *numberButton;

/** 方式按钮 */
@property (strong, nonatomic, nullable) XXButton *typeButton;

@end

@implementation XXDepthView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        [self addSubview:self.priceLabel];
        [self addSubview:self.amountButton];
        [self addSubview:self.numberLabel];
        [self addSubview:self.tableView];
        [self addSubview:self.typeButton];
        [self addSubview:self.numberButton];
        self.orderIndex = 0;
        self.numberIndex = 0;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }
    return self;
}

#pragma mark - 1. <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXTradeDepthCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.closeLabel.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 0) {
        return self.closeLabel;
    }
    return [UIView new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXTradeDepthCell *cell = self.cellsArray[indexPath.section*10 + indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XXTradeDepthCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    XXDepthModel *model = cell.model;
    if (self.depthPriceBlcok && [model.price doubleValue] > 0) {
        self.depthPriceBlcok(model.price, model.sumNumber, model.isBuy);
    }
}

#pragma mark - 2. 更新盘口UI
- (void)reloadDepthListData:(NSDictionary *)listData {

    // 计算平均值
    self.ordersAverage = [listData[@"o"] doubleValue];
    self.maxAmount = [listData[@"h"] doubleValue];
    self.leftModelsArray = listData[@"b"];
    self.rightModelsArray = listData[@"a"];

    NSInteger indexType = 0;
    if (KTrade.currentModel.type == SymbolTypeCoin) {
        indexType = KTrade.coinDepthAmount;
    }
    
    // 个cell赋值
    for (NSInteger i=0; i < self.cellsArray.count; i ++) {
        XXTradeDepthCell *cell = self.cellsArray[i];
        cell.amounntIndex = indexType;
        if (i < 10) {
            if (self.rightModelsArray.count > 9 - i) {
                cell.ordersAverage = self.ordersAverage;
                cell.maxAmount = self.maxAmount;
                cell.model = self.rightModelsArray[9 - i];
                cell.model.isHavePoint = [self isHavePointWithDepthModel:cell.model];
                [cell reloadData];
            } else {
                cell.ordersAverage = 0;
                cell.maxAmount = 0;
                XXDepthModel *model = [XXDepthModel new];
                model.isBuy = NO;
                model.price = @"--";
                model.number = @"--";
                cell.model = model;
                [cell reloadData];
            }
        } else {
            if (i-10 < self.leftModelsArray.count) {
                cell.ordersAverage = self.ordersAverage;
                cell.maxAmount = self.maxAmount;
                cell.model = self.leftModelsArray[i-10];
                cell.model.isHavePoint = [self isHavePointWithDepthModel:cell.model];
                [cell reloadData];
            } else {
                cell.ordersAverage = 0;
                cell.maxAmount = 0;
                XXDepthModel *model = [XXDepthModel new];
                model.isBuy = YES;
                model.price = @"--";
                model.number = @"--";
                cell.model = model;
                [cell reloadData];
            }
        }
    }
}

#pragma mark - 3. 是否存在点【当前委托单】
- (BOOL)isHavePointWithDepthModel:(XXDepthModel *)depthModel {
    
    NSMutableArray *ordersArray = self.ordersArray;
    if (ordersArray.count > 0) {
        for (NSInteger i=0; i < ordersArray.count; i ++) {
            
            if (KTrade.currentModel.type == SymbolTypeCoin || KTrade.currentModel.type == SymbolTypeCoinMargin) {
                XXOrderModel *orderModel = ordersArray[i];
                if (depthModel.isBuy) {
                    
                    NSString *orderPrice = [KDecimal decimalNumber:orderModel.price RoundingMode:NSRoundDown scale:KTrade.priceDigit];
                    /** BUY 买  SELL  卖 */
                    if ([orderModel.side isEqualToString:@"BUY"] && [orderModel.type isEqualToString:@"LIMIT"] && [orderPrice isEqualToString:depthModel.price]) {
                        return YES;
                    }
                    
                } else {
                    NSString *orderPrice = [KDecimal decimalNumber:orderModel.price RoundingMode:NSRoundUp scale:KTrade.priceDigit];
                    /** BUY 买  SELL  卖 */
                    if ([orderModel.side isEqualToString:@"SELL"] && [orderModel.type isEqualToString:@"LIMIT"] && [orderPrice isEqualToString:depthModel.price]) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

#pragma mark - 4. 订单类型按钮点击事件
- (void)orderTypeButtonClick:(UIButton *)sender {
    MJWeakSelf
//    [XYHPickerView showPickerViewWithNamesArray:@[LocalizedString(@"Default"), LocalizedString(@"BuyOrder"), LocalizedString(@"SellOrder")] selectIndex:self.orderIndex Block:^(NSString *title, NSInteger index) {
//        weakSelf.orderIndex = index;
//        if (index == 0) {
//            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        } else if (index == 1) {
//            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        } else {
//            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        }
//    }];
}

#pragma mark - 5. 位数按钮点击事件
- (void)numberButtonClick:(UIButton *)sender {

    MJWeakSelf
//    [XYHPickerView showPickerViewWithNamesArray:self.itemsArray selectIndex:self.numberIndex Block:^(NSString *title, NSInteger index) {
//        if (weakSelf.numberIndex != index) {
//            weakSelf.numberIndex = index;
//            [weakSelf reloadNumberButtonTitle];
//            if (weakSelf.depthActionBlcok) {
//                weakSelf.depthActionBlcok();
//            }
//        }
//    }];
}

#pragma mark - 6. 刷新位数标题
- (void)reloadNumberButtonTitle {
    
    [self.numberButton setTitle:self.itemsArray[self.numberIndex] forState:UIControlStateNormal];
    [self.numberButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - self.numberButton.imageView.image.size.width, 0, self.numberButton.imageView.image.size.width)];
    [self.numberButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.numberButton.titleLabel.bounds.size.width + 5, 0, -self.numberButton.titleLabel.bounds.size.width - 5)];
    self.numberButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
}

#pragma mark - 6. 按钮点击事件
- (void)amountButtonClick:(UIButton *)sender {
   
    NSArray *titleArr = @[
        [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Amount"), KTrade.currentModel.baseTokenName],
        [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Cumulative"), KTrade.currentModel.baseTokenName]];
    
    if (KTrade.currentModel.type == SymbolTypeOption) {
        titleArr = @[
            [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Amount"), LocalizedString(@"Paper")],
            [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Cumulative"), LocalizedString(@"Paper")]
        ];
    }
    CGFloat itemWith = 0;
    UIFont *font = kFont14;
    for (NSInteger i=0; i < titleArr.count; i ++) {
        NSString *itemString = titleArr[i];
        CGFloat width = [NSString widthWithText:itemString font:font] + 80;
        if (itemWith < width) {
            itemWith = width;
        }
    }
    CGRect rect = [self convertRect:self.amountButton.frame toView:KWindow];
    CGPoint point = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height - 5);
    MJWeakSelf
    [YBPopupMenu showAtPoint:point titles:titleArr icons:nil menuWidth:itemWith otherSettings:^(YBPopupMenu *popupMenu) {
        popupMenu.delegate = weakSelf;
        popupMenu.borderColor = KLine_Color;
        popupMenu.borderWidth = 1;
        popupMenu.textColor = kDark100;
        popupMenu.backColor = kWhite100;
        if (KTrade.currentModel.type == SymbolTypeCoin) {
            popupMenu.indexSelectedCell = KTrade.coinDepthAmount;
        }
    }];
}

#pragma mark - 3.1 <YBPopupMenuDelegate>
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    if (KTrade.currentModel.type == SymbolTypeCoin && KTrade.coinDepthAmount != index) {
        KTrade.coinDepthAmount = index;
    } else {
        return;
    }
    
    NSArray *titleArr = @[
        [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Amount"), KTrade.currentModel.baseTokenName],
        [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Cumulative"), KTrade.currentModel.baseTokenName]];
    
    if (KTrade.currentModel.type == SymbolTypeOption) {
        titleArr = @[
            [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Amount"), LocalizedString(@"Paper")],
            [NSString stringWithFormat:@"%@(%@)",LocalizedString(@"Cumulative"), LocalizedString(@"Paper")]
        ];
    }
    self.numberLabel.text = titleArr[index];
    
    // 个cell赋值
    for (NSInteger i=0; i < self.cellsArray.count; i ++) {
        XXTradeDepthCell *cell = self.cellsArray[i];
        cell.amounntIndex = index;
        [cell reloadData];
    }
}

#pragma mark - || 懒加载
/** 价格标签 */
- (XXLabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [XXLabel labelWithFrame:CGRectMake(0, 9, (self.width - KSpacing)/2.0, 16) font:kFont10 textColor:kDark50];
    }
    return _priceLabel;
}

- (XXButton *)amountButton {
    if (_amountButton == nil) {
        MJWeakSelf
        _amountButton = [XXButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame), self.priceLabel.top - 8, self.priceLabel.width, self.priceLabel.height + 16) block:^(UIButton *button) {
            [weakSelf amountButtonClick:button];
        }];
        [_amountButton setImage:[UIImage subTextImageName:@"arrowdown_trade"] forState:UIControlStateNormal];
        _amountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    }
    return _amountButton;
}

/** 数量标签 arrowdown_trade */
- (XXLabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.priceLabel.frame) - 8, self.priceLabel.top, self.priceLabel.width - 8, self.priceLabel.height) font:kFont10 textColor:kDark50];
        _numberLabel.textAlignment = NSTextAlignmentRight;
        _numberLabel.userInteractionEnabled = NO;
    }
    return _numberLabel;
}

/** 最新价标签 */
- (XXLabel *)closeLabel {
    if (_closeLabel == nil) {
        _closeLabel = [XXLabel labelWithFrame:CGRectMake(0, 0, self.width - KSpacing, 50) font:kFontBold18 textColor:kGreen100];
        _closeLabel.backgroundColor = kViewBackgroundColor;
        _closeLabel.numberOfLines = 0;
        MJWeakSelf
        [_closeLabel whenTapped:^{
            if (weakSelf.depthPriceBlcok) {
                weakSelf.depthPriceBlcok(weakSelf.tickerModel.c, 0, NO);
            }
        }];
    }
    return _closeLabel;
}

/** 表示图 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.priceLabel.frame) + 8, self.width, [XXTradeDepthCell getCellHeight] * 12 + 50) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

/** 方式按钮 */
- (XXButton *)typeButton {
    if (_typeButton == nil) {
        MJWeakSelf
        CGFloat btnWidth = KSpacing * 2 + 16;
        _typeButton = [XXButton buttonWithFrame:CGRectMake(self.width - btnWidth, CGRectGetMaxY(self.tableView.frame), btnWidth, 32) block:^(UIButton *button) {
            [weakSelf orderTypeButtonClick:button];
        }];
        [_typeButton setImage:[UIImage imageNamed:@"order_type"] forState:UIControlStateNormal];
        
    }
    return _typeButton;
}

/** 位数按钮 */
- (XXButton *)numberButton {
    if (_numberButton == nil) {
        MJWeakSelf
        _numberButton = [XXButton buttonWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), self.typeButton.left, self.typeButton.height) title:@"" font:kFont12 titleColor:kDark50 block:^(UIButton *button) {
            [weakSelf numberButtonClick:button];
        }];
        [_numberButton setImage:[UIImage subTextImageName:@"arrowdown_trade"] forState:UIControlStateNormal];
    }
    return _numberButton;
}

- (NSMutableArray *)cellsArray {
    if (_cellsArray == nil) {
        _cellsArray = [NSMutableArray array];
        for (NSInteger i=0; i < 20; i ++) {
            XXTradeDepthCell *cell = [[XXTradeDepthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            [_cellsArray addObject:cell];
        }
    }
    return _cellsArray;
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];

    NSLog(@"交易深度释放了！");
}


@end
