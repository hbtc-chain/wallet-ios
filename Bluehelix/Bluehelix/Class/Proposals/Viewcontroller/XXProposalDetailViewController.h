//
//  XXProposalDetailViewController.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "BaseViewController.h"
#import "XXProposalPrefixHeader.h"
#import "XXProposalListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXProposalDetailViewController : BaseViewController
@property (nonatomic, assign) XXProposalStatusType proposalStatusType;
@property (nonatomic, strong) XXProposalModel *proposalModel;

@end

NS_ASSUME_NONNULL_END
