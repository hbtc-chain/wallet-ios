//
//  BHFaceIDLockVC.h
//  Bhex
//
//  Created by Bhex on 2018/11/4.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BHFaceIDLockVC : BaseViewController

@property (nonatomic, copy) void(^completeBlock)(void);

@end

NS_ASSUME_NONNULL_END
