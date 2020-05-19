//
//  XXLoginCell.h
//  Bluehelix
//
//  Created by 袁振 on 2020/5/12.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXLoginCell : UITableViewCell

@property (strong, nonatomic) XXLabel *nameLabel;
@property (strong, nonatomic) XXLabel *addressLabel;
@property (strong, nonatomic) UIView *lineView;

@end

NS_ASSUME_NONNULL_END
