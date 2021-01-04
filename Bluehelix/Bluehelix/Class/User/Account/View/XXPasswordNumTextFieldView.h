//
//  XXPasswordNumTextFieldView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/1.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXPasswordNumTextFieldView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^finishBlock)(NSString *text);

- (void)cleanText; //清空输入的密码
@end

NS_ASSUME_NONNULL_END
