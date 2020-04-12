//
//  XXAccountCell.h
//  Bluehelix
//
//  Created by Bhex on 2020/03/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXAccountModel;
NS_ASSUME_NONNULL_BEGIN

@interface XXAccountCell : UITableViewCell

- (void)configData:(XXAccountModel *)model;

@end

NS_ASSUME_NONNULL_END
