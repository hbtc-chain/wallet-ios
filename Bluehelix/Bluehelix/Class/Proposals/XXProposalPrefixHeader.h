//
//  XXProposalPrefixHeader.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/24.
//  Copyright © 2020 Bhex. All rights reserved.
//

#ifndef XXProposalPrefixHeader_h
#define XXProposalPrefixHeader_h
/**提案状态*/
typedef NS_ENUM(NSInteger, XXProposalStatusType) {
    XXProposalStatusTypeRaising = 1,//充值中 质押募集中
    XXProposalStatusTypeVoting = 2,//投票中
    XXProposalStatusTypeVotePass = 3,//通过
    XXProposalStatusTypeVoteReject = 4,//拒绝
    XXProposalStatusTypeRaiseFailed = 5,//移除 募集失败
};

#endif /* XXProposalPrefixHeader_h */
