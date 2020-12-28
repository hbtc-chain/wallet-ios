//
//  XXChooseTokenHeaderView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXChooseTokenHeaderView : UIView

@property (strong, nonatomic) XXTextField *searchTextField;
@property (nonatomic, copy) void (^sortBlock)(void);

@end

NS_ASSUME_NONNULL_END
