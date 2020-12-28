//
//  XXSetPasswordNumTextFieldView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/2.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXSetPasswordNumTextFieldView : UIView

@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) void(^finishBlock)(NSString *text);

@end

NS_ASSUME_NONNULL_END
