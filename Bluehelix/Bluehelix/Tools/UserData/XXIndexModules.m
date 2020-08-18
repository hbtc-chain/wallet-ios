//
//  XXIndexModules.m
//  Bhex
//
//  Created by Bhex on 2019/11/27.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXIndexModules.h"

@interface XXIndexModules ()

/** 【banners】数据字符串 */
@property (strong, nonatomic) NSString *bannersString;

/** 【九宫格、底部tabbar、homeLogo】数据字符串 */
@property (strong, nonatomic) NSString *dataString;

@end

@implementation XXIndexModules
singleton_implementation(XXIndexModules)

#pragma mark - 0. 读取缓存数据
- (void)readCache; {
    [self readCacheDataOfBanners];
    [self readCacheDataOfIndexModules];
}

#pragma mark - 1.0 读取首页大小banner数据
- (void)readCacheDataOfBanners {
    NSString *dataKey = [NSString stringWithFormat:@"%@%@", [[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode], @"HomeAllBanners"];
    self.bannersString = [self getValueForKey:dataKey];
    [self reloadDataOfBanners];
}

#pragma mark - 1.1 收到大小banner数据
- (void)didReceiveBanners:(id)data {
    NSString *dataString = [data mj_JSONString];
    if (![dataString isEqualToString:self.bannersString]) {
        NSString *dataKey = [NSString stringWithFormat:@"%@%@", [[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode], @"HomeAllBanners"];
        self.bannersString = dataString;
        [self saveValeu:self.bannersString forKey:dataKey];
        [self reloadDataOfBanners];
    }
}

#pragma mark - 1.2 刷新banner数据
- (void)reloadDataOfBanners {
    if (IsEmpty(self.bannersString)) {
        self.bigBannersArray = nil;
        self.smallBannersArray = nil;
        return;
    }
    
    NSDictionary *dataDict = [self.bannersString mj_JSONObject];
    NSArray *bigArray =  dataDict[@"banners"];
    NSMutableArray *bigs = [NSMutableArray array];
    for (NSInteger i=0; i < bigArray.count; i ++) {
        NSDictionary *dict = bigArray[i];
        XXIndexModel *model = [XXIndexModel new];
        model.defaultIcon = dict[@"imgUrl"];
        if (IsEmpty(model.defaultIcon)) {
            continue;
        }
        [bigs addObject:model];
        
        model.jumpUrl = dict[@"directUrl"];
        if (IsEmpty(model.jumpUrl)) {
            continue;
        }
        
        NSString *urlString = [model.jumpUrl uppercaseString];
        if ([urlString hasPrefix:@"PAGE"]) {
            model.jumpType = @"NATIVE";
        } else if ([model.jumpUrl hasPrefix:@"http"]) {
            model.jumpType = @"H5";
        } else if ([model.jumpUrl hasPrefix:@"/"]) {
            model.jumpType = @"PATH";
        }
    }
    
    NSArray *smallArray = dataDict[@"smallBanners"];
    NSMutableArray *smalls = [NSMutableArray array];
    for (NSInteger i=0; i < smallArray.count; i ++) {
        NSDictionary *dict = smallArray[i];
        XXIndexModel *model = [XXIndexModel new];
        model.defaultIcon = dict[@"imgUrl"];
        if (IsEmpty(model.defaultIcon)) {
            continue;
        }
        [smalls addObject:model];
        
        model.jumpUrl = dict[@"directUrl"];
        if (IsEmpty(model.jumpUrl)) {
            continue;
        }
        
        NSString *urlString = [model.jumpUrl uppercaseString];
        if ([urlString hasPrefix:@"PAGE"]) {
            model.jumpType = @"NATIVE";
        } else if ([model.jumpUrl hasPrefix:@"http"]) {
            model.jumpType = @"H5";
        } else if ([model.jumpUrl hasPrefix:@"/"]) {
            model.jumpType = @"PATH";
        }
    }
    
    self.bigBannersArray = bigs;
    self.smallBannersArray = smalls;
    if (self.bigBannerBlock) {
        self.bigBannerBlock();
    }
    
    if (self.smallBannerBlock) {
        self.smallBannerBlock();
    }
}

#pragma mark - 2.0 读取【九宫格、底部tabbar、homeLogo】数据
- (void)readCacheDataOfIndexModules {
    NSString *dataKey = [NSString stringWithFormat:@"%@%@", [[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode], KUser.isNightType ? @"2" : @"1"];
    self.dataString = [self getValueForKey:dataKey];
    [self reloadDataOfIndexModules];
}

#pragma mark - 2.1 收到【九宫格、底部tabbar、homeLogo】数据
- (void)didReceiveIndexModules:(id)data {
    NSString *dataString = [data mj_JSONString];
    if (![dataString isEqualToString:self.dataString]) {
        NSString *dataKey = [NSString stringWithFormat:@"%@%@", [[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode], KUser.isNightType ? @"2" : @"1"];
        self.dataString = dataString;
        [self saveValeu:self.dataString forKey:dataKey];
        [self reloadDataOfIndexModules];
    }
}

#pragma mark - 2.2 刷新九宫格、底部tabbar、homeLogo】数据
- (void)reloadDataOfIndexModules {
    if (IsEmpty(self.dataString)) {
        self.tabbarArray = nil;
        self.homeTopModel = nil;
        self.homeArray = nil;
        return;
    }
    NSDictionary *dataDict = [self.dataString mj_JSONObject];
    self.homeArray = [XXIndexModel mj_objectArrayWithKeyValuesArray:dataDict[@"type1"]];
    if (self.homeBlock) {
        self.homeBlock();
    }
    
    self.tabbarArray = [XXIndexModel mj_objectArrayWithKeyValuesArray:dataDict[@"type2"]];
    if (self.tabbarBlock) {
        self.tabbarBlock();
    }
    
    NSArray *hometopArray = [XXIndexModel mj_objectArrayWithKeyValuesArray:dataDict[@"type4"]];
    self.homeTopModel = hometopArray.firstObject;
    if (self.homeTopBlock) {
        self.homeTopBlock();
    }
}

#pragma mark - 3.1 收到【公告】数据
- (void)didReceiveAnnouncements:(id)data {
    self.announcements = data;
    if (self.announcementsBlock) {
        self.announcementsBlock();
    }
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
