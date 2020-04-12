//
//  XXSecurityAlertView.h
//  Bluehelix
//
//  Created by Bhex on 2020/03/21.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXSecurityAlertView : UIView

@property (nonatomic, copy) void (^sureBlock)(void);
@property (nonatomic, copy) void (^cancelBlock)(void);

+ (void)showWithSureBlock:(void (^)(void))sureBlock;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
