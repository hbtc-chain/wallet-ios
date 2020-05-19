//
//  XXDepositAlert.h
//  Bluehelix
//
//  Created by BHEX on 2020/4/25.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXDepositAlert : UIView

+ (void)showWithMessage:(NSMutableAttributedString *)message;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
