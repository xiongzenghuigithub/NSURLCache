//request timeout
//http://stackoverflow.com/questions/8304560/how-to-set-a-timeout-with-afnetworking


#import "ApiClientManager.h"


@implementation ApiClientManager

+ (instancetype)sharedClientManager {
    static ApiClientManager *clientManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //1.
        clientManager = [[ApiClientManager alloc] init];
        
        //2.
        //根据宏编译，self.hostName
        /*
         *
         *  #ifdef App1
         *      clientManager.hostName = @"http://www.host1.com";
         *  #elseif
         *      clientManager.hostName = @"http://www.host2.com";
         *  #endif
         */
        clientManager.hostName = kHostName;
    });
    return clientManager;
}

- (void)dealloc {
    
    //停止网络监听
    [[[self requestOperationsManager] reachabilityManager] stopMonitoring];
    
    self.requestOperationsManager = nil;
    self.requestOperationsQueue = nil;
    
    self.operationQueueSuspendComplet = nil;
    self.networkChangedComplet = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
        //1.
        [self initVariables];
        
        //2.
        [self initAFHttpRequestOperationManager];
        
    }
    return self;
}

- (void)initVariables {

}

/**
 *  初始化AFHttpRequestOperationManager全局单例对象
 */
- (void)initAFHttpRequestOperationManager {
    
    //---------------------------------------------
    self.requestOperationsManager = [[XZHHttpRequestOperationManager alloc]
                                     initWithBaseURL:[NSURL URLWithString:self.hostName]
                                     ];
    

    
    //---------------------------------------------
    self.requestOperationsManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"text/plain", @"charset=UTF-8", @"application/json", nil];
    
    self.requestOperationsManager.requestSerializer.timeoutInterval = 15;
    
    self.requestOperationsQueue = [[self requestOperationsManager] operationQueue];
    
    //---------------------------------------------
    @weakify(self);
    [self.requestOperationsManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        @strongify(self);
        
        // 直接回传当前网路连接状态
       
        
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [self.requestOperationsQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [self.requestOperationsQueue setSuspended:YES];
                
                //执行回调Block

                
                break;
        }
    }];
    
    
    //---------------------------------------------
    [self.requestOperationsManager.reachabilityManager startMonitoring];
}

- (NSString *)getFullApiPath:(NSString *)childPath {
    NSString *fullPath = [NSString stringWithFormat:@"%@%@", self.hostName,childPath ];
    return fullPath;
}

- (AFHTTPRequestOperation *)operationWithMethod:(HttpRequestMethod) method
                                           Path:(NSString *) requetPath
                               ParamsDictionary:(NSDictionary *) paramDict
                                SuccessCallback:(void (^)(id responseObject)) successCallback
                                  ErrorCallback:(void (^)(NSNumber *errorCode, id cacheData)) errorCallback
                                   FailCallback:(void (^)(NSError *error, id cacheData)) failCallback
                              AutoRetryCallback:(void (^)(void)) autoRetry
                            UnReachableCallback:(void (^)(id responseObject)) unReachable
                                   UseCacheData:(BOOL)  isUse
                                   CacheExpirat:(NSTimeInterval) expirat
{
    
    NSError *error = nil;
    NSMutableURLRequest *mutableRequest = nil;
    __block AFHTTPRequestOperation *operation = nil;
    
    //---------------------------------------------
    
    switch (method) {
        
        case GET:{
            
            mutableRequest = [[[[self requestOperationsManager] requestSerializer]
                              requestWithMethod:@"GET"
                              URLString:[self getFullApiPath:requetPath]
                              parameters:paramDict
                              error:&error] mutableCopy];
            
            
            mutableRequest.timeoutInterval = 15;
        }
            
            break;
            
        case POST: {
            
            mutableRequest = [[[[self requestOperationsManager] requestSerializer]
                               requestWithMethod:@"POST"
                               URLString:[self getFullApiPath:requetPath]
                               parameters:paramDict
                               error:&error] mutableCopy];
            
            mutableRequest.timeoutInterval = 15;
        }
            
            
        default:{
            
            
        }
            break;
    }
    
    //-------------------- 网络连接不可达 -------------------------
    
    AFNetworkReachabilityManager *reachabilityManager = self.requestOperationsManager.reachabilityManager;

    if (![reachabilityManager isReachable]) {
        if(unReachable) {
            
            //返回缓存数据
            id cacheJSON = [ApiClientManager cachedResponseForRequest:mutableRequest];//查找缓存数据
            unReachable(cacheJSON);
        }
        return nil;
    }
    
    //--------------- request 缓存设置 ----------------
    if (isUse) {
        
        //设置调用NSURLCache的方法
        mutableRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        
        //设置request是否可以被缓存
        [mutableRequest setValue:@"YES" forHTTPHeaderField:URLCACHE_CACHE_KEY];
        
        //设置request的缓存超时限制
        [mutableRequest setValue:[NSString stringWithFormat:@"%f",expirat] forHTTPHeaderField:URLCACHE_EXPIRATION_AGE_KEY];
        
        //返回缓存数据
        id cacheJSON = [ApiClientManager cachedResponseForRequest:mutableRequest];
        if (successCallback) {
            successCallback(cacheJSON);
        }
        
        //返回的缓存数据位为空得情况
        //1. 还没有缓存数据
        //2. 缓存数据已经超时
        if (!cacheJSON) {
            
            operation = [[self requestOperationsManager]
                         HTTPRequestOperationWithRequest:mutableRequest
                         success:^(AFHTTPRequestOperation *operation, id responseObject)
                         {
                             
                             if (successCallback) {
                                 successCallback(responseObject);
                             }
                             
                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                             
                             //请求失败时，也返回缓存数据
                             if (failCallback) {
                                 failCallback(error, [ApiClientManager cachedResponseForRequest:[operation request]]);
                             }
                         }];
        }
        
    } else {
        
        //忽略缓存数据
        mutableRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        
        operation = [[self requestOperationsManager]
                     HTTPRequestOperationWithRequest:mutableRequest
                     success:^(AFHTTPRequestOperation *operation, id responseObject)
                     {
                         
                         if (successCallback) {
                             successCallback(responseObject);
                         }
                         
                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         
                         //请求失败时，返回缓存数据
                         if (failCallback) {
                             failCallback(error, [ApiClientManager cachedResponseForRequest:[operation request]]);
                         }
                     }];
    }
    
    //---------------------------------------------
    [[self requestOperationsQueue] addOperation:operation];
    
    
    return operation;
}

#pragma mark - 返回request的缓存数据
/**
 *  该方法来2次：
 *
 *      第一次，使用缓存数据时
 *      第二次，Operation被调度执行网络操作时
 */
+ (id)cachedResponseForRequest:(NSURLRequest *)request {
    
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
    
    AFHTTPResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
    
    id responseObject = [serializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
    
    return responseObject;
}


@end
