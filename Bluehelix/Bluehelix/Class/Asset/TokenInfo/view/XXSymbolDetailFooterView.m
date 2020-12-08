//
//  XXSymbolDetailFooterView.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXSymbolDetailFooterView.h"
#import "XXTokenModel.h"

@implementation XXSymbolDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setTokenModel:(XXTokenModel *)tokenModel {
    _tokenModel = tokenModel;
    [self buildUI];
}

- (void)buildUI {
    NSArray *titleArr;
        if (self.tokenModel.is_native) {
            if ([[XXSqliteManager sharedSqlite] existMapModel:self.tokenModel.symbol]) {
                titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"Transfer"),LocalizedString(@"Exchange"),LocalizedString(@"TradesTabbar")];
            } else {
                titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"Transfer"),LocalizedString(@"TradesTabbar")];
            }
        } else {
            if ([[XXSqliteManager sharedSqlite] existMapModel:self.tokenModel.symbol]) {
                titleArr = @[LocalizedString(@"Recharge"),LocalizedString(@"Withdraw"),LocalizedString(@"Exchange"),LocalizedString(@"TradesTabbar")];
            } else {
                titleArr = @[LocalizedString(@"Recharge"),LocalizedString(@"Withdraw"),LocalizedString(@"TradesTabbar")];
            }
        }
    CGFloat btnWidth = (kScreen_Width - K375(11) - titleArr.count*4)/titleArr.count;
    for (NSInteger i=0; i < titleArr.count; i ++) {
        MJWeakSelf
        XXButton *itemButton = [XXButton buttonWithFrame:CGRectMake(K375(5.5) + (btnWidth+4)*i, 16, btnWidth, 40) block:^(UIButton *button) {
            [weakSelf buttonClick:button];
        }];
        itemButton.tag = 100 + i;
        if (i < 2) {
            itemButton.backgroundColor = kPrimaryMain;
            [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            itemButton.backgroundColor = [UIColor whiteColor];
            [itemButton setTitleColor:kPrimaryMain forState:UIControlStateNormal];
            itemButton.layer.borderColor = [kPrimaryMain CGColor];
            itemButton.layer.borderWidth = 1;
        }
        [itemButton.titleLabel setFont:kFont14];
        [itemButton setTitle:titleArr[i] forState:UIControlStateNormal];
        itemButton.layer.cornerRadius = 4;
        [self addSubview:itemButton];
    }
}

- (void)buttonClick:(UIButton *)sender {
    self.actionBlock(sender.tag - 100);
}

@end
