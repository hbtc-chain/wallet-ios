#define kNetworkMethodName @[@"Get", @"Post"]
#import "NetAPIClient.h"

@implementation NetAPIClient

static NetAPIClient *_sharedClient = nil;
static dispatch_once_t onceToken;

+ (NetAPIClient *)sharedJsonClient {
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetAPIClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
        [_sharedClient.requestSerializer setTimeoutInterval:15];
    });
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    self.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
    [self.requestSerializer setValue:[[LocalizeHelper sharedLocalSystem] getRequestHeaderLanguageCode] forHTTPHeaderField:@"local"];
    return self;
}

#pragma mark - 1. Post 或 get 网络请求
/**
 *  1. Post 或 get 网络请求
 *
 *  @param aPath  接口名
 *  @param params 请求体
 *  @param method 请求方式
 *  @param block  返回数据
 */
- (void)requestHttpWithPath:(NSString *)aPath withParams:(NSDictionary *)params withMethodType:(NetworkMethod)method andBlock:(void (^)(id data, NSString *msg, NSInteger code))block {
    
    if (!aPath || aPath.length <= 0) {
        return;
    }
    
    aPath = [aPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    NSLog(@"\n===========数据请求===========\nmethod:%@\naPath:%@\nparams%@", kNetworkMethodName[method], aPath, params);
    [self.requestSerializer setTimeoutInterval:15];
            
    //发起请求
    switch (method) {
        case Get:{
            [self GET:aPath parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]) {
                    block(data, @"网络请求正常！", 0);
                } else {
                    block(data, @"数据异常！", -1001);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                if (response) {
                    NSInteger statusCode = response.statusCode;
                    NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
                    block(nil, KString(dataDic[@"error"]), statusCode);
                } else {
                    NSLog(@"============非业务错误=========%@", error);
                    NSString *errorMsg = error.localizedDescription;
                    if (!IsEmpty(errorMsg)) {
                        block(nil, errorMsg, 10000);
                    } else {
                        block(nil, LocalizedString(@"NoNetworking"), 10000);
                    }
                }
            }];
            break;
        }
        case Post:{
            [self POST:aPath parameters:params headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                id data = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if ([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]) {
                    block(data, @"网络请求正常！", 0);
                } else {
                    block(data, @"数据异常！", -1001);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                if (response) {
                    NSInteger statusCode = response.statusCode;
                    NSDictionary *dataDic = [error.userInfo[@"com.alamofire.serialization.response.error.data"] mj_JSONObject];
                    block(nil, KString(dataDic[@"error"]), statusCode);
                } else {
                    NSLog(@"============非业务错误=========%@", error);
                    NSString *errorMsg = error.localizedDescription;
                    if (!IsEmpty(errorMsg)) {
                        block(nil, errorMsg, 10000);
                    } else {
                        block(nil, LocalizedString(@"NoNetworking"), 10000);
                    }
                }
            }];
            break;
        }
        default:
            break;
    }
}
@end
