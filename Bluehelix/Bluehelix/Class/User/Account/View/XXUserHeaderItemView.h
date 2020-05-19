//
//  XXUserHeaderItemView.h
//  Bluehelix
//
//  Created by BHEX on 2020/5/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXUserHeaderItemView : UIView

@property (nonatomic, strong) CALayer *shadowLayer;
@property (nonatomic, strong) XXLabel *nameLabel;
@property (nonatomic, strong) UIImageView *icon;

@property (nonatomic, copy) void(^block)(void);
@end

NS_ASSUME_NONNULL_END
