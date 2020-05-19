//
//  XXImportWayView.h
//  Bluehelix
//
//  Created by BHEX on 2020/4/20.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXImportWayView : UIView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(NSString *)imageName;
@property (nonatomic, copy) void (^clickBlock)(void);
@end

NS_ASSUME_NONNULL_END
