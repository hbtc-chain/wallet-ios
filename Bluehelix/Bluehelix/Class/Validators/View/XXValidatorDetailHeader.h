//
//  XXValidatorDetailHeader.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/17.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXValidatorListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface XXValidatorDetailHeader : UITableViewHeaderFooterView
@property (nonatomic, strong) XXValidatorListModel *validatorModel;
/**有效或者无效*/
@end

NS_ASSUME_NONNULL_END
