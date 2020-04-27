//
//  XXProposalListModel.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XXProposalPrefixHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXProposalListModel : NSObject
@property (nonatomic, assign) NSNumber *page;
@property (nonatomic, assign) NSNumber *page_size;
@property (nonatomic, assign) NSNumber *total;
@property (nonatomic, copy) NSArray *proposals;
@end

@class XXProposalResultModel;
@interface XXProposalModel : NSObject
@property (nonatomic, copy) NSString *proposalId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *proposer;
@property (nonatomic, copy) NSString *proposalDescription;
@property (nonatomic, copy) NSString *submit_time;
@property (nonatomic, copy) NSString *deposit_end_time;
@property (nonatomic, copy) NSString *voting_start_time;
@property (nonatomic, copy) NSString *voting_end_time;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *total_deposit;
@property (nonatomic, copy) NSString *deposit_threshold;
@property (nonatomic, copy) NSString *voting_proportion;
@property (nonatomic, strong) XXProposalResultModel *result;

@property (nonatomic, assign) XXProposalStatusType proposalStatusType;

@end
@interface XXProposalResultModel : NSObject
@property (nonatomic, copy) NSString *yes;
@property (nonatomic, copy) NSString *no;
@property (nonatomic, copy) NSString *no_with_veto;
@property (nonatomic, copy) NSString *abstain;
@end
NS_ASSUME_NONNULL_END
