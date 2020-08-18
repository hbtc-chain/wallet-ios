//
//  XXFavoriteEditingCell.h
//  Bhex
//
//  Created by YiHeng on 2020/4/14.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXSymbolModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol XXFavoriteEditingCellDelegate <NSObject>

//** 选中 */
- (void)favoriteEditingCellDidSelectAtIndexPath:(NSIndexPath *)indexPath;

//** 置顶 */
- (void)favoriteEditingCellDidTopAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface XXFavoriteEditingCell : UITableViewCell

@property (strong, nonatomic, nullable) NSIndexPath *indexPath;
@property (strong, nonatomic, nullable) XXSymbolModel *model;

@property (weak, nonatomic, nullable) id<XXFavoriteEditingCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
