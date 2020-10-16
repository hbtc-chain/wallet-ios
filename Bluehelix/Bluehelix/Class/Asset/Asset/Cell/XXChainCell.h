//
//  XXChainCell.h
//  Bluehelix
//
//  Created by 袁振 on 2020/9/3.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXChainModel;

NS_ASSUME_NONNULL_BEGIN

@interface XXChainCell : UITableViewCell

- (void)configData:(XXChainModel *)model;

@end

NS_ASSUME_NONNULL_END
