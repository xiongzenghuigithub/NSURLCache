//
//  InfoViewModel.m
//  XZHNetwork
//
//  Created by xiongzenghui on 15/2/9.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "InfoViewModel.h"

NSString *const lastestPath = @"/v2/venues/search";

@interface InfoViewModel ()

@property (nonatomic, assign) NSInteger page;

@end

@implementation InfoViewModel

+ (AFHTTPRequestOperation *)getLatestInfoListWithPage:(NSInteger)page
                                       SuccessComplet:(SuccessComplet)success
                                         ErrorComplet:(ErrorCompelt)error
                                          FailComplet:(FailComplet)fail
{
    //1.
//    [self addSuccessComplet:success ErrorCompelt:error FailComplet:fail];
    
    //2.
    NSDictionary * paramDict = @{@"client_id":kAppId,
                                 @"client_secret":kAppSecret,
                                 @"v":@"20150201",
                                 @"ll":@"40.7,-74",
                                 @"query":@"sushi"
                                 };
    
    //3.
    return [API_CLIENT operationWithMethod:GET
                                      Path:lastestPath
                          ParamsDictionary:paramDict
                           SuccessCallback:^(id responseObject) {
                                if (success) {
                                    success(responseObject);
                                }
    
                           } ErrorCallback:^(NSNumber *errorCode, id cacheData) {
                               

                           } FailCallback:^(NSError *error, id cacheData) {
        

                           } AutoRetryCallback:^{
        

                           } UnReachableCallback:^(id responseObject){
        

                           } UseCacheData:YES
            
                             CacheExpirat:60];
}



@end
