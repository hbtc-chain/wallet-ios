//
//  XXAssetManager.h
//  Bluehelix
//
//  Created by BHEX on 2020/04/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

/// 资产
@interface XXAssetManager : NSObject

/// 资产model
@property (nonatomic, strong) XXAssetModel *assetModel;
@property (nonatomic, copy) void(^assetChangeBlock)(void);

/// 请求资产信息
- (void)requestAsset;


@end

NS_ASSUME_NONNULL_END
