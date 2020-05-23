//
//  XXMessageSegmentButton.h
//  Bluehelix
//
//  Created by 袁振 on 2020/5/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMessageSegmentButton : UIButton

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
- (void)setLeftLabelText:(NSString *)text;

- (void)setRightLabelText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
