//
//  XXMessageCell.h
//  Bluehelix
//
//  Created by 袁振 on 2020/5/22.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXMessageModel;
NS_ASSUME_NONNULL_BEGIN

@interface XXMessageCell : UITableViewCell

- (void)configData:(XXMessageModel *)model;

@end

NS_ASSUME_NONNULL_END
