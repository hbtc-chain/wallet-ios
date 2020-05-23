//
//  XXMessageSegmentView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/5/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^XXToolbarSelectCallBack)(NSInteger index);
@interface XXMessageSegmentView : UIView

/** 索引分时按钮  从0 开始计数*/
@property (assign, nonatomic) NSInteger indexBtn;

/** 按钮数组 */
@property (strong, nonatomic) NSMutableArray *itemsArray;

/**选择回调*/
@property (nonatomic, copy) XXToolbarSelectCallBack ToolbarSelectCallBack;


/**是否有下标*/
@property (nonatomic, assign) BOOL isHaveIndexLine;

- (void)setUnreadNum:(NSNumber *)unreadNum buttonIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
