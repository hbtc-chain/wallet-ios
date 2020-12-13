//
//  XXNoticeView.h
//  Bluehelix
//
//  Created by 袁振 on 2020/12/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXNoticeView : UIView
@property (nonatomic, strong) NSArray *data;
- (void)reloadData:(NSArray *)data;
@end

NS_ASSUME_NONNULL_END
