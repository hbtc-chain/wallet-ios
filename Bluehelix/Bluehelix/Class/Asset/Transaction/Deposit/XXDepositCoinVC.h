//
//  XXDepositCoinVC.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/06.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXTokenModel;
NS_ASSUME_NONNULL_BEGIN

@interface XXDepositCoinVC : BaseViewController

@property (nonatomic, strong) XXTokenModel *tokenModel;
@property (nonatomic, assign) BOOL InnerChain; //链内

@end

NS_ASSUME_NONNULL_END
