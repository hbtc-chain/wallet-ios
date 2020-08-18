//
//  XXShareInfoModel.h
//  Bhex
//
//  Created by Bhex on 2019/7/8.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXShareInfoModel : NSObject

/** logo图片地址 */
@property (strong, nonatomic) NSString *logoUrl;
@property (strong, nonatomic) UIImage *logoImage;
/** 更新logo */
@property (strong, nonatomic) void(^logoBlock)(void);

/** 水印图片地址 */
@property (strong, nonatomic) NSString *watermarkImageUrl;
@property (strong, nonatomic) UIImage *watermarkImage;

/** 更新水印 */
@property (strong, nonatomic) void(^watermarkBlock)(void);

/** 行情分享标题 */
@property (strong, nonatomic) NSString *title;

/** 子标题 @"description" */
@property (strong, nonatomic) NSString *subTitle;

/** 打开链接【未登录是app下载地址、已登录是邀请链接】 */
@property (strong, nonatomic) NSString *openUrl;
@property (strong, nonatomic) void(^shareInfoBlock)(void);

/** 【合约分享】涨标题数组 */
@property (strong, nonatomic, nullable) NSArray *contractProfitShareTitles;

/** 【合约分享】不涨不跌标题数组 */
@property (strong, nonatomic, nullable) NSArray *contractZeroShareTitles;

/** 【合约分享】跌标题数组 */
@property (strong, nonatomic, nullable) NSArray *contractLossShareTitles;

/** 【合约分享】涨背景图 */
@property (strong, nonatomic, nullable) NSString *contractProfitBackground;
@property (strong, nonatomic, nullable) UIImage *profitImage;

/** 【合约分享】跌背景图 */
@property (strong, nonatomic, nullable) NSString *contractLossBackground;
@property (strong, nonatomic, nullable) UIImage *lossImage;

/** 1. 收到分享配置信息 */
- (void)didReceiveShareConfig:(NSDictionary *)data;

/** 2. 收到邀请链接 */
- (void)didReceiveInvitationShareUrl:(NSDictionary *)data;
@end

NS_ASSUME_NONNULL_END
