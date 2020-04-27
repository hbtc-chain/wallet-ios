//
//  XXProposalGripSectionHeader.h
//  Bluehelix
//
//  Created by xu Lance on 2020/4/23.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSearchBarView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^XXTextFieldValueChangeCallBack)(NSString *textfiledText);
@interface XXProposalGripSectionHeader : UITableViewHeaderFooterView
/**输入框回调*/
@property (nonatomic, copy) XXTextFieldValueChangeCallBack textfieldValueChangeBlock;
@property (nonatomic, strong) XXSearchBarView *searchView;
@end

NS_ASSUME_NONNULL_END
