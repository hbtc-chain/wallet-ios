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

- (void)configData:(NSDictionary *)dic {
    self.amountLabel.text = @"";
    self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:[dic[@"time"] longLongValue]];
    NSArray *activities = dic[@"activities"];
    NSDictionary *activity = [activities firstObject];
    if (activities.count > 1) {
        [self configActivity:activity count:[NSString stringWithFormat:@"+%lu",activities.count -1]];
    } else {
        [self configActivity:activity count:@""];
    }
    
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

- (void)configActivity:(NSDictionary *)dic count:(NSString *)countString{
    NSString *type = dic[@"type"];
    NSDictionary *value = dic[@"value"];
    NSString *showTypeStr = LocalizedString(@"ChainOtherType");
    
    if ([type isEqualToString:kMsgSend]) { //转账
        showTypeStr = LocalizedString(@"Transfer");
        XXMsgSendModel *model = [XXMsgSendModel mj_objectWithKeyValues:value];
        NSDictionary *amount = [model.amount firstObject];
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:amount[@"denom"]];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:amount[@"amount"]];
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        if ([model.from_address isEqualToString:KUser.address]) {
            self.amountLabel.text = [NSString stringWithFormat:@"-%@",amountStr];
        } else {
            self.amountLabel.text = [NSString stringWithFormat:@"+%@",amountStr];
        }
    } else if ([type isEqualToString:kMsgDelegate]) { //委托
        showTypeStr = LocalizedString(@"Delegate");
        XXMsgDelegateModel *model = [XXMsgDelegateModel mj_objectWithKeyValues:value];
        XXCoinModel *coin  = model.amount;
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:coin.denom];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:coin.amount];
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"-%@",amountStr];
    } else if ([type isEqualToString:kMsgUndelegate]) { //解委托
        showTypeStr = LocalizedString(@"CancelDelegate");
        XXMsgDelegateModel *model = [XXMsgDelegateModel mj_objectWithKeyValues:value];
        XXCoinModel *coin  = model.amount;
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:coin.denom];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:coin.amount];
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"+%@",amountStr];
    } else if ([type isEqualToString:kMsgKeyGen]) { // 跨链地址生成
        showTypeStr = LocalizedString(@"ChainAddress");
    } else if ([type isEqualToString:kMsgDeposit]) { // 跨链充值
        showTypeStr = LocalizedString(@"ChainDeposit");
        XXMsgDepositModel *model = [XXMsgDepositModel mj_objectWithKeyValues:value];
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.symbol];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:model.amount];
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"+%@",amountStr];
    } else if ([type isEqualToString:kMsgWithdrawal]) { // 跨链提币
        showTypeStr = LocalizedString(@"ChainWithdrawal");
        XXMsgWithdrawalModel *model = [XXMsgWithdrawalModel mj_objectWithKeyValues:value];
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:model.symbol];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:model.amount]; //数量
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"-%@",amountStr];
    } else if ([type isEqualToString:kMsgWithdrawalDelegationReward]) { //提取收益
        showTypeStr = LocalizedString(@"WithdrawMoney");
        XXMsgDelegateModel *model = [XXMsgDelegateModel mj_objectWithKeyValues:value];
        XXCoinModel *coin = model.amount;
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:coin.denom];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:coin.amount];
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"+%@",amountStr];
    } else if ([type isEqualToString:kMsgPledge]) { //质押
        showTypeStr = LocalizedString(@"ProposalNavgationTitlePledge");
        NSArray *amounts = value[@"amount"];
        XXCoinModel *coin = [XXCoinModel mj_objectWithKeyValues:[amounts firstObject]];
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:coin.amount];
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"%@",amountStr];
    }  else if ([type isEqualToString:kMsgVote]) { // 投票
        showTypeStr = LocalizedString(@"ProposalNavgationTitleVote");
    }  else if ([type isEqualToString:kMsgCreateProposal]) { //发起提案
        showTypeStr = LocalizedString(@"VotingProposal");
        NSArray *amounts = value[@"initial_deposit"];
        XXCoinModel *coin = [XXCoinModel mj_objectWithKeyValues:[amounts firstObject]];
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:kMainToken];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:coin.amount];
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"-%@",amountStr];
    } else if ([type isEqualToString:kMsgMappingSwap]) { //映射
        showTypeStr = LocalizedString(@"Exchange");
        NSArray *coins = value[@"coins"];
        XXCoinModel *coin = [XXCoinModel mj_objectWithKeyValues:[coins firstObject]];
        XXTokenModel *token = [[XXSqliteManager sharedSqlite] tokenBySymbol:coin.denom];
        NSDecimalNumber *amountDecimal = [NSDecimalNumber decimalNumberWithString:coin.amount];
        NSString *amountStr = [[amountDecimal decimalNumberByDividingBy:kPrecisionDecimalPower(token.decimals)] stringValue];
        self.amountLabel.text = [NSString stringWithFormat:@"-%@",amountStr];
        if ([coin.denom isEqualToString:value[@"issue_symbol"]]) {
            self.amountLabel.text = [NSString stringWithFormat:@"-%@",amountStr];
        } else {
            self.amountLabel.text = [NSString stringWithFormat:@"+%@",amountStr];
        }
    } else {}
    self.typeLabel.text = [NSString stringWithFormat:@"%@%@",showTypeStr,countString];
    self.typeLabel.frame = CGRectMake(K375(24), 20, [NSString widthWithText:self.typeLabel.text font:kFontBold(17)], 24);
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
