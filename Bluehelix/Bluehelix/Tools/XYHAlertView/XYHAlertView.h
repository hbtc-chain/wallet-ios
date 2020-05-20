//
//  XYHAlertView.h
//  actionSheet
//
//  Created by 徐义恒 on 17/4/18.
//  Copyright © 2017年 徐义恒. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XYHAlertView : NSObject

+ (void)showSheetViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block;

+ (void)showSheetViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block cancelBlock:(void(^)(void))cancelBlock;

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block;

+ (void)showNoCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block;

+ (void)showAlertContentCenterViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block;
@end
