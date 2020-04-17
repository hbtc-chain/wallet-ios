//
//  XXValidatorDetailCell.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/17.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXValidatorDetailCell : UITableViewCell

@property (nonatomic, strong) XXLabel *labelInfo;

@property (nonatomic, strong) XXLabel *labelValue;

@property (nonatomic, strong) XXButton *rightDetailButton;

@property (nonatomic, assign) BOOL hideDetailButton;
@end

NS_ASSUME_NONNULL_END
