//
//  XXAssetManager.m
//  Bluehelix
//
//  Created by 袁振 on 2020/04/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetManager.h"

@implementation XXAssetManager

/// 请求资产信息
- (void)requestAsset {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@",KUser.address];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            NSLog(@"%@",data);
            weakSelf.assetModel = [XXAssetModel mj_objectWithKeyValues:data];
            if (weakSelf.assetChangeBlock) {
                weakSelf.assetChangeBlock();
            }
        }
    }];
}

@end
