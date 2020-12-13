//
//  XXChangeMapTokenView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/10/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXMappingModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXChangeMapTokenView : UIView

@property (nonatomic, copy) void (^sureBlock)(XXMappingModel *model);
@property (nonatomic, copy) void (^cancelBlock)(void);

+ (void)showWithSureBlock:(void (^)(XXMappingModel *model))sureBlock;

+ (void)showWithTargetSymbol:(NSString *)symbol sureBlock:(void (^)(XXMappingModel *model))sureBlock;

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
