//
//  XXValidatorHeaderView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXAssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXValidatorHeaderView : UIView

@property (nonatomic, strong) XXAssetModel *assetModel;

@property (nonatomic, strong) NSArray *delegations; //委托列表

@property (nonatomic, copy) void(^getRewardBlock) (void);
@end

NS_ASSUME_NONNULL_END
