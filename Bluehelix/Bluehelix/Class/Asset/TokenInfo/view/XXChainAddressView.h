//
//  XXChainAddressView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/6.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXChainAddressView : UIView

+ (void)showWithAddress:(NSString *)address;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
