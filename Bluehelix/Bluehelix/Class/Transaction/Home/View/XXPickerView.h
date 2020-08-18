//
//  XXPickerView.h
//  Bhex
//
//  Created by Bhex on 2018/9/9.
//  Copyright © 2018年 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXPickerView : UIView

+ (void)showPickerViewDataArray:(NSMutableArray *)dataArray
                           row0:(NSInteger)row0
                           row1:(NSInteger)row1
                          block:(void(^)(NSInteger row0, NSInteger row1))block;


@end
