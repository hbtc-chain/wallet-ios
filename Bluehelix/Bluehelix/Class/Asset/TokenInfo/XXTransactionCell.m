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

- (void)configData:(NSDictionary *)dic {
    self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:[dic[@"time"] longLongValue]];
    NSDictionary *activity = [dic[@"activities"] firstObject];
    [self configActivity:activity];
    if ([dic[@"success"] intValue]) {
        self.stateLabel.text = LocalizedString(@"Success");
        self.stateLabel.textColor = KRGBA(70, 206, 95, 100);
        self.stateLabel.backgroundColor = KRGBA(212, 245, 220, 100);
        self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"Success") font:kFont10] + 4, 16);
    } else {
        self.stateLabel.text = LocalizedString(@"Failed");
        self.stateLabel.textColor = KRGBA(242, 32, 55, 100);
        self.stateLabel.backgroundColor = KRGBA(252, 206, 209, 100);
        self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"Failed") font:kFont10] + 4, 16);
    }
}

- (void)configActivity:(NSDictionary *)dic {
    NSString *type = dic[@"type"];
    NSDictionary *value = dic[@"value"];
    NSString *showTypeStr = LocalizedString(@"ChainOtherType");
    if ([type isEqualToString:kMsgSend]) {
        showTypeStr = LocalizedString(@"Transfer");
        XXMsgSendModel *model = [XXMsgSendModel mj_objectWithKeyValues:value];
        NSDictionary *amount = [model.amount firstObject];
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:amount[@"denom"]];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:amount[@"amount"]]; //数量
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        if ([model.from_address isEqualToString:KUser.address]) {
            self.amountLabel.text = [NSString stringWithFormat:@"-%@",amountStr];
        } else {
            self.amountLabel.text = [NSString stringWithFormat:@"+%@",amountStr];
        }
    } else if ([type isEqualToString:kMsgDelegate]) {
        showTypeStr = LocalizedString(@"Delegate");
    } else if ([type isEqualToString:kMsgUndelegate]) {
        showTypeStr = LocalizedString(@"TransferDelegate");
    } else if ([type isEqualToString:kMsgKeyGen]) {
        showTypeStr = LocalizedString(@"ChainAddress");
    } else if ([type isEqualToString:kMsgDeposit]) {
        showTypeStr = LocalizedString(@"ChainDeposit");
        XXMsgDepositModel *model = [XXMsgDepositModel mj_objectWithKeyValues:value];
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.symbol];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:model.amount]; //数量
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"+%@",amountStr];
    } else if ([type isEqualToString:kMsgWithdrawal]) {
        showTypeStr = LocalizedString(@"ChainWithdrawal");
        XXMsgWithdrawalModel *model = [XXMsgWithdrawalModel mj_objectWithKeyValues:value];
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.symbol];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:model.amount]; //数量
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"-%@",amountStr];
    } else {
        
    }
    self.typeLabel.text = showTypeStr;
    self.typeLabel.frame = CGRectMake(K375(24), 20, [NSString widthWithText:showTypeStr font:kFontBold(17)], 24);
}

- (XXLabel *)typeLabel {
    if (_typeLabel == nil) {
        _typeLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), 20, 0, 24) text:@"" font:kFontBold(17) textColor:kDark100];
    }
    return _typeLabel;
}

- (XXLabel *)stateLabel {
    if (_stateLabel == nil) {
        _stateLabel = [[XXLabel alloc] init];
        _stateLabel.font = kFont(10);
        _stateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _stateLabel;
}

- (XXLabel *)timeLabel {
    if (_timeLabel == nil) {
        _timeLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), CGRectGetMaxY(self.typeLabel.frame), kScreen_Width - K375(48), 16) font:kFont(13) textColor:kDark50];
    }
    return _timeLabel;
}

- (XXLabel *)amountLabel {
    if (_amountLabel == nil) {
        _amountLabel = [XXLabel labelWithFrame:CGRectMake(CGRectGetMaxX(self.typeLabel.frame), 16, kScreen_Width - 16 - CGRectGetMaxX(self.typeLabel.frame), 24) font:kNumberFontBold(17) textColor:kDark100];
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
