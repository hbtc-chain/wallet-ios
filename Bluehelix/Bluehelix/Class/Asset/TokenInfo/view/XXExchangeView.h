//
//  XXExchangeView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXFloadtTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXExchangeView : UIView

@property (nonatomic, strong) XXFloadtTextField *leftField;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) void (^sureBlock)(BOOL mainTokenFlag);

@end

NS_ASSUME_NONNULL_END
