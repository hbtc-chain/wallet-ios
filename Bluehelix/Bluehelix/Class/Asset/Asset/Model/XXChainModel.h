//
//  XXChainModel.h
//  Bluehelix
//
//  Created by 袁振 on 2020/10/16.
//  Copyright © 2020 Bhex. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XXChainModel : NSObject

@property (nonatomic, copy) NSString *chain;
@property (nonatomic, copy) NSString *full_name;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, assign) BOOL single_coin;

- (XXChainModel *)initWithSymbol:(NSString *)symbol detailName:(NSString *)detailName typeName:(NSString *)typeName;
@end

NS_ASSUME_NONNULL_END
