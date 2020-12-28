//
//  XXWebViewController.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXWebViewController : BaseViewController
/** 接口地址 */
@property (strong, nonatomic) NSString *urlString;

/** 标题 */
@property (strong, nonatomic) NSString *navTitle;

/** 页面消失 */
@property (strong, nonatomic) void(^dismissBlock)(void);

@end

NS_ASSUME_NONNULL_END
