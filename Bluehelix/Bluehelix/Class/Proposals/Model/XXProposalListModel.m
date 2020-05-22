//
//  XXProposalListModel.m
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import "XXProposalListModel.h"

@implementation XXProposalListModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"items" : [XXProposalModel class]};
}
@end

@implementation XXProposalModel

//+ (NSDictionary *)mj_objectClassInArray{
//    return @{@"result" : [XXProposalResultModel class]};
//}
+ (NSDictionary*)mj_replacedKeyFromPropertyName{
    return @{@"proposalId":@"id",
             @"proposalDescription" :@"description",
             @"proposalStatusType" :@"status",
    };
    
}
@end

@implementation XXProposalResultModel


@end
