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

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *detailName;
@property (nonatomic, copy) NSString *typeName;

- (XXChainModel *)initWithSymbol:(NSString *)symbol detailName:(NSString *)detailName typeName:(NSString *)typeName;
@end

NS_ASSUME_NONNULL_END
