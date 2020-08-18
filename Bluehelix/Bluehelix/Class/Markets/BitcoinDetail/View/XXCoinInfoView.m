//
//  XXCoinInfoView.m
//  Bhex
//
//  Created by Bhex on 2019/9/23.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXCoinInfoView.h"
#import "UIColor+Y_StockChart.h"
#import "XYHNumbersLabel.h"

@interface XXCoinInfoView ()

/** <#备注#> */
@property (strong, nonatomic, nullable) NSMutableDictionary *dataDict;

/** 失败视图 */
@property (nonatomic, strong) XXFailureView *failureView;

@end

@implementation XXCoinInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.failureView];
    }
    return self;
}

#pragma mark - 1. 加载币种信息
- (void)loadDataOfCoin {
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    MJWeakSelf
    if (KDetail.symbolModel.type == SymbolTypeCoin) {
        [HttpManager ms_GetWithPath:@"basic/token" params:@{@"token_id":KString(KDetail.symbolModel.baseTokenId)} andBlock:^(id data, NSString *msg, NSInteger code) {
            [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
            if (code == 0) {
                weakSelf.failureView.hidden = YES;
                [weakSelf setupUIWithDataDic:data];
            } else {
                weakSelf.failureView.msgLabel.text = KString(msg);
                weakSelf.failureView.hidden = NO;
            }
        }];
    }
}

- (void)clearSubViews {
    for (UIView *subView in self.subviews) {
        if (subView != self.failureView) {
            [subView removeFromSuperview];
        }
    }
}

#pragma mark - 2. 初始化币币UI
- (void)setupUIWithDataDic:(NSDictionary *)dataDic {
    [self clearSubViews];
    
    XXLabel *titleLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), 0, kScreen_Width - K375(48), 60) text:KString(dataDic[@"tokenName"]) font:kFontBold18 textColor:[UIColor mainTextColor]];
    [self addSubview:titleLabel];
    
    UIView *lineOne = [[UIView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(titleLabel.frame), kScreen_Width - K375(24), 1)];
    lineOne.backgroundColor = [UIColor lineColor];
    [self addSubview:lineOne];
    
    NSArray *namesArray = @[LocalizedString(@"PublishTime"),
                            LocalizedString(@"TotalAmountOfIssuance"),
                            LocalizedString(@"TotalCirculation"),
                            LocalizedString(@"WhitePaper"),
                            LocalizedString(@"OfficialWebsite"),
                            LocalizedString(@"BlockQuery")];
    
    NSString *oneString = KString(dataDic[@"publishTime"]);
    if (oneString.length == 0) {
        oneString = @"--";
    }
    
    NSString *twoString = [NSString stringWithFormat:@"%@", dataDic[@"maxQuantitySupplied"]];
    if (twoString.length == 0) {
        twoString = @"--";
    }
    
    NSString *threeString = [NSString stringWithFormat:@"%@", dataDic[@"currentTurnover"]];
    if (threeString.length == 0) {
        threeString = @"--";
    }
    
    NSString *fourString = KString(dataDic[@"whitePaperUrl"]);
    if (fourString.length == 0) {
        fourString = @"--";
    }
    
    NSString *fiveString = KString(dataDic[@"officialWebsiteUrl"]);
    if (fiveString.length == 0) {
        fiveString = @"--";
    }
    
    NSString *sexString = KString(dataDic[@"exploreUrl"]);
    if (sexString.length == 0) {
        sexString = @"--";
    }
    
    NSArray *valuesArray = @[oneString, twoString, threeString, fourString, fiveString, sexString];
    
    CGFloat offetY = CGRectGetMaxY(lineOne.frame);
    for (NSInteger i=0; i < 6; i ++) {
        XXLabel *nameLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), offetY, K375(200), 49) text:namesArray[i] font:kFont15 textColor:[UIColor assistTextColor]];
    
        XXLabel *valueLabel = [XXLabel labelWithFrame:CGRectMake(K375(150), offetY, kScreen_Width - K375(173), 49) text:valuesArray[i] font:kFont15 textColor:[UIColor mainTextColor]];
        valueLabel.textAlignment = NSTextAlignmentRight;
        
        if (i > 2) {
            [valueLabel addClickCopyFunction];
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(K375(24), CGRectGetMaxY(valueLabel.frame), kScreen_Width - K375(24), 1)];
        lineView.backgroundColor = [UIColor lineColor];
        
        [self addSubview:nameLabel];
        [self addSubview:valueLabel];
        [self addSubview:lineView];
        
        offetY += 50.0;
    }
    
    offetY += 20;
    
    // Intro
    XXLabel *tipLabel = [XXLabel labelWithFrame:CGRectMake(K375(24), offetY, kScreen_Width, 60) text:LocalizedString(@"Intro") font:kFontBold18 textColor:[UIColor mainTextColor]];
    [self addSubview:tipLabel];
    
    offetY += 60;
    XYHNumbersLabel *descriptionLabel = [[XYHNumbersLabel alloc] initWithFrame:CGRectMake(K375(24), offetY, kScreen_Width - K375(48), 0) font:kFont16];
    descriptionLabel.textColor = [UIColor mainTextColor];
    [self addSubview:descriptionLabel];
    
    NSString *descriptionString = KString(dataDic[@"description"]);
    [descriptionLabel setText:descriptionString alignment:NSTextAlignmentLeft];
    
    self.height = CGRectGetMaxY(descriptionLabel.frame) + 50;
    
    if (self.reloadMainUI) {
        self.reloadMainUI();
    }
}

#pragma mark - 3.1 加载资金费率接口
- (void)loadContractFundingRates {
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    MJWeakSelf
    [HttpManager getWithPath:@"v1/contract/funding_rates" params:@{@"symbol_id":KDetail.symbolModel.symbolId} andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            for (NSDictionary *dict in data) {
                if ([dict[@"tokenId"] isEqualToString:KDetail.symbolModel.symbolId]) {
                    double fundingRate = [KString(dict[@"fundingRate"]) doubleValue] * 100;
                    double settleRate = [KString(dict[@"settleRate"]) doubleValue] * 100;
                    weakSelf.dataDict[@"fundingRate"] = [NSString stringWithFormat:@"%@%.4f%@", fundingRate >=0 ? @"" : @"-", fabs(fundingRate), @"%"];
                    weakSelf.dataDict[@"settleRate"] = [NSString stringWithFormat:@"%@%.4f%@", settleRate >=0 ? @"" : @"-", fabs(settleRate), @"%"];
                }
            }
            [weakSelf loadIndexPrice];
        } else {
            [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
            weakSelf.failureView.msgLabel.text = KString(msg);
            weakSelf.failureView.hidden = NO;
        }
    }];
}

#pragma mark - 3.2 加载指数接口
- (void)loadIndexPrice {
    MJWeakSelf
//    [HttpManager quote_GetWithPath:@"quote/v1/indices" params:@{@"symbol":KDetail.symbolModel.baseTokenFutures.displayIndexToken} andBlock:^(id data, NSString *msg, NSInteger code) {
//        if (code == 0) {
//            NSString *indexPrice = KString(data[@"data"][KDetail.symbolModel.baseTokenFutures.displayIndexToken]);
//            weakSelf.dataDict[@"indexPrice"] = [KDecimal decimalNumber:indexPrice RoundingMode:NSRoundUp scale:KDetail.priceDigit];
//            [weakSelf loadQuoteTicker];
//        } else {
//            [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
//            weakSelf.failureView.msgLabel.text = KString(msg);
//            weakSelf.failureView.hidden = NO;
//        }
//    }];
}

#pragma mark - 3.3 加载成交量接口
- (void)loadQuoteTicker {
    MJWeakSelf
    [HttpManager quote_GetWithPath:@"quote/v1/ticker" params:@{@"symbol":[NSString stringWithFormat:@"%@.%@", KDetail.symbolModel.exchangeId, KDetail.symbolModel.symbolId]} andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSArray *dataArray = data[@"data"];
            NSDictionary *dict = dataArray.firstObject;
            weakSelf.dataDict[@"v"] = KString(dict[@"v"]);
            weakSelf.dataDict[@"qv"] = [KDecimal decimalNumber:KString(dict[@"v"]) RoundingMode:NSRoundDown scale:2];
//            [weakSelf setupContractView];
        } else {
            [MBProgressHUD hideAllHUDsForView:weakSelf animated:YES];
            weakSelf.failureView.msgLabel.text = KString(msg);
            weakSelf.failureView.hidden = NO;
        }
    }];
}

#pragma mark - 3. 清理数据
- (void)cleanData {
   
    [self clearSubViews];
}

#pragma mark - || 懒加载
/** 失败视图 */
- (XXFailureView *)failureView {
    if (_failureView == nil) {
        _failureView = [[XXFailureView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 250)];
        _failureView.hidden = YES;
        MJWeakSelf
        _failureView.reloadBlock = ^{
            [weakSelf loadDataOfCoin];
        };
    }
    return _failureView;
}
@end
