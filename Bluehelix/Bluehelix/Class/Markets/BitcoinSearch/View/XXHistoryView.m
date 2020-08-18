//
//  XXHistoryView.m
//  Bhex
//
//  Created by Bhex on 2018/9/10.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import "XXHistoryView.h"
#import "XXShadowView.h"

@interface XXHistoryView ()

/** 最近查看标签 */
@property (strong, nonatomic) XXLabel *historyLabel;

/** 清除按钮 */
@property (strong, nonatomic) XXButton *clearButton;

/** 历史按钮数组 */
@property (strong, nonatomic) NSMutableArray *buttonsArray;

@end

@implementation XXHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.historyLabel];
        [self addSubview:self.clearButton];
        [self getHistorySeaerchSysbolsArray];
    }
    return self;
}

#pragma mark - 1.2 获取历史记录
- (void)getHistorySeaerchSysbolsArray {
//
//    NSMutableArray *symbolsArray = [NSMutableArray arrayWithArray:KUser.searchSymbolsArray];
//    self.modelsArray = [NSMutableArray array];
//    for (NSInteger i=0; i < KMarket.keysArray.count; i ++) {
//        NSString *key = KMarket.keysArray[i];
//        if (![key isEqualToString:@"自选"]) {
//            XXQuoteTokenModel *tokenModel = KMarket.dataDict[key];
//            for (NSInteger i=0; i < tokenModel.symbolsArray.count; i ++) {
//                XXSymbolModel *model = tokenModel.symbolsArray[i];
//                for (NSInteger h=0; h < symbolsArray.count; h ++) {
//                    if ([model.symbolId isEqualToString:symbolsArray[h]]) {
//                        [self.modelsArray addObject:model];
//                        break;
//                    }
//                }
//            }
//        }
//    }
//
//    self.buttonsArray = [NSMutableArray array];
//    MJWeakSelf
//    CGFloat width = (kScreen_Width - KSpacing*2 - 15*2) / 3;
//    for (NSInteger i=0; i < self.modelsArray.count; i ++) {
//        XXShadowView *shadowView = [[XXShadowView alloc] initWithFrame:CGRectMake(KSpacing + (width + 15)*(i%3), 50 + (i/3)*(K375(31) + K375(16)), width, K375(31))];
//        [self addSubview:shadowView];
//
//        XXSymbolModel *model = self.modelsArray[i];
//        XXButton *itemButton = [XXButton buttonWithFrame:shadowView.frame title:[NSString stringWithFormat:@"%@ / %@", model.baseTokenName, model.quoteTokenName] font:kFontBold14 titleColor:kDark100 block:^(UIButton *button) {
//            if (weakSelf.historyBlock) {
//                weakSelf.historyBlock(weakSelf.modelsArray[button.tag]);
//            }
//        }];
//        itemButton.tag = i;
//        [self addSubview:itemButton];
//        [self.buttonsArray addObject:itemButton];
//        self.height = CGRectGetMaxY(itemButton.frame) + K375(16);
//    }
}

#pragma mark - || 懒加载
- (XXLabel *)historyLabel {
    if (_historyLabel == nil) {
        _historyLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 0, K375(200), 50) text:LocalizedString(@"RecentView") font:kFont14 textColor:kDark50];
    }
    return _historyLabel;
}

- (XXButton *)clearButton {
    if (_clearButton == nil) {
        MJWeakSelf
        CGFloat btnWidth = [NSString widthWithText:LocalizedString(@"ClearRecord") font:kFontBold16] + KSpacing * 2;
        _clearButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - btnWidth, 0, btnWidth, 50) title:LocalizedString(@"ClearRecord") font:kFont14 titleColor:kDark100 block:^(UIButton *button) {
            [weakSelf.modelsArray removeAllObjects];
//            KUser.searchSymbolsArray = [NSMutableArray array];
            if (weakSelf.clearBlock) {
                weakSelf.clearBlock();
            }
        }];
    }
    return _clearButton;
}

@end
