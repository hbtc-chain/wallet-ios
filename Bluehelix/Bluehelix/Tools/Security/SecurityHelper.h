//
//  SecurityHelper.h
//  Bhex
//
//  Created by Bhex on 2018/8/13.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#define SecurityHelperVerify [[SecurityHelper sharedSecurityHelper] showSecurityVerify]
#define SecurityHelperForceVerify [[SecurityHelper sharedSecurityHelper] forceSecurityVerify]
#define SecurityHelperSupportFaceID [[SecurityHelper sharedSecurityHelper] supportFaceID]
#define SecurityHelperSupportBiometricAuth [[SecurityHelper sharedSecurityHelper] supportBiometricAuth]

typedef NS_ENUM(NSInteger, BHBiometryType)
{
    /// The device does not support biometry.
    BHBiometryTypeNone,
    /// The device supports Touch ID.
    BHBiometryTypeTouchID,
    /// The device supports Face ID.
    BHBiometryTypeFaceID,
};

@interface SecurityHelper : NSObject

@property (nonatomic, copy) void(^completeBlock)(void); //登录成功 回调
@property (nonatomic, assign) BOOL gestureLockOpen; //手势密码开关
@property (nonatomic, assign) BOOL shouldVerify; //打开验证

+ (SecurityHelper *)sharedSecurityHelper;
- (void)showSecurityVerify;
- (void)forceSecurityVerify;  //结束进程后打开

- (BOOL)supportFaceID;
- (BOOL)supportTouchID;
- (BOOL)supportBiometricAuth;
- (BOOL)biometricDataSame; //判断指纹是否有更改
- (void)saveBiometricData; //保存指纹
@end
