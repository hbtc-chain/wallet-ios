//
//  XXTransferHeaderView.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXTransferHeaderView.h"
#import "XXTransactionModel.h"

@implementation XXTransferHeaderView

- (instancetype)initWithFrame:(CGRect)frame data:(NSDictionary *)dic {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = kWhite100;
        [self buildUI:dic];
    }
    return self;
}

- (void)buildUI:(NSDictionary *)dic {
//    NSDictionary *activity = [dic[@"activities"] firstObject];
//    XXTransactionModel *model = [[XXTransactionModel alloc] initwithActivity:activity];

    NSInteger state = 0;
    if (dic[@"success"] && ([dic[@"success"] intValue] == 1)) {
        state = 1;
    } else if(!IsEmpty(dic[@"error_message"])) {
        state = 0;
    }
    int Y = 20;
    NSArray *bottomNamesArray = @[LocalizedString(@"TXID"),LocalizedString(@"状态"),LocalizedString(@"时间")];
    for (NSInteger i=0; i < bottomNamesArray.count; i ++) {
        
        XXLabel *leftLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), Y, K375(120), 20) text:bottomNamesArray[i] font:kFont14 textColor:kDark50];
        leftLabel.numberOfLines = 0;
        [self addSubview:leftLabel];
        
        XXLabel *rightLabel = [XXLabel labelWithFrame:CGRectMake(K375(151), Y, K375(200), 20) text:@"" font:kFont14 textColor:kDark100];
        rightLabel.numberOfLines = 0;
        [self addSubview:rightLabel];
        if (i == 0) {
            rightLabel.text = dic[@"hash"];
            rightLabel.userInteractionEnabled = YES;
            [rightLabel addClickCopyFunction];
            rightLabel.height = [NSString heightWithText:KString(rightLabel.text) font:kFont14 width:K375(200)];
            Y += rightLabel.height;
            Y += 20;
        } else if (i == 1) {
            rightLabel.text = state == 1 ? LocalizedString(@"成功"):LocalizedString(@"失败");
            Y += 40;
        } else if (i == 2) {
            rightLabel.text = [NSString dateStringFromTimestampWithTimeTamp:[dic[@"time"] longLongValue]];
        }
    }
}

@end
