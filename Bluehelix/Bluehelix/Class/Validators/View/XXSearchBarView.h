//
//  XXSearchBarView.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXSearchBarView : UIView
/** 搜索框 */
@property (strong, nonatomic) XXTextField *searchTextField;
/** 搜索图标 */
@property (strong, nonatomic) UIImageView *searchIconImageView;
@end

NS_ASSUME_NONNULL_END
