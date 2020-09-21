//
//  XYHPickerView.h
//  Black
//
//  Created by xuyiheng on 15/10/24.
//  Copyright © 2015年 徐恒. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef  void(^myBlock)(NSString *title, NSInteger index);


@interface XYHPickerView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) NSArray *namesArray;


+ (void)showPickerViewWithNamesArray:(NSArray *)names selectIndex:(NSInteger)selectIndex Block:(myBlock)block;


@end
