//
//  XXVoteActionView.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^XXVoteActionCallBlock) (NSString *voteString);
@interface XXVoteActionView : UIView
@property (nonatomic, copy) XXVoteActionCallBlock voteCallBlock;
/** 索引分时按钮  从0 开始计数*/
@property (assign, nonatomic) NSInteger indexBtn;

@property (nonatomic, strong) NSMutableArray *itemsArray;
@end

NS_ASSUME_NONNULL_END
