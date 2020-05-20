//
//  UIAlertAction+index.h
//  actionSheet
//
//  Created by 徐义恒 on 17/4/18.
//  Copyright © 2017年 徐义恒. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertAction (index)

/*
 * 1. 索引
 */
@property (assign, nonatomic) NSInteger indexTap;

- (void)setIndexTap:(NSInteger)indexTap;

- (NSInteger)indexTap;

@end
