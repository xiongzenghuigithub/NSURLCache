//
//  LanrenInfoViewModel.m
//  XZHNetworkRequest
//
//  Created by xiongzenghui on 15/2/11.
//  Copyright (c) 2015年 xiongzenghui. All rights reserved.
//

#import "LanrenInfoViewModel.h"

//NSString *const hostName = @"http://api.lanrenzhoumo.com";

NSString *const initPath        =   @"/other/common/config/";
NSString *const indexListPath   =   @"/main/recommend/index/";


@implementation LanrenInfoViewModel

+ (AFHTTPRequestOperation *)getAppClientWithSuccessCompet:(void (^)(id responseObject)) success
                                             ErrorComplet:(void (^)(NSNumber *errorCode)) error
                                              FailComplet:(void (^)(NSError *error)) fail
{
    NSDictionary *paramDict = @{
                                @"client_id":@"2",
                                @"lat":@"0",
                                @"lon":@"0"
                                };
    @weakify(self);
    return [API_CLIENT operationWithMethod:GET Path:initPath ParamsDictionary:paramDict SuccessCallback:^(id responseObject) {
            @strongify(self);
        
            //把session id 到内存
            NSString *sessionId = responseObject[@"result"][@"session_id"];
            [self saveObject:sessionId forKey:@"sessionId"];
        
            if (success) {
                success(success);
            }
        
        } ErrorCallback:^(NSNumber *errorCode, id cacheData) {
            
        } FailCallback:^(NSError *error, id cacheData) {
            
        } AutoRetryCallback:^{
            
        } UnReachableCallback:^(id responseObject){
            
        } UseCacheData:YES
                
          CacheExpirat:60];
}

+ (AFHTTPRequestOperation *)indexInfoListForPagr:(NSInteger) page
                                   SuccessCompet:(void (^)(id responseObject))success
                                    ErrorComplet:(void (^)(NSNumber *errorCode))error
                                     FailComplet:(void (^)(NSError *error))fail
                                        UseCache:(BOOL) isUse
{
    NSDictionary *paramDict = @{
                                @"lat":@"22.55156",
                                @"lon":@"114.1065",
                                @"page":[NSString stringWithFormat:@"%ld", page],
                                @"session_id":[self objectForKey:@"sessionId"],
                                @"v":@"2"
                                };
    
    return [API_CLIENT operationWithMethod:GET Path:indexListPath ParamsDictionary:paramDict SuccessCallback:^(id responseObject) {
        
    } ErrorCallback:^(NSNumber *errorCode, id cacheData) {
        
    } FailCallback:^(NSError *error, id cacheData) {
        
    } AutoRetryCallback:^{
        
    } UnReachableCallback:^(id responseObject){
        
    } UseCacheData:YES
            
    CacheExpirat:60];
}

@end
