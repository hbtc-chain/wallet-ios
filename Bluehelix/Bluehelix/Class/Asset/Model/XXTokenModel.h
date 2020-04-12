//
//  XXTokenModel.h
//  Bluehelix
//
//  Created by Bhex on 2020/04/03.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXTokenModel : NSObject

@property (nonatomic, strong) NSString *chain;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *amount;
@property (nonatomic, strong) NSString *enable_sendtx;
@property (nonatomic, strong) NSString *external_address;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) int decimals;
@property (nonatomic, assign) BOOL is_native;

@end

NS_ASSUME_NONNULL_END
