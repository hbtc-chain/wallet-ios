//
//  XXAssetSingleManager.m
//  Bluehelix
//
//  Created by 袁振 on 2020/9/28.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXAssetSingleManager.h"
#import "XXTokenModel.h"

@interface XXAssetSingleManager ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XXAssetSingleManager

static XXAssetSingleManager *_assetManager;
+ (XXAssetSingleManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _assetManager = [[XXAssetSingleManager alloc] init];
        _assetManager.timer = [NSTimer scheduledTimerWithTimeInterval:5 repeats:YES block:^(NSTimer * _Nonnull timer) {
            [_assetManager requestAsset];
        }];
        [_assetManager.timer fire];
    });
    return _assetManager;
}

/// 请求资产信息
- (void)requestAsset {
    MJWeakSelf
    NSString *path = [NSString stringWithFormat:@"/api/v1/cus/%@",KUser.address];
    [HttpManager getWithPath:path params:nil andBlock:^(id data, NSString *msg, NSInteger code) {
        if (code == 0) {
            weakSelf.assetModel = [XXAssetModel mj_objectWithKeyValues:data];
        }
        [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:kNotificationAssetRefresh object:nil userInfo:nil]];
    }];
}

- (XXTokenModel *)assetTokenBySymbol:(NSString *)symbol {
    for (XXTokenModel *tokenModel in self.assetModel.assets) {
        if ([tokenModel.symbol isEqualToString:symbol]) {
            return tokenModel;
        }
    }
    return nil;
}

- (NSString *)externalAddressBySymbol:(NSString *)symbol {
    XXTokenModel *tokenModel = [[XXSqliteManager sharedSqlite] tokenBySymbol:symbol];
    for (XXTokenModel *assetModel in self.assetModel.assets) {
        if ([assetModel.symbol isEqualToString:tokenModel.chain]) {
            return assetModel.external_address;
        }
    }
    return @"";
}

@end
