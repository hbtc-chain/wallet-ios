//
//  XXAssetCell.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/02.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
@class XXTokenModel;
NS_ASSUME_NONNULL_BEGIN

@interface XXAssetCell : SWTableViewCell

- (void)configData:(XXTokenModel *)model;

@end

NS_ASSUME_NONNULL_END
