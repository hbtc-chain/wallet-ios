//
//  XYHAlertView.m
//  actionSheet
//
//  Created by 徐义恒 on 17/4/18.
//  Copyright © 2017年 徐义恒. All rights reserved.
//

#import "XYHAlertView.h"
#import "UIAlertAction+index.h"

#define ActionColor (KSystem.isDarkStyle ? [UIColor whiteColor] : [UIColor blackColor])

@implementation XYHAlertView

+ (void)showSheetViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block {

    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];

    for (NSInteger i=0; i < titles.count; i ++) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            block(action.indexTap);
             window.hidden = YES;
        }];
        action.indexTap = i;
        [action setValue:ActionColor forKey:@"titleTextColor"];
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:LocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
         window.hidden = YES;
    }];
    [action setValue:ActionColor forKey:@"titleTextColor"];
    [alert addAction:action];
    
    // 修改字体大小
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:kFontBold18];
 
    [window makeKeyAndVisible];
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showSheetViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block cancelBlock:(void(^)(void))cancelBlock {
    
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (NSInteger i=0; i < titles.count; i ++) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            block(action.indexTap);
            window.hidden = YES;
        }];
        action.indexTap = i;
        [action setValue:ActionColor forKey:@"titleTextColor"];
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:LocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        window.hidden = YES;
        cancelBlock();
    }];
    [action setValue:ActionColor forKey:@"titleTextColor"];
    [alert addAction:action];
    
    // 修改字体大小
    UILabel *appearanceLabel = [UILabel appearanceWhenContainedIn:UIAlertController.class, nil];
    [appearanceLabel setAppearanceFont:kFontBold18];
    
    [window makeKeyAndVisible];
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block{
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.windowLevel = UIWindowLevelAlert + 1;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSInteger i=0; i < titles.count; i ++) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            block(action.indexTap);
            window.hidden = YES;
        }];
        action.indexTap = i;
        [alert addAction:action];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:LocalizedString(@"Cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        window.hidden = YES;
    }];
    [alert addAction:action];

    [window makeKeyAndVisible];
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showNoCancelAlertViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block {
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.windowLevel = UIWindowLevelAlert + 1;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentLeft;
    NSMutableAttributedString *atrStr = [[NSMutableAttributedString alloc] initWithString:[message lowercaseString] attributes:@{NSParagraphStyleAttributeName:paraStyle,NSFontAttributeName:[UIFont systemFontOfSize:13.0]}];
    [alert setValue:atrStr forKey:@"attributedMessage"];
    
    for (NSInteger i=0; i < titles.count; i ++) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            block(action.indexTap);
            window.hidden = YES;
        }];
        action.indexTap = i;
        [alert addAction:action];
    }
    
    [window makeKeyAndVisible];
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showAlertContentCenterViewWithTitle:(NSString *)title message:(NSString *)message titlesArray:(NSArray *)titles andBlock:(void(^)(NSInteger index))block {
    UIWindow* window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    window.rootViewController = [UIViewController new];
    window.windowLevel = UIWindowLevelAlert + 1;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    for (NSInteger i=0; i < titles.count; i ++) {
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            block(action.indexTap);
            window.hidden = YES;
        }];
        action.indexTap = i;
        [alert addAction:action];
    }
    [window makeKeyAndVisible];
    [window.rootViewController presentViewController:alert animated:YES completion:nil];
}

@end
