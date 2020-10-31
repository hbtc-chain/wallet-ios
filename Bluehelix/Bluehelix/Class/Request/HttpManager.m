

#import "HttpManager.h"
#import "NetAPIClient.h"

@implementation HttpManager

+ (instancetype)sharedHttpManager {
    static HttpManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
    });
    return shared_manager;
}

#pragma mark - ++++++++++++ 通用接口 ++++++++++++++
/**
 *  Get通用接口
 */
+ (void)getWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@", kServerUrl, path] withParams:params withMethodType:Get andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}

/**
 *  Post通用接口
 */
+ (void)postWithPath:(NSString *)path params:(NSDictionary *)params andBlock:(void(^)(id data, NSString *msg, NSInteger code))block {
    
    [[NetAPIClient sharedJsonClient] requestHttpWithPath:[NSString stringWithFormat:@"%@%@", kServerUrl, path] withParams:params withMethodType:Post andBlock:^(id data, NSString *msg, NSInteger code) {
        block(data, msg, code);
    }];
}
@end
