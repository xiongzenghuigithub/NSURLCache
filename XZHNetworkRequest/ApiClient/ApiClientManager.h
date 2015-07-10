//
//  ApiClientManager.h
//  XZHNetwork
//
//  Created by xiongzenghui on 15/2/9.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZHHttpRequestOperationManager.h"

typedef NS_ENUM(NSInteger, HttpRequestMethod) {
    GET     = 1,
    POST    = 2,
    HEAD    = 3,
    PUT     = 4,
};

//当请求Operations队列暂停调度时的回调
typedef void (^OperationQueueSuspendComplet)(void);

//当网络连接状态改变时的回调
typedef void (^NetworkChangedComplet)(AFNetworkReachabilityStatus netwoorkStatus);

@interface ApiClientManager : NSObject

+ (instancetype) sharedClientManager;

/**
 *  统一API入口
 *
 *  @param method          GET,POST,HEAD,PUT
 *
 *  @param requetPath      请求子路径
 *  @param paramDict       请求参数（统一请求入口为其添加其他基础参数）
 *
 *  @param successCallback 请求成功的回调代码
 *  @param errorCallback   请求错误的回调代码
 *  @param failCallback    请求失败的回调代码
 *  @param autoRetry       请求失败时自动重试网络连接的回调代码
 *  @param
 *
 *  @param isUse           是否使用缓存的response data数据
 *
 *  @return 返回当前网络请求操作所在的NSOperation对象
 */
- (AFHTTPRequestOperation *)operationWithMethod:(HttpRequestMethod) method
                                           Path:(NSString *) requetPath
                               ParamsDictionary:(NSDictionary *) paramDict
                                SuccessCallback:(void (^)(id responseObject)) successCallback
                                  ErrorCallback:(void (^)(NSNumber *errorCode, id cacheData)) errorCallback
                                   FailCallback:(void (^)(NSError *error, id cacheData)) failCallback
                              AutoRetryCallback:(void (^)(void)) autoRetry
                            UnReachableCallback:(void (^)(id responseObject)) unReachable
                                   UseCacheData:(BOOL)  isUse
                                   CacheExpirat:(NSTimeInterval) expirat;


@property (nonatomic, strong) NSString *hostName;

@property (nonatomic, strong) XZHHttpRequestOperationManager *requestOperationsManager;
//@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationsManager;
@property (nonatomic, strong) NSOperationQueue *requestOperationsQueue;

@property (nonatomic, copy) OperationQueueSuspendComplet operationQueueSuspendComplet;
@property (nonatomic, copy) NetworkChangedComplet networkChangedComplet;

@end
