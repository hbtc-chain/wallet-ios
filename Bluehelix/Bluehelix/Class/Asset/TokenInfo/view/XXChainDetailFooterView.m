//
//  XXChainDetailFooterView.m
//  Bluehelix
//
//  Created by 袁振 on 2020/12/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXChainDetailFooterView.h"

@implementation XXChainDetailFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)setChain:(NSString *)chain {
    _chain = chain;
    [self buildUI];
}

- (void)buildUI {
    NSArray *titleArr;
    if ([self.chain isEqualToString:kMainToken]) {
        titleArr = @[LocalizedString(@"ReceiveMoney"),LocalizedString(@"Transfer"),LocalizedString(@"TradesTabbar")];
    } else {
//        if ([[XXSqliteManager sharedSqlite] existMapModel:self.chain]) {
            titleArr = @[LocalizedString(@"ChainReceiveMoney"),LocalizedString(@"ChainPayMoney"),LocalizedString(@"TradesTabbar"),LocalizedString(@"Exchange")];
//        }
//        else {
//            titleArr = @[LocalizedString(@"ChainReceiveMoney"),LocalizedString(@"ChainPayMoney"),LocalizedString(@"TradesTabbar")];
//        }
    }
    CGFloat btnWidth;
    if (titleArr.count == 4) {
       btnWidth = (kScreen_Width - K375(11) - titleArr.count*4)/10*3;
    } else {
       btnWidth = (kScreen_Width - K375(11) - titleArr.count*4)/titleArr.count;
    }
    for (NSInteger i=0; i < titleArr.count; i ++) {
        XXButton *itemButton;
        MJWeakSelf
        if (titleArr.count == 4 && i > 1) {
           CGFloat newBtnWidth = (kScreen_Width - K375(11) - titleArr.count*4)/10*2;
            itemButton = [XXButton buttonWithFrame:CGRectMake(K375(5.5) + (btnWidth+4)*2 + (newBtnWidth+4)*(i - 2), 16, newBtnWidth, 40) block:^(UIButton *button) {
                [weakSelf buttonClick:button];
            }];
        } else {
            itemButton = [XXButton buttonWithFrame:CGRectMake(K375(5.5) + (btnWidth+4)*i, 16, btnWidth, 40) block:^(UIButton *button) {
                [weakSelf buttonClick:button];
            }];
        }
        itemButton.tag = 100 + i;
        if (i < 2) {
            itemButton.backgroundColor = kPrimaryMain;
            [itemButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        } else {
            itemButton.backgroundColor = kWhiteColor;
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
