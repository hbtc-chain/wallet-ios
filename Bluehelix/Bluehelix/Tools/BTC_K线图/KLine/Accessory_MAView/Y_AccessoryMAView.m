//
//  Y_AccessoryMAView.m
//  BTC-Kline
//
//  Created by yate1996 on 16/5/4.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_AccessoryMAView.h"
#import "Masonry.h"
#import "UIColor+Y_StockChart.h"
#import "Y_KLineModel.h"

@interface Y_AccessoryMAView()

@property (strong, nonatomic) UILabel *accessoryDescLabel;

@property (strong, nonatomic) UILabel *DIFLabel;

@property (strong, nonatomic) UILabel *DEALabel;

@property (strong, nonatomic) UILabel *MACDLabel;

@end
@implementation Y_AccessoryMAView

- (instancetype)init
{
    self = [super init];
    if (self) {
        _DIFLabel = [self private_createLabel];
        _DEALabel = [self private_createLabel];
        _MACDLabel = [self private_createLabel];
        _accessoryDescLabel = [self private_createLabel];
        
        _DIFLabel.textColor = [UIColor ma5Color];
        _DEALabel.textColor = [UIColor ma10Color];
        _MACDLabel.textColor = [UIColor ma30Color];

        
        [_accessoryDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(2);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        
        [_DIFLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_accessoryDescLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
            
        }];
        
        [_DEALabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_DIFLabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        [_MACDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_DEALabel.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    return self;
}

+(instancetype)view
{
    Y_AccessoryMAView *MAView = [[Y_AccessoryMAView alloc]init];
    
    return MAView;
}
-(void)maProfileWithModel:(Y_KLineModel *)model
{
    if(self.targetLineStatus != Y_StockChartTargetLineStatusKDJ)
    {
        _accessoryDescLabel.text = @" MACD(12,26,9)";
        _DIFLabel.text = [NSString stringWithFormat:@" DIF:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.DIF doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        _DEALabel.text = [NSString stringWithFormat:@" DEA:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.DEA doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        _MACDLabel.text = [NSString stringWithFormat:@" MACD:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.MACD doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
    } else {
        _accessoryDescLabel.text = @" KDJ(14,1,3)";
        
        _DIFLabel.text = [NSString stringWithFormat:@" K:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.KDJ_K doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        _DEALabel.text = [NSString stringWithFormat:@" D:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.KDJ_D doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
        _MACDLabel.text = [NSString stringWithFormat:@" J:%@ ", [KDecimal decimalNumber:[NSString stringWithFormat:@"%.12f", [model.KDJ_J doubleValue]] RoundingMode:NSRoundDown scale:KDetail.priceDigit]];
    }


}
- (UILabel *)private_createLabel
{
    UILabel *label = [UILabel new];
    label.font = [UIFont systemFontOfSize:9];
    label.textColor = [UIColor assistTextColor];
    [self addSubview:label];
    return label;
}

@end
