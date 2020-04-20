//
//  XXAccountBtn.h
//  Bluehelix
//
//  Created by Bhex on 2020/03/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^Block)(void);
@interface XXAccountBtn : UIView

- (instancetype)initWithFrame:(CGRect)frame block:(Block)block;

@end

NS_ASSUME_NONNULL_END
