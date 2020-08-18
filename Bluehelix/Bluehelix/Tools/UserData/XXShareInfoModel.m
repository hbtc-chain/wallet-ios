//
//  XXShareInfoModel.m
//  Bhex
//
//  Created by Bhex on 2019/7/8.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXShareInfoModel.h"
#import <SDWebImageManager.h>

@implementation XXShareInfoModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 根据缓存初始化分享信息
        [self initShareInfo];
    }
    return self;
}

#pragma mark - 1. 根据缓存初始化分享信息
- (void)initShareInfo {
    NSDictionary *dict = [[self getValueForKey:@"shareConfigKey"] mj_JSONObject];
    if (dict && [dict isKindOfClass:[NSDictionary class]]) {
        
        // 合约分享 涨跌标题 涨跌底板图片
        self.contractProfitShareTitles = dict[@"contractProfitShareTitles"];
        self.contractZeroShareTitles = dict[@"contractZeroShareTitles"];
        self.contractLossShareTitles = dict[@"contractLossShareTitles"];
        self.contractProfitBackground = dict[@"contractProfitBackground"];
        self.contractLossBackground = dict[@"contractLossBackground"];
        [self loadContractProfitImage];
        [self loadContractLossImage];
        
        // 分享内容
        self.logoUrl = dict[@"logoUrl"];
        self.watermarkImageUrl = dict[@"watermarkImageUrl"];
        self.title = dict[@"title"];
        self.subTitle = dict[@"description"];
        self.openUrl = dict[@"openUrl"];
        NSString *shareUrl = [self getValueForKey:@"shareUrlKey"];
        if (!IsEmpty(shareUrl)) {
            self.openUrl = shareUrl;
        }
        
        NSData *logoData = [self getValueForKey:@"logoImageKey"];
        NSData *waterData = [self getValueForKey:@"watermarkImageKey"];
        if (logoData) {
            self.logoImage = [[UIImage alloc] initWithData:logoData];
        }
        if (waterData) {
            self.watermarkImage = [[UIImage alloc] initWithData:waterData];
        }
    }
}

#pragma mark - 2. 收到分享配置信息
- (void)didReceiveShareConfig:(NSDictionary *)data {
    
    [self saveValeu:[data mj_JSONString] forKey:@"shareConfigKey"];
    
    // 合约分享 涨跌标题 涨跌底板图片
    self.contractProfitShareTitles = data[@"contractProfitShareTitles"];
    self.contractZeroShareTitles = data[@"contractZeroShareTitles"];
    self.contractLossShareTitles = data[@"contractLossShareTitles"];
    self.contractProfitBackground = data[@"contractProfitBackground"];
    self.contractLossBackground = data[@"contractLossBackground"];
    [self loadContractProfitImage];
    [self loadContractLossImage];
    
    // 分享内容
    self.logoUrl = data[@"logoUrl"];
    self.watermarkImageUrl = data[@"watermarkImageUrl"];
    self.title = data[@"title"];
    self.subTitle = data[@"description"];
    self.openUrl = data[@"openUrl"];
    NSString *shareUrl = [self getValueForKey:@"shareUrlKey"];
    if (!IsEmpty(shareUrl)) {
        self.openUrl = shareUrl;
    }
    if (self.shareInfoBlock) {
        self.shareInfoBlock();
    }
    [self loadLogoImage];
    [self loadWatermarkImage];
}

#pragma mark - 3. 加载logo图片
- (void)loadLogoImage {
    if (self.logoUrl.length > 0) {
        MJWeakSelf
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.logoUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [MBProgressHUD hideHUD];
            if (!error && image) {
                weakSelf.logoImage = image;
                [weakSelf saveValeu:data forKey:@"logoImageKey"];
                if (weakSelf.logoBlock) {
                    weakSelf.logoBlock();
                }
            }
        }];
    }
}

#pragma mark - 4. 加载水印图
- (void)loadWatermarkImage {
    
    if (self.watermarkImageUrl.length > 0) {
        MJWeakSelf
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.watermarkImageUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
            [MBProgressHUD hideHUD];
            if (!error && image) {
                weakSelf.watermarkImage = image;
                [weakSelf saveValeu:data forKey:@"watermarkImageKey"];
                if (weakSelf.watermarkBlock) {
                    weakSelf.watermarkBlock();
                }
            }
        }];
    }
}

#pragma mark - 5. 收到分享配置信息
- (void)didReceiveInvitationShareUrl:(NSDictionary *)data {
//    if (!IsDict(data) || !IsString(data[@"shareUrl"])) {
//        return;
//    }
    
    NSString *shareUrl = data[@"shareUrl"];
    [self saveValeu:shareUrl forKey:@"shareUrlKey"];
    self.openUrl = shareUrl;
}

#pragma mark - 6.1 加载合约涨背景图
- (void)loadContractProfitImage {

    if (![self.contractProfitBackground isKindOfClass:[NSString class]] || self.contractProfitBackground.length == 0) {
        self.profitImage = [UIImage imageNamed:@"shareMore"];
        return;
    }
    
    MJWeakSelf
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.contractProfitBackground] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (!error && image) {
            weakSelf.profitImage = image;
        } else {
            weakSelf.profitImage = [UIImage imageNamed:@"shareMore"];
        }
    }];
}

#pragma mark - 6.2 加载合约跌背景图
- (void)loadContractLossImage {
    
    if (![self.contractLossBackground isKindOfClass:[NSString class]] || self.contractLossBackground.length == 0) {
        self.lossImage = [UIImage imageNamed:@"shareNil"];
        return;
    }
    
    MJWeakSelf
    [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:self.contractLossBackground] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
        if (!error && image) {
            weakSelf.lossImage = image;
        } else {
            weakSelf.lossImage = [UIImage imageNamed:@"shareNil"];
        }
    }];
}

#pragma mark 存取方法
-(id)getValueForKey:(NSString*)key{
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}
-(void)saveValeu:(id)value forKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
