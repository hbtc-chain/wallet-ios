//
//  XXValidarorDetailDelegateBar.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^TransferDelegateButtonActionBlock)(void);
typedef void (^RelieveDelegateButtonActionBlock)(void);
typedef void (^DelegateButtonActionBlock)(void);
@interface XXValidarorDetailDelegateBar : UIView
@property (nonatomic, copy) TransferDelegateButtonActionBlock transferDelegateBlock;

@property (nonatomic, copy) RelieveDelegateButtonActionBlock relieveDelegateBlock;

@property (nonatomic, copy) DelegateButtonActionBlock delegateBlock;


@end

NS_ASSUME_NONNULL_END
