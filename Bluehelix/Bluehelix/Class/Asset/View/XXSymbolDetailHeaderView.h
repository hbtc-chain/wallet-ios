//
//  XXSymbolDetailHeaderView.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/07.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XXTokenModel;
@class XXAssetModel;

NS_ASSUME_NONNULL_BEGIN

@interface XXSymbolDetailHeaderView : UIView

@property (nonatomic, strong) XXTokenModel *tokenModel;
@property (nonatomic, strong) XXAssetModel *assetModel;

@end

NS_ASSUME_NONNULL_END
