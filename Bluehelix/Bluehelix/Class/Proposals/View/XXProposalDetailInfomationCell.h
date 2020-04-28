//
//  XXProposalDetailInfomationCell.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/27.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXProposalDetailInfomationCell : UITableViewCell
//title
@property (nonatomic, strong) XXLabel *detailLabelInfo;
//detail
@property (nonatomic, strong) UITextView *detailLabelValue;
@end

NS_ASSUME_NONNULL_END
