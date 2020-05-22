//
//  XXTransferHeaderView.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/10.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTransferHeaderView : UIView

- (void)buildUI:(NSDictionary *)dic;
@property (nonatomic, strong) XXLabel *amountLabel;
@property (nonatomic, assign) CGFloat maxHeight;
@end

NS_ASSUME_NONNULL_END
