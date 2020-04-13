//
//  XXAssetCell.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/02.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXTokenModel;
NS_ASSUME_NONNULL_BEGIN

@interface XXAssetCell : UITableViewCell

- (void)configData:(XXTokenModel *)model;

@end

NS_ASSUME_NONNULL_END
