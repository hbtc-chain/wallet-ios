//
//  XYHUserInfoView.h
//  WanRenHui
//
//  Created by 徐义恒 on 2017/6/19.
//  Copyright © 2017年 gansbat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XXUserHeaderView : UIView

/** 昵称 */
@property (strong, nonatomic) XXLabel *nikeLabel;

/** 刷新标签 */
- (void)reloadMark:(NSArray *)marksArray;
@end
