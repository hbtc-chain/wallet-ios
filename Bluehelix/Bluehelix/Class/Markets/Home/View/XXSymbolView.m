//
//  XXSymbolView.m
//  Bhex
//
//  Created by Bhex on 2018/10/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXSymbolView.h"
#import "XXBitcoinDetailVC.h"
#import "XXMarketSortButton.h"
#import "XXBitcoinSearchVC.h"

@interface XXSymbolView () {
    dispatch_queue_t serialQueue;
}

/** 头视图 */
@property (strong, nonatomic) UIView *headerView;

/** 成交量按钮 */
@property (strong, nonatomic) XXMarketSortButton *volumeButton;

/** 价格 */
@property (strong, nonatomic) XXMarketSortButton *priceButton;

/** 涨跌幅按钮 */
@property (strong, nonatomic) XXMarketSortButton *changeButton;

/** 区视图 */
@property (strong, nonatomic) UIView *sectionView;

/** 添加自选按钮 */
@property (strong, nonatomic) XXButton *favoriteButton;
@end

@implementation XXSymbolView

static NSString *identifier = @"XXMarketCell";

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = kViewBackgroundColor;
        serialQueue = dispatch_queue_create("com.marketView.symbol", DISPATCH_QUEUE_SERIAL);

        [self.headerView addSubview:self.volumeButton];
        [self.headerView addSubview:self.priceButton];
        [self.headerView addSubview:self.changeButton];
        [self addSubview:self.headerView];
        [self addSubview:self.tableView];
        
        [self.sectionView addSubview:self.favoriteButton];
    }
    return self;
}

#pragma mark - 1. 模型赋值
- (void)setModel:(XXQuoteTokenModel *)model {
    _model = model; 
    self.volumeButton.nameLabel.text = LocalizedString(@"24HVolume");
    self.priceButton.nameLabel.text = LocalizedString(@"LastPrice");
    self.changeButton.nameLabel.text = LocalizedString(@"24HChange");
}

#pragma mark - 2. <UITableViewDataSource, UITableViewDelegate>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.symbolsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [XXMarketCell getCellHeight];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.model.isFavorite && self.model.symbolsArray.count == 0) {
        return self.sectionView.height;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.model.isFavorite && self.model.symbolsArray.count == 0) {
        return self.sectionView;
    } else {
        return [UIView new];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XXMarketCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.model.symbolsArray[indexPath.item];
    MJWeakSelf
    cell.saveButtonBlock = ^{
        if (weakSelf.model.isFavorite) {
            [weakSelf.tableView reloadData];
        }
    };
    if (indexPath.row == self.model.symbolsArray.count - 1) {
        cell.lineView.hidden = YES;
    } else {
        cell.lineView.hidden = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row >= self.model.symbolsArray.count) {
        return;
    }
    XXSymbolModel *model = self.model.symbolsArray[indexPath.row];
    XXBitcoinDetailVC *vc = [[XXBitcoinDetailVC alloc] init];
    KDetail.symbolModel = model;
    [self.viewController.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 3.0 显示
- (void)openWebsocket {
    
    MJWeakSelf
    self.model.successBlock = ^(id data) {
        [weakSelf receiveWebsoketData:data];
    };
    
    self.model.failureBlock = ^{
        
    };
    
    [self.model openWebsocket];

}

#pragma mark - 3.1 消失
- (void)closeWebsocket {
    [self.model closeWebsocket];
}

#pragma mark - 3.0 接收到推送行情
- (void)receiveWebsoketData:(NSMutableArray *)datasArray {
    dispatch_async(serialQueue, ^{
        @synchronized(self) {
            [self integrationReceiveWebsoketData:datasArray];
        }
    });
}

#pragma mark - 3.1 处理推送过来的数据
- (void)integrationReceiveWebsoketData:(NSMutableArray *)datasArray {
    NSDictionary *quoteDict = [datasArray lastObject];
    if (quoteDict) {
        NSString *symbolId = quoteDict[@"s"];
        for (NSInteger i=0; i < self.model.symbolsArray.count; i ++) {
            XXSymbolModel *model = self.model.symbolsArray[i];
            if ([model.symbolId isEqualToString:symbolId]) {
                model.quote.time = quoteDict[@"t"];
                model.quote.close = quoteDict[@"c"];
                model.quote.high = quoteDict[@"h"];
                model.quote.low = quoteDict[@"l"];
                model.quote.open = quoteDict[@"o"];
                model.quote.volume = quoteDict[@"v"];
                [model.quote initSortData];
                model.indexCell = i;
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
                    XXMarketCell *cell = [self.tableView cellForRowAtIndexPath:path];
                    cell.model = model;
                });
                break;
            }
        }
    }
    
    if (!(self.volumeButton.status ==0 && self.priceButton.status == 0 && self.changeButton.status == 0) && self.model.symbolsArray.count) {
        [self symbolsSort];
    }
}

#pragma mark - 4.0 排序
- (void)symbolsSort {
    if (self.volumeButton.status != 0) {
        [self volumeSort];
    } else if (self.priceButton.status != 0) {
        [self priceSort];
    } else if (self.changeButton.status != 0) {
        [self changeSort];
    }
}

#pragma mark - 4.1 24小时成交量排序
- (void)volumeSort {
    if (self.volumeButton.status == 1) { // 降序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"quote.sortVolume" ascending:NO];
        [self.model.symbolsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } else if (self.volumeButton.status == 2) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"quote.sortVolume" ascending:YES];
        [self.model.symbolsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - 4.2 最新价排序
- (void)priceSort {
    if (self.priceButton.status == 1) { // 降序
       NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"quote.sortClose" ascending:NO];
       [self.model.symbolsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
       });
    } else if (self.priceButton.status == 2) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"quote.sortClose" ascending:YES];
        [self.model.symbolsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - 4.3 涨跌幅排序
- (void)changeSort {
    if (self.changeButton.status == 1) { // 降序
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"quote.sortChangedRate" ascending:NO];
       [self.model.symbolsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
       dispatch_async(dispatch_get_main_queue(), ^{
           [self.tableView reloadData];
       });
    } else if (self.changeButton.status == 2) {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"quote.sortChangedRate" ascending:YES];
        [self.model.symbolsArray sortUsingDescriptors:[NSArray arrayWithObject:sort]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

#pragma mark - 5. 添加自选按钮点击事件
- (void)addFavoriteButtonClick:(UIButton *)sender {
    XXBitcoinSearchVC *vc = [[XXBitcoinSearchVC alloc] init];
    [self.viewController.navigationController pushViewController:vc animated:YES];
    MJWeakSelf
    vc.searchSymbolBlock = ^(XXSymbolModel *model) {
        XXBitcoinDetailVC *vc = [[XXBitcoinDetailVC alloc] init];
        KDetail.symbolModel = model;
        [weakSelf.viewController.navigationController pushViewController:vc animated:YES];
    };
}

#pragma mark - || 懒加载
/** 头视图 */
- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 44)];
    }
    return _headerView;
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), self.width, self.height - CGRectGetMaxY(self.headerView.frame)) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[XXMarketCell class] forCellReuseIdentifier:identifier];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

/** 成交量按钮 */
- (XXMarketSortButton *)volumeButton {
    if (_volumeButton == nil) {
        
        CGFloat width = (kScreen_Width - KSpacing*2 - K375(40))/3;
        _volumeButton = [[XXMarketSortButton alloc] initWithFrame:CGRectMake(KSpacing, 16, width, 24)];
        _volumeButton.nameLabel.text = LocalizedString(@"24HVolume");
        _volumeButton.sortImage = [UIImage subTextImageName:@"iconSort_0"];
        _volumeButton.sortDownImage = [[UIImage imageNamed:@"iconSortDown_0"] imageWithColor:kMainTextColor];
        _volumeButton.sortUpImage = [[UIImage imageNamed:@"iconSortUp_0"] imageWithColor:kMainTextColor];
        MJWeakSelf
        _volumeButton.sortStatusBlock = ^{
            weakSelf.changeButton.status = 0;
            weakSelf.priceButton.status = 0;
            [weakSelf receiveWebsoketData:[NSMutableArray array]];
        };
    }
    return _volumeButton;
}

/** 价格 */
- (XXMarketSortButton *)priceButton {
    if (_priceButton == nil) {
        
        CGFloat width = (kScreen_Width - KSpacing*2 - K375(40))/3;
        _priceButton = [[XXMarketSortButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.volumeButton.frame) + K375(20), self.volumeButton.top, width, 24)];
        _priceButton.nameLabel.text = LocalizedString(@"LastPrice");
        _priceButton.sortImage = [UIImage subTextImageName:@"iconSort_0"];
        _priceButton.sortDownImage = [[UIImage imageNamed:@"iconSortDown_0"] imageWithColor:kMainTextColor];
        _priceButton.sortUpImage = [[UIImage imageNamed:@"iconSortUp_0"] imageWithColor:kMainTextColor];
        MJWeakSelf
        _priceButton.sortStatusBlock = ^{
            weakSelf.volumeButton.status = 0;
            weakSelf.changeButton.status = 0;
            [weakSelf receiveWebsoketData:[NSMutableArray array]];
        };
    }
    return _priceButton;
}

/** 涨跌幅按钮 */
- (XXMarketSortButton *)changeButton {
    if (_changeButton == nil) {
        
        CGFloat width = (kScreen_Width - KSpacing*2 - K375(40))/3;
        _changeButton = [[XXMarketSortButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.priceButton.frame) + K375(20), self.volumeButton.top, width, 24)];
        _changeButton.nameLabel.text = LocalizedString(@"24HChange");
        _changeButton.sortImage = [UIImage subTextImageName:@"iconSort_0"];
        _changeButton.sortDownImage = [[UIImage imageNamed:@"iconSortDown_0"] imageWithColor:kMainTextColor];
        _changeButton.sortUpImage = [[UIImage imageNamed:@"iconSortUp_0"] imageWithColor:kMainTextColor];
        MJWeakSelf
        _changeButton.sortStatusBlock = ^{
            weakSelf.volumeButton.status = 0;
            weakSelf.priceButton.status = 0;
            [weakSelf receiveWebsoketData:[NSMutableArray array]];
        };
    }
    return _changeButton;
}


/** 区视图 */
- (UIView *)sectionView {
    if (_sectionView == nil) {
        _sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, self.height - 44)];
        _sectionView.backgroundColor = [UIColor clearColor];
    }
    return _sectionView;
}

/** 添加自选按钮 */
- (XXButton *)favoriteButton {
    if (_favoriteButton == nil) {
        MJWeakSelf
        _favoriteButton = [XXButton buttonWithFrame:CGRectMake(K375(108), (self.sectionView.height - 40)/2, kScreen_Width - K375(216), 40) title:LocalizedString(@"AddFavorite") font:kFontBold12 titleColor:kMainTextColor block:^(UIButton *button) {
            [weakSelf addFavoriteButtonClick:button];
        }];
        _favoriteButton.backgroundColor = kBlue100;
        _favoriteButton.layer.cornerRadius = 3;
        _favoriteButton.layer.masksToBounds = YES;
    }
    return _favoriteButton;
}
@end


