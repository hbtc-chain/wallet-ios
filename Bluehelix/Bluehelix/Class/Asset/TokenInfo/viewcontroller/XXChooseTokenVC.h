//
//  XXChooseTokenVC.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXChooseTokenVC : BaseViewController

@property (nonatomic, assign) BOOL filterNativeChainFlag; //过滤原生代币
@property (nonatomic, copy) void (^changeSymbolBlock)(NSString *symbol);

@end

NS_ASSUME_NONNULL_END
