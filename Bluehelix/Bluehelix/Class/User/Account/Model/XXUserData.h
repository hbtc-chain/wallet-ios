//
//  XXUserData.h
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
@class XXAccountModel;
@interface XXUserData : NSObject

+ (XXUserData *)sharedUserData;
@property (nonatomic, assign) BOOL deleteFlag; //删除测试网数据
@property (nonatomic, assign) BOOL agreeService;
@property (nonatomic, assign) BOOL isNightType; //是否夜间模式
@property (nonatomic, assign) BOOL isSettedNightType; //手动设置的夜间模式
@property (nonatomic, assign) BOOL isHideSmallCoin; //是否隐藏小额币种
@property (nonatomic, assign) BOOL isHideAsset; //是否隐藏资产
@property (nonatomic, assign) BOOL tokenSortDes; //币种降序
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) XXAccountModel *currentAccount; //当前用户
@property (nonatomic, copy) NSString *localUserName;
@property (nonatomic, copy) NSString *localPassword;
@property (nonatomic, copy) NSString *localPhraseString; //临时助记词
@property (nonatomic, copy) NSString *localPrivateKey; //临时私钥
@property (nonatomic, copy) NSString *rootID; //当前用户id
@property (nonatomic, copy) NSString *address; //当前用户地址
@property (nonatomic, copy) NSString *ratesKey; //汇率
@property (nonatomic, copy) NSString *netWorkStatus; //网络状态
@property (nonatomic, copy) NSString *fee; //手续费
@property (nonatomic, copy) NSString *showFee; //展示的手续费
@property (nonatomic, copy) NSString *gas; //气

/** 币币token列表 */
@property (nonatomic, copy) NSString *tokenString;

/** default tokens */
@property (nonatomic, copy) NSString *defaultTokens;

/// verified tokens
@property (nonatomic, copy) NSString *verifiedTokens;

/// 链列表
@property (nonatomic, copy) NSString *chainString;

/** 面容锁是否开启 */
@property (nonatomic, assign) BOOL isFaceIDLockOpen;
/** 指纹锁是否开启 */
@property (nonatomic, assign) BOOL isTouchIDLockOpen;

/**
 需要验证
 分两种情况 1.每次重新进入app
 */
@property (nonatomic, assign) BOOL shouldVerify;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *lastPasswordTime; //记录上次最后输入密码的时间 30分钟免密码
@property (nonatomic, assign) BOOL isQuickTextOpen; //30分钟免密码
@property (nonatomic, assign) BOOL showPassword; //弹出密码框

-(id)getValueForKey:(NSString*)key;
- (void)cleanTestData; //删除测试网数据
@end

NS_ASSUME_NONNULL_END
