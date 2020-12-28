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

@property (nonatomic, copy) void (^sureBtnBlock)(NSString *text);

+ (void)showWithSureBtnBlock:(void (^)(NSString *text))sureBtnBlock;

+ (void)showWithContent:(NSString *)content sureBtnBlock:(void (^)(NSString *text))sureBtnBlock;

@end

NS_ASSUME_NONNULL_END
