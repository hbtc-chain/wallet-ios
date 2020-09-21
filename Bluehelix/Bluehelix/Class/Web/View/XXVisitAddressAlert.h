//
//  XXVisitAddressAlert.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/9.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXVisitAddressAlert : UIView

@property (nonatomic, copy) void (^sureBlock)(void);
@property (nonatomic, copy) void (^rejectBlock)(void);

+ (void)showWithSureBlock:(void (^)(void))sureBlock rejectBlock:(void (^)(void))rejectBlock;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
