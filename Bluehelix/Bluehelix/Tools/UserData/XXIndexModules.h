//
//  XXIndexModules.h
//  Bhex
//
//  Created by Bhex on 2019/11/27.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "XXIndexModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXIndexModules : NSObject
singleton_interface(XXIndexModules)

/** 读取缓存数据 */
- (void)readCache;

#pragma mark - 1.【大小banner】数据
/** 大banner数组 */
@property (strong, nonatomic, nullable) NSMutableArray *bigBannersArray;

/** 大banner回调刷新 */
@property (strong, nonatomic, nullable) void(^bigBannerBlock)(void);

/** 小banner数组 */
@property (strong, nonatomic, nullable) NSMutableArray *smallBannersArray;

/** 小banner回调刷新 */
@property (strong, nonatomic, nullable) void(^smallBannerBlock)(void);

#pragma mark - 1.1 收到大小banner数据
- (void)didReceiveBanners:(id)data;

#pragma mark - 2.【九宫格、底部tabbar、homeLogo】数据
/** tabbar数组 */
@property (strong, nonatomic, nullable) NSMutableArray *tabbarArray;

/** tabbarBlock */
@property (strong, nonatomic, nullable) void(^tabbarBlock)(void);

/** 首页头部图标 */
@property (strong, nonatomic, nullable) XXIndexModel *homeTopModel;

/** 首页头部回调 */
@property (strong, nonatomic, nullable) void(^homeTopBlock)(void);

/** 首页九宫格数组 */
@property (strong, nonatomic, nullable) NSMutableArray *homeArray;

/** 首页九宫格回调 */
@property (strong, nonatomic, nullable) void(^homeBlock)(void);

#pragma mark - 2.1 收到【九宫格、底部tabbar、homeLogo】数据
- (void)didReceiveIndexModules:(id)data;

#pragma mark - 3. 【公告】数据
/** 公告数组 */
@property (strong, nonatomic, nullable) NSArray *announcements;

/** 首页公告回调 */
@property (strong, nonatomic, nullable) void(^announcementsBlock)(void);

#pragma mark - 3.1 收到【公告】数据
- (void)didReceiveAnnouncements:(id)data;
@end

NS_ASSUME_NONNULL_END
