//
//  XXIndexModel.m
//  Bhex
//
//  Created by Bhex on 2019/11/5.
//  Copyright © 2019 Bhex. All rights reserved.
//

#import "XXIndexModel.h"
#import "XXTabBarController.h"

@implementation XXIndexModel

- (void)setJumpUrl:(NSString *)jumpUrl {
    _jumpUrl = jumpUrl;
    
    NSString *urlString = [jumpUrl uppercaseString];
    if ([urlString hasPrefix:@"PAGE"]) {
        self.dataDict = [NSMutableDictionary dictionary];
        NSArray *sumArray = [jumpUrl componentsSeparatedByString:@"&"];
        for (NSInteger i=0; i < sumArray.count; i ++) {
            NSString *subString = sumArray[i];
            NSArray *subArray = [subString componentsSeparatedByString:@"="];
            if (subArray.count != 2) {
                return;
            }
            NSString *key = subArray[0];
            NSString *value = subArray[1];
            [self.dataDict setValue:[value uppercaseString] forKey:[key uppercaseString]];
        }
    }
}

#pragma mark - 1. 跳转页面
- (void)pushViewController:(UIViewController *)controller {
    
}

#pragma mark - 6.2 提现操作
- (void)withdrawNext:(XXAssetModel *)model controller:(UIViewController *)controller {
}

#pragma mark - 6.3 是否含有二次验证
- (BOOL)isHave2FA {
   return NO;
}
@end
