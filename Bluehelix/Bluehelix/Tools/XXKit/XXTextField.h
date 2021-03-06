//
//  XXTextField.h
//  Demo
//
//  Created by Bhex on 2019/7/25.
//  Copyright © 2019 徐义恒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KeyInputTextFieldDelegate <NSObject>

@optional
- (void)deleteBackward:(UITextField*)textField;

@end

@interface XXTextField : UITextField

@property (nonatomic, assign) id <KeyInputTextFieldDelegate>keyInputDelegate;

/** 占位符颜色 */
@property (strong, nonatomic) UIColor *placeholderColor;

/** 占位符字体 */
@property (strong, nonatomic) UIFont *placeholderFont;
@end

NS_ASSUME_NONNULL_END
