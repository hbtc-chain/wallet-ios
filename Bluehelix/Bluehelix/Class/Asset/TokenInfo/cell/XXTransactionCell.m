//
//  XXTransactionCell.m
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//
#import "XXTransactionCell.h"
#import "XXTransactionModel.h"
#import "XXMsgSendModel.h"
#import "XXMsgDepositModel.h"
#import "XXMsgWithdrawalModel.h"
#import "XXMsgKeyGenModel.h"
#import "XXTokenModel.h"
#import "XXMsgDelegateModel.h"
#import "XXCoinModel.h"
@interface XXTransactionCell ()

@property (nonatomic, strong) XXLabel *typeLabel;
@property (nonatomic, strong) XXLabel *timeLabel;
@property (nonatomic, strong) XXLabel *amountLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXLabel *stateLabel;

@end

@implementation XXTransactionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = kViewBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.stateLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)configData:(NSDictionary *)dic symbol:(NSString *)symbol {
    self.amountLabel.text = @"";
    self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:[dic[@"time"] longLongValue]];
    NSArray *activities = dic[@"activities"];
    NSDictionary *activity = [activities firstObject];
    NSString *countString = @"";
    if (activities.count > 1) {
        countString = [NSString stringWithFormat:@"+%lu",activities.count -1];
    }
    NSString *type = activity[@"type"];
    self.typeLabel.text = [NSString stringWithFormat:@"%@%@",[[XXSqliteManager sharedSqlite] signType:type],countString];
    self.typeLabel.frame = CGRectMake(K375(24), 20, [NSString widthWithText:self.typeLabel.text font:kFontBold(17)], 24);
    NSArray *balance_flows = dic[@"balance_flows"];
    if (balance_flows && balance_flows.count > 0) {
        for (NSDictionary *b in balance_flows) {
            if ([b[@"address"] isEqualToString:KUser.address] && [b[@"symbol"] isEqualToString:symbol]) {
                self.amountLabel.text = [NSString stringWithFormat:@"%@ %@",kAmountShortTrim(b[@"amount"]),[b[@"symbol"] uppercaseString]];
            }
        }
    }
    if ([type isEqualToString:kMsgWithdrawal] || [type isEqualToString:kMsgDeposit]) {
        NSNumber *ibc_status = dic[@"ibc_status"];
        if (ibc_status.intValue == 4) {
            self.stateLabel.text = LocalizedString(@"Success");
            self.stateLabel.textColor = kGreen100;
            self.stateLabel.backgroundColor = [kGreen100 colorWithAlphaComponent:0.2];
            self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"Success") font:kFont10] + 8, 16);
        } else if(ibc_status.intValue == 3) {
            self.stateLabel.text = LocalizedString(@"Failed");
            self.stateLabel.textColor = kRed100;
            self.stateLabel.backgroundColor = [kRed100 colorWithAlphaComponent:0.2];
            self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"Failed") font:kFont10] + 8, 16);
        } else {
            self.stateLabel.text = LocalizedString(@"StatusDeal");
            self.stateLabel.textColor = KRGBA(252, 126, 36, 100);;
            self.stateLabel.backgroundColor = KRGBA(254, 228, 203, 100);
            self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"StatusDeal") font:kFont10] + 8, 16);
        }
    } else {
        if ([dic[@"success"] intValue]) {
            self.stateLabel.text = LocalizedString(@"Success");
            self.stateLabel.textColor = kGreen100;
            self.stateLabel.backgroundColor = [kGreen100 colorWithAlphaComponent:0.2];
            self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"Success") font:kFont10] + 8, 16);
        } else {
            self.stateLabel.text = LocalizedString(@"Failed");
            self.stateLabel.textColor = kRed100;
            self.stateLabel.backgroundColor = [kRed100 colorWithAlphaComponent:0.2];
            self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"Failed") font:kFont10] + 8, 16);
        }
    }
}

- (XXLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), 20, 0, 24) text:@"" font:kFontBold(17) textColor:kGray900];
    }
    return _typeLabel;
}

- (XXLabel *)stateLabel {
    if (_stateLabel == nil) {
        _stateLabel = [[XXLabel alloc] init];
        _stateLabel.font = kFont(10);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        _stateLabel.layer.cornerRadius = 2;
        _stateLabel.layer.masksToBounds = YES;
    }
    return _stateLabel;
}

- (XXLabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.typeLabel.frame), kScreen_Width - K375(48), 16) font:kFont(13) textColor:kGray500];
    }
    return _timeLabel;
}

- (XXLabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame), 20, kScreen_Width - 16 - CGRectGetMaxX(self.typeLabel.frame), 24) font:kNumberFontBold(17) textColor:kGray900];
        _amountLabel.textAlignment = NSTextAlignmentRight;
    }
    return _amountLabel;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), [[self class] getCellHeight] - 1, kScreen_Width - K375(15), 1)];
        _lineView.backgroundColor = KLine_Color;
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 80;
}

@end
