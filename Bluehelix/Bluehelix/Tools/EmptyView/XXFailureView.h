//
//  XXFailureView.h
//  Bhex
//
//  Created by Bhex on 2019/8/9.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXFailureView : UIView

/** 重新加载 */
@property (strong, nonatomic) void(^reloadBlock)(void);

/** 标签 */
@property (strong, nonatomic) XXLabel *msgLabel;
@end

NS_ASSUME_NONNULL_END
