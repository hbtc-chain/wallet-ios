//
//  XXAssetHeaderView.h
//  Bluehelix
//
//  Created by Bhex on 2020/03/18.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXAssetModel;
NS_ASSUME_NONNULL_BEGIN

@interface XXAssetHeaderView : UIView

@property (strong, nonatomic) void(^actionBlock)(void);

- (void)configData:(XXAssetModel *)model;

@end

NS_ASSUME_NONNULL_END
