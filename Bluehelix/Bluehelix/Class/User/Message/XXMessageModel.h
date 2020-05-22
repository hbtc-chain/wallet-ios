//
//  XXMessageModel.h
//  Bluehelix
//
//  Created by 袁振 on 2020/5/22.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXMessageModel : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, strong) NSNumber *tx_type;
@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *tx_hash;
@property (nonatomic, assign) BOOL read;

@end

NS_ASSUME_NONNULL_END
