//
//  XXExchangeView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXFloadtTextField.h"
#import "XXMappingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXExchangeView : UIView

@property (nonatomic, strong) XXFloadtTextField *leftField;

@property (nonatomic, strong) XXMappingModel *mappingModel;
@property (nonatomic, copy) void (^sureBlock)(void);

@end

NS_ASSUME_NONNULL_END
