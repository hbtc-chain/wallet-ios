//
//  XXPasswordView.h
//  Bluehelix
//
//  Created by Bhex on 2020/03/19.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXPasswordView : UIView

@property (nonatomic, copy) void (^sureBtnBlock)(void);

+ (void)showWithSureBtnBlock:(void (^)(void))sureBtnBlock;

+ (void)showWithContent:(NSString *)content sureBtnBlock:(void (^)(void))sureBtnBlock;

@end

NS_ASSUME_NONNULL_END
