//
//  XXMessageCell.m
//  Bluehelix
//
//  Created by 袁振 on 2020/5/22.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXMessageCell.h"
#import "XXMessageModel.h"

@interface XXMessageCell ()

@property (nonatomic, strong) XXLabel *typeLabel;
@property (nonatomic, strong) XXLabel *timeLabel;
@property (nonatomic, strong) XXLabel *amountLabel;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) XXLabel *stateLabel;

@end

@implementation XXMessageCell
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

- (void)configData:(XXMessageModel *)model {
    self.amountLabel.text = [NSString stringWithFormat:@"%@ %@",model.amount, [model.symbol uppercaseString]];
    NSString *time = model.time;
    self.timeLabel.text = [NSString dateStringFromTimestampWithTimeTamp:[time longLongValue]];
    if (model.tx_type.intValue == 1) {
        self.typeLabel.text = LocalizedString(@"Transfer");
    } else if(model.tx_type.intValue == 2) {
        self.typeLabel.text = LocalizedString(@"ReceiveMoney");
    } else if(model.tx_type.intValue == 3) {
        self.typeLabel.text = LocalizedString(@"Recharge");
    } else if(model.tx_type.intValue == 4) {
        self.typeLabel.text = LocalizedString(@"Withdraw");
    }
    self.typeLabel.frame = CGRectMake(K375(24), 20, [NSString widthWithText:self.typeLabel.text font:kFontBold(17)], 24);
    self.stateLabel.text = LocalizedString(@"Success");
    self.stateLabel.textColor = kGreen100;
    self.stateLabel.backgroundColor = [kGreen100 colorWithAlphaComponent:0.2];
    self.stateLabel.frame = CGRectMake(CGRectGetMaxX(self.typeLabel.frame) +5, 24, [NSString widthWithText:LocalizedString(@"Success") font:kFont10] + 8, 16);
    if (model.read) {
        self.amountLabel.textColor = kGray500;
        self.typeLabel.textColor = kGray500;
    } else {
        self.amountLabel.textColor = kGray900;
        self.typeLabel.textColor = kGray900;
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
