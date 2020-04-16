//
//  XXWithdrawChainVC.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXTokenModel;
NS_ASSUME_NONNULL_BEGIN

/// 跨链地址生成
@interface XXWithdrawChainVC : BaseViewController

@property (nonatomic, strong) XXTokenModel *tokenModel;

@end

NS_ASSUME_NONNULL_END
