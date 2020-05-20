//
//  UIAlertAction+index.m
//  actionSheet
//
//  Created by 徐义恒 on 17/4/18.
//  Copyright © 2017年 徐义恒. All rights reserved.
//

#import "UIAlertAction+index.h"

#import <objc/runtime.h>

@implementation UIAlertAction (index)
static NSInteger indexTapKey;//类似于一个中转站,参考

- (void)setIndexTap:(NSInteger)indexTap {
    
    objc_setAssociatedObject(self, &indexTapKey, @(indexTap), OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}


- (NSInteger)indexTap {
    
    return [objc_getAssociatedObject(self, &indexTapKey) integerValue];
}

@end
