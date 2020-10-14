//
//  XXTransactionCell.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTransactionCell : UITableViewCell

- (void)configData:(NSDictionary *)dic symbol:(NSString *)symbol;
@end

NS_ASSUME_NONNULL_END
