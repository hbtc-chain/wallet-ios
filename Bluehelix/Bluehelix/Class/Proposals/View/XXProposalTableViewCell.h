//
//  XXProposalTableViewCell.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXProposalListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface XXProposalTableViewCell : UITableViewCell
- (void)loadDataWithModel:(XXProposalModel*)proposalModel;
@end

NS_ASSUME_NONNULL_END
