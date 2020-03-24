//
//  XXMnemonicBtn.h
//  Bluehelix
//
//  Created by 袁振 on 2020/03/09.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MnemonicBtnType) {
    MnemonicBtnType_Normal = 1,
    MnemonicBtnType_Selected,
    MnemonicBtnType_Wrong,
};

@interface XXMnemonicBtn : UIView

- (instancetype)initWithFrame:(CGRect)frame order:(NSString *)order dic:(NSDictionary *)dic;

@property (nonatomic, assign) MnemonicBtnType state;
@property (nonatomic, copy) NSDictionary *dic;
@property (nonatomic, copy) NSString *order;
@property (nonatomic, copy) void(^clickBlock)(NSDictionary *dic, XXMnemonicBtn *btn);

@property (nonatomic, strong) XXLabel *orderLabel;
@end

NS_ASSUME_NONNULL_END
