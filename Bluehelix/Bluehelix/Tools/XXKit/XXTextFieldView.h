//
//  XXTextFieldView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/03/15.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTextFieldView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) XXButton *lookButton;

@property (nonatomic, assign) BOOL showLookBtn;
@property (nonatomic, strong) NSString *placeholder;
@end

NS_ASSUME_NONNULL_END
