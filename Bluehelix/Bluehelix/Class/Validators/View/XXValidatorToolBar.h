//
//  XXValidatorToolBar.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^XXToolbarSelectCallBack)(NSInteger index);
@interface XXValidatorToolBar : UIView
/** 索引分时按钮  从0 开始计数*/
@property (assign, nonatomic) NSInteger indexBtn;

/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *itemsArray;

/**选择回调*/
@property (nonatomic, copy) XXToolbarSelectCallBack ToolbarSelectCallBack;


/**是否有下标*/
@property (nonatomic, assign) BOOL isHaveIndexLine;
@end

NS_ASSUME_NONNULL_END
