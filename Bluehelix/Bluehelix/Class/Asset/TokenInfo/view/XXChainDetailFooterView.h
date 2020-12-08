//
//  XXChainDetailFooterView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/4.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXTokenModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXChainDetailFooterView : UIView

@property (nonatomic, strong) NSString *chain;
@property (nonatomic, copy) void (^actionBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
