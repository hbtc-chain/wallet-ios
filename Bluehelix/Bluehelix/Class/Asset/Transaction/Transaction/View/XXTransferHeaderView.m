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
        self.backgroundColor = kWhiteColor;
    }
    return self;
}

- (void)buildUI:(NSDictionary *)dic {
    NSArray *activities = dic[@"activities"];
    NSDictionary *activity = [activities firstObject];
    NSString *type = activity[@"type"];
    if ([type isEqualToString:kMsgWithdrawal] || [type isEqualToString:kMsgDeposit]) {
        [self buildChainType:dic];
    } else {
        [self buildDefaultType:dic];
    }
}

- (void)buildDefaultType:(NSDictionary *)dic {
    int Y = 20;
    NSArray *bottomNamesArray = @[LocalizedString(@"TXID"),LocalizedString(@"State"),LocalizedString(@"Time")];
    for (NSInteger i=0; i < bottomNamesArray.count; i ++) {
        
        XXLabel *leftLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), Y, K375(96), 20) text:bottomNamesArray[i] font:kFont13 textColor:kGray500];
        leftLabel.numberOfLines = 0;
        [self addSubview:leftLabel];
        
        XXLabel *rightLabel = [XXLabel labelWithFrame:CGRectMake(K375(120), Y, kScreen_Width - K375(120) - 48, 20) text:@"" font:kFont13 textColor:kGray900];
        rightLabel.numberOfLines = 0;
        [self addSubview:rightLabel];
        if (i == 0) {
            rightLabel.text = dic[@"hash"];
            rightLabel.userInteractionEnabled = YES;
            [rightLabel addClickCopyFunction];
            rightLabel.height = [NSString heightWithText:KString(rightLabel.text) font:kFont13 width:kScreen_Width - K375(120) - 48];
            [rightLabel addClickCopyFunction];
            Y += rightLabel.height;
            Y += 20;
            UIImageView *pasteIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 48, 32, 24, 24)];
            pasteIcon.image = [UIImage imageNamed:@"ValidatorPaste"];
            [self addSubview:pasteIcon];
        } else if (i == 1) {
            [self configStatus:dic label:rightLabel];
            Y += 40;
        } else if (i == 2) {
            rightLabel.text = [NSString dateStringFromTimestampWithTimeTamp:[dic[@"time"] longLongValue]];
        }
    }
    self.height = Y + 40;
    self.maxHeight = self.height;
}

- (void)buildChainType:(NSDictionary *)dic {
    int Y = 20;
    NSArray *bottomNamesArray = @[LocalizedString(@"TXID"),LocalizedString(@"ChainTXID"),LocalizedString(@"State"),LocalizedString(@"Time")];
    for (NSInteger i=0; i < bottomNamesArray.count; i ++) {
        
        XXLabel *leftLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), Y, K375(96), 20) text:bottomNamesArray[i] font:kFont13 textColor:kGray500];
        leftLabel.numberOfLines = 0;
        [self addSubview:leftLabel];
        
        XXLabel *rightLabel = [XXLabel labelWithFrame:CGRectMake(K375(120), Y, kScreen_Width - K375(120) - 48, 20) text:@"" font:kFont13 textColor:kGray900];
        rightLabel.numberOfLines = 0;
        [self addSubview:rightLabel];
        if (i == 0) {
            rightLabel.text = dic[@"hash"];
            rightLabel.userInteractionEnabled = YES;
            [rightLabel addClickCopyFunction];
            rightLabel.height = [NSString heightWithText:KString(rightLabel.text) font:kFont13 width:kScreen_Width - K375(120) - 48];
            [rightLabel addClickCopyFunction];
            Y += rightLabel.height;
            Y += 20;
            UIImageView *pasteIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 48, 32, 24, 24)];
            pasteIcon.image = [UIImage imageNamed:@"ValidatorPaste"];
            [self addSubview:pasteIcon];
        } else if (i == 1) {
            rightLabel.text = dic[@"ibc_tx_hash"];
            rightLabel.userInteractionEnabled = YES;
            [rightLabel addClickCopyFunction];
            rightLabel.height = [NSString heightWithText:KString(rightLabel.text) font:kFont13 width:kScreen_Width - K375(120) - 48];
            [rightLabel addClickCopyFunction];
            Y += rightLabel.height;
            Y += 20;
            UIImageView *pasteIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width - 48, Y + 12, 24, 24)];
            pasteIcon.image = [UIImage imageNamed:@"ValidatorPaste"];
            [self addSubview:pasteIcon];
        } else if (i == 2) {
            [self configStatus:dic label:rightLabel];
            Y += 40;
        } else if (i == 3) {
            rightLabel.text = [NSString dateStringFromTimestampWithTimeTamp:[dic[@"time"] longLongValue]];
        }
    }
    self.height = Y + 40;
    self.maxHeight = self.height;
}

- (void)configStatus:(NSDictionary *)dic label:(XXLabel *)label {
    NSArray *activities = dic[@"activities"];
    NSDictionary *activity = [activities firstObject];
    NSString *type = activity[@"type"];
    if ([type isEqualToString:kMsgWithdrawal] || [type isEqualToString:kMsgDeposit]) {
        NSNumber *ibc_status = dic[@"ibc_status"];
        if (ibc_status.intValue == 4) {
            label.text = LocalizedString(@"Success");
            label.textColor = KRGBA(70, 206, 95, 100);
        } else if(ibc_status.intValue == 3) {
            label.text = LocalizedString(@"Failed");
            label.textColor = kPriceFall;
        } else {
            label.text = LocalizedString(@"StatusDeal");
            label.textColor = KRGBA(252, 126, 36, 100);
        }
    } else {
        if (dic[@"success"] && ([dic[@"success"] intValue] == 1)) {
            label.text = LocalizedString(@"Success");
            label.textColor = KRGBA(70, 206, 95, 100);
        } else if(!IsEmpty(dic[@"error_message"])) {
            label.text = LocalizedString(@"Failed");
            label.textColor = kPriceFall;
        } else {
            label.text = LocalizedString(@"Failed");
            label.textColor = kPriceFall;
        }
    }
}

@end
