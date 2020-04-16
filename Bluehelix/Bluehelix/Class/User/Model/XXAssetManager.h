//
//  XXAssetManager.h
//  Bluehelix
//
//  Created by 袁振 on 2020/04/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 资产
@interface XXAssetManager : NSObject

/// 资产model
@property (nonatomic, strong) XXAssetModel *assetModel;
@property (nonatomic, strong) void(^assetChangeBlock)(void);
/// 单例
+ (XXAssetManager *)sharedManager;

/// 请求资产信息
- (void)requestAsset;


@end

NS_ASSUME_NONNULL_END
