//
//  XXValidatorCell.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/13.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXValidatorListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXValidatorCell : UITableViewCell

- (void)loadData:(XXValidatorListModel*)model;

@end

NS_ASSUME_NONNULL_END
