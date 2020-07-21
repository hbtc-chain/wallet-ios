//
//  XXMnemonicWordTextFieldView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/7/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, MnemonicWordTextFieldViewType) {
    MnemonicWordTextFieldViewType_Normal = 1,
    MnemonicWordTextFieldViewType_Wrong,
};
@interface XXMnemonicWordTextFieldView : UIView

@property (nonatomic, strong) XXTextField *textField;
@property (nonatomic, assign) MnemonicWordTextFieldViewType type;
@property (nonatomic, assign) NSInteger index;

@end

NS_ASSUME_NONNULL_END
