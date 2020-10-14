//
//  XXUserData.h
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XXSymbolModel.h"
NS_ASSUME_NONNULL_BEGIN
@class XXAccountModel;
@interface XXUserData : NSObject

+ (XXUserData *)sharedUserData;
@property (nonatomic, strong) NSString *localUserName;
@property (nonatomic, strong) NSString *localPassword;
@property (nonatomic, strong) NSString *localPhraseString; //临时助记词
@property (nonatomic, strong) NSString *localPrivateKey; //临时私钥
@property (nonatomic, assign) BOOL agreeService;
@property (nonatomic, assign) BOOL isNightType; //是否夜间模式
@property (nonatomic, assign) BOOL isSettedNightType; //手动设置的夜间模式
@property (nonatomic, assign) BOOL isHideSmallCoin; //是否隐藏小额币种
@property (nonatomic, assign) BOOL isHideAsset; //是否隐藏资产
@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) XXAccountModel *currentAccount; //当前用户
@property (nonatomic, strong) NSString *rootID; //当前用户id
@property (nonatomic, strong) NSString *address; //当前用户地址

@property (nonatomic, strong) NSString *ratesKey; //汇率
@property (nonatomic, strong) NSString *netWorkStatus; //网络状态

/** 币币token列表 */
@property (strong, nonatomic) NSString *tokenString;

/** 面容锁是否开启 */
@property (assign, nonatomic) BOOL isFaceIDLockOpen;
/** 指纹锁是否开启 */
@property (assign, nonatomic) BOOL isTouchIDLockOpen;

/**
 需要验证
 分两种情况 1.每次重新进入app
 */
@property (nonatomic, assign) BOOL shouldVerify;

-(id)getValueForKey:(NSString*)key;
-(void)saveValeu:(id)value forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
