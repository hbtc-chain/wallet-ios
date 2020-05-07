//
//  XXValidatorGripSectionHeader.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXValidatorToolBar.h"
#import "XXSearchBarView.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^XXSelectValidOrInvalidCallBack)(NSInteger index);
typedef void(^XXTextFieldValueChangeCallBack)(NSString *textfiledText);
@interface XXValidatorGripSectionHeader : UITableViewHeaderFooterView
/**输入框回调*/
@property (nonatomic, copy) XXTextFieldValueChangeCallBack textfieldValueChangeBlock;
/**选择回调*/
@property (nonatomic, copy) XXSelectValidOrInvalidCallBack selectValidOrInvalidCallBack;

@property (nonatomic, strong) XXValidatorToolBar *validatorToolBar;

@property (nonatomic, strong) XXSearchBarView *searchView;

@property (nonatomic, strong) UIView *coverView;
@end

NS_ASSUME_NONNULL_END
