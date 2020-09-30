//
//  XXAssetSingleManager.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/28.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXAssetSingleManager : NSObject

/// 资产model
@property (nonatomic, strong) XXAssetModel *assetModel;
//@property (nonatomic, copy) void(^assetChangeBlock)(void);

+ (XXAssetSingleManager *)sharedManager;

/// 获取资产model
/// @param symbol 币名字
- (XXTokenModel *)assetTokenBySymbol:(NSString *)symbol;

/// 获取外链地址
/// @param symbol 币名字
- (NSString *)externalAddressBySymbol:(NSString *)symbol;
@end

NS_ASSUME_NONNULL_END
