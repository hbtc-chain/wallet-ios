//
//  XXMarketSearchVC.h
//  Bhex
//
//  Created by BHEX on 2018/7/1.
//  Copyright © 2018年 BHEX. All rights reserved.
//

#import "BaseViewController.h"

@interface XXBitcoinSearchVC : BaseViewController

/** 回调币对 */
@property (strong, nonatomic) void(^searchSymbolBlock)(id model);

@end
