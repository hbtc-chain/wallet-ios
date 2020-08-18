//
//  XXMarketCell.m
//  Bhex
//
//  Created by BHEX on 2018/7/1.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "XXMarketCell.h"

@interface XXMarketCell ()

/** 名称 */
@property (strong, nonatomic) XXLabel *nameLabel;

/** 数量 */
@property (strong, nonatomic) XXLabel *numberLabel;

/** 最新价 */
@property (strong, nonatomic) XXLabel *nowPriceLabel;

/** 钱 */
@property (strong, nonatomic) XXLabel *moneyLabel;

/** 涨幅度 */
@property (strong, nonatomic) XXButton *riseFallButton;

@end

@implementation XXMarketCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setupUI];
        
    }
    return self;
}

#pragma mark - 1. 创建主界面
- (void)setupUI {
    
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.numberLabel];
    
    [self.contentView addSubview:self.nowPriceLabel];
    [self.contentView addSubview:self.moneyLabel];
    
    [self.contentView addSubview:self.riseFallButton];
    
    [self.contentView addSubview:self.lineView];
}

- (void)cleanData {
    
    self.nameLabel.text = @"--";
    self.numberLabel.text = @"--";
    self.nowPriceLabel.text = @"--";
    self.moneyLabel.text = @"--";
    [self.riseFallButton setTitle:@"--" forState:UIControlStateNormal];
    self.riseFallButton.backgroundColor = kGreen20;
}

#pragma mark - 2. 模型赋值
- (void)setModel:(XXSymbolModel *)model {
    
    if (model.type == SymbolTypeCoin) {
        self.nowPriceLabel.left = K375(143);
        self.nowPriceLabel.width = K375(120);
    } else {
        self.nowPriceLabel.left = K375(160);
        self.nowPriceLabel.width = K375(104);
    }
    self.moneyLabel.left = self.nowPriceLabel.left;
    self.moneyLabel.width = self.nowPriceLabel.width;
    
    _model = model;
    NSMutableArray *itemsArray = [NSMutableArray array];
    itemsArray[0] = @{@"string":_model.baseTokenName, @"color":kDark100, @"font":kFontBold(16)};
    itemsArray[1] = @{@"string":[NSString stringWithFormat:@" /%@", _model.quoteTokenName], @"color":kDark50, @"font":kFontBold12};
    if (model.type == SymbolTypeCoin) {
        self.nameLabel.attributedText = [NSString mergeStrings:itemsArray];
    } else {
        self.nameLabel.text = model.symbolName;
    }
    
    if (_model.quote && _model.quote.close) {
        self.nowPriceLabel.text = [KDecimal decimalNumber:KString(_model.quote.close) RoundingMode:NSRoundDown scale:[KDecimal scale:_model.minPricePrecision]];
        if ([self.nowPriceLabel.text isEqualToString:@"nan"]) {
            
        }
        
            self.numberLabel.text = [NSString stringWithFormat:@"%@ %@",LocalizedString(@"Vol"), [KDecimal decimalNumber:KString(_model.quote.volume) RoundingMode:NSRoundDown scale:2]];
            self.moneyLabel.text = [[RatesManager shareRatesManager] getRatesWithToken:_model.quoteTokenId priceValue:[_model.quote.close doubleValue]];
        
        CGFloat value = (([_model.quote.close floatValue] - [_model.quote.open floatValue])*100)/[_model.quote.open floatValue];
        if (isnan(value) || isinf(value)) {
            value = 0.0;
        }
        NSString *riseFallString = [NSString riseFallValue:value];
        if (value >= 0) {
            self.riseFallButton.backgroundColor = kGreen20;
            [self.riseFallButton setTitleColor:kGreen100 forState:UIControlStateNormal];
            [self.riseFallButton setTitle:[NSString stringWithFormat:@"+%@", riseFallString] forState:UIControlStateNormal];
            [self.riseFallButton setImage:[UIImage imageNamed:@"rise"] forState:UIControlStateNormal];
   
        } else {
            self.riseFallButton.backgroundColor = kRed20;
            [self.riseFallButton setTitleColor:kRed100 forState:UIControlStateNormal];
            [self.riseFallButton setTitle:riseFallString forState:UIControlStateNormal];
            [self.riseFallButton setImage:[UIImage imageNamed:@"fall"] forState:UIControlStateNormal];
        }
        
        [self.riseFallButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.riseFallButton.imageView.bounds.size.width - 2, 0, self.riseFallButton.imageView.bounds.size.width + 2)];
        [self.riseFallButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.riseFallButton.titleLabel.bounds.size.width + 2, 0, -self.riseFallButton.titleLabel.bounds.size.width - 2)];
    } else {
        self.numberLabel.text = @"--";
        self.nowPriceLabel.text = @"--";
        self.moneyLabel.text = @"--";
        self.riseFallButton.backgroundColor = kGreen20;
        [self.riseFallButton setTitleColor:kGreen100 forState:UIControlStateNormal];
        [self.riseFallButton setTitle:@"--" forState:UIControlStateNormal];
    }

    self.lineView.backgroundColor = KLine_Color;
    self.numberLabel.textColor = kDark50;
    self.moneyLabel.textColor = kDark50;
}

#pragma mark - || 懒加载
- (XXLabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [XXLabel labelWithFrame:CGRectMake(KSpacing, 13, K375(126), 24) text:@"" font:kFontBold14 textColor:kDark100 alignment:NSTextAlignmentLeft];
    }
    return _nameLabel;
}

- (XXLabel *)numberLabel {
    if (_numberLabel == nil) {
        _numberLabel = [XXLabel labelWithFrame:CGRectMake(self.nameLabel.left, CGRectGetMaxY(self.nameLabel.frame), self.nameLabel.width, 16) text:@"" font:kFont12 textColor:kDark50 alignment:NSTextAlignmentLeft];
    }
    return _numberLabel;
}

- (XXLabel *)nowPriceLabel {
    if (_nowPriceLabel == nil) {
        _nowPriceLabel = [XXLabel labelWithFrame:CGRectMake(K375(160), self.nameLabel.top, K375(104), self.nameLabel.height) text:@"" font:kFontBold(15) textColor:kDark100 alignment:NSTextAlignmentLeft];
//        _nowPriceLabel.backgroundColor = kRed20;
    }
    return _nowPriceLabel;
}

- (XXLabel *)moneyLabel {
    if (_moneyLabel == nil) {
        _moneyLabel = [XXLabel labelWithFrame:CGRectMake(self.nowPriceLabel.left, CGRectGetMaxY(self.nowPriceLabel.frame), self.nowPriceLabel.width, self.numberLabel.height) text:@"" font:kFont12 textColor:kDark50 alignment:NSTextAlignmentLeft];
    }
    return _moneyLabel;
}

- (XXButton *)riseFallButton {
    if (_riseFallButton == nil) {
        _riseFallButton = [XXButton buttonWithFrame:CGRectMake(kScreen_Width - KSpacing - K375(88), 16, K375(88), 32) title:@"" font:kFontBold(15) titleColor:kGreen100 block:^(UIButton *button) {
            
        }];
        
        _riseFallButton.layer.cornerRadius = 2;
        _riseFallButton.layer.masksToBounds = YES;
        _riseFallButton.userInteractionEnabled = NO;
    }
    return _riseFallButton;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(KSpacing, [XXMarketCell getCellHeight] - KLine_Height, kScreen_Width - KSpacing, KLine_Height)];
    }
    return _lineView;
}

+ (CGFloat)getCellHeight {
    return 64;
}


@end
