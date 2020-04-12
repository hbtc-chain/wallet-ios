
#import <Foundation/Foundation.h>

@interface HttpManager : NSObject

+ (instancetype)sharedHttpManager;

#pragma mark - ++++++++++++ 通用接口 ++++++++++++++
/**
 *  Get通用接口
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

/**
 *  Post通用接口
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block;

@end
