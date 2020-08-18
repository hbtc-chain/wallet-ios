//
//  XXAssetModel.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/02.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXAssetModel : NSObject

@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *sequence; //交易数
@property (nonatomic, strong) NSArray *assets;
@property (nonatomic, strong) NSString *bonded; //委托中
@property (nonatomic, strong) NSString *unbonding; //赎回中
@property (nonatomic, strong) NSString *claimed_reward; //已收益

#pragma mark 自定义属性
@property (nonatomic, strong) NSString *symbol; //币名
@property (nonatomic, strong) NSString *amount; //数量



/** token id */
@property (strong, nonatomic) NSString *tokenId;

/** token 名称 */
@property (strong, nonatomic) NSString *tokenName;

/** token 全称 */
@property (strong, nonatomic) NSString *tokenFullName;

/** 全部 */
@property (strong, nonatomic) NSString *total;

/** 可用 */
@property (strong, nonatomic) NSString *free;

/** 冻结 */
@property (strong, nonatomic) NSString *locked;

/** btc 估值 */
@property (strong, nonatomic) NSString *btcValue;

/** 图标 */
@property (strong, nonatomic) NSString *iconUrl;

/** 是否允许提币 */
@property (assign, nonatomic) BOOL allowWithdraw;

/** 禁止提币原因 */
@property (strong, nonatomic) NSString *refuseReason;

/** 是否允许充币 */
@property (assign, nonatomic) BOOL allowDeposit;

/** 最小充币数量 */
@property (strong, nonatomic) NSString *minDepositQuantity;

/** 是否EOS */
@property (assign, nonatomic) BOOL needAddressTag;

/** "chainTypes": [
            {
                "chainType": "OMIN",
                "allowDeposit": true,
                "allowWithdraw": true
            },
            {
                "chainType": "ERC20",
                "allowDeposit": true,
                "allowWithdraw": true
            }
        ]
 */
//@property (strong, nonatomic) NSArray *chainTypes;

/** 资产改动回调 */
@property (strong, nonatomic) void(^assetsChange)(void);
@end

NS_ASSUME_NONNULL_END
