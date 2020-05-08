//
//  XXUpdateVersionView.h
//  Bhex
//
//  Created by Bhex on 2020/02/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXUpdateVersionView : UIView

@property (nonatomic, copy) void (^sureBtnBlock)(void);
@property (nonatomic, copy) void (^cancelBtnBlock)(void);

+ (void)showWithUpdateVersionContent:(NSString *)content withSureBtnBlock:(void (^)(void))sureBtnBlock; //强制升级

+ (void)showWithUpdateVersionContent:(NSString *)content withSureBtnBlock:(void (^)(void))sureBtnBlock withCancelBtnBlock:(void (^)(void))cancelBtnBlock; //升级

+ (void)dismiss;

@end

NS_ASSUME_NONNULL_END
