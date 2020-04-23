//
//  XXServiceAgreementVC.h
//  Bluehelix
//
//  Created by Bhex on 2020/03/21.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXServiceAgreementVC : BaseViewController

@property (nonatomic, copy) void(^readBlock)(BOOL agreeFlag);

@end

NS_ASSUME_NONNULL_END
