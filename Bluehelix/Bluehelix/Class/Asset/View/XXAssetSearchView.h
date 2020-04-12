//
//  XXAssetSearchView.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/03.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXAssetSearchView : UIView

/** 隐藏小币种 */
@property (strong, nonatomic) XXButton *hidenSmallButton;

/** 搜索框 */
@property (strong, nonatomic) XXTextField *searchTextField;

/** 是否隐藏回调刷新 */
@property (strong, nonatomic) void(^actionBlock)(void);

@end

NS_ASSUME_NONNULL_END
