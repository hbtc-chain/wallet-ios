//
//  XXAccountModel.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXAccountModel : NSObject

@property (nonatomic, strong) NSString *address; //bht地址
@property (nonatomic, strong) NSString *symbols; //保存的币种
@property (nonatomic, strong) NSString *privateKey; //私钥
@property (nonatomic, strong) NSData *publicKey; //公钥
@property (nonatomic, strong) NSString *userName; //昵称
@property (nonatomic, strong) NSString *password; //密码
@property (nonatomic, strong) NSString *mnemonicPhrase; //助记词
@property (nonatomic, assign) BOOL backupFlag; //是否备份过助记词

@end

NS_ASSUME_NONNULL_END
