//http://www.iliunian.com/2869.html

#import "XZHHttpRequestOperationManager.h"

@implementation XZHHttpRequestOperationManager

/**
 *  重写创建Operation对象的方法，让其完成：
 *
 *  在Etag检查一致的情况下，服务端会返回304，此时需要在FailBlock中调用cachedResponseObject方法，取出本地缓存数据
 */


- (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)request
                                                    success:(void (^)(AFHTTPRequestOperation *, id))success
                                                    failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSMutableURLRequest *modifiedRequest = [request mutableCopy];
    
    //情况一、 根据主机可达性】设置request的缓存策略
//    AFNetworkReachabilityManager *reachability = self.reachabilityManager;
//    if ([[request HTTPMethod] isEqualToString:@"GET"]) {
//        
//        if (reachability.isReachable){
//            
//            //先加载缓存数据，然后请新数据 （进入到NSURLCache的两个方法）
//            modifiedRequest.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//            
//        }else{
//            
//            //只加载缓存数据
//            modifiedRequest.cachePolicy = NSURLRequestReturnCacheDataDontLoad;
//        }
//        
//    } else if ([[request HTTPMethod] isEqualToString:@"POST"]) {
//        
//    }
    
    //情况二、 根据特定的URL配置缓存策略
    //...
    
    
    return [super HTTPRequestOperationWithRequest:modifiedRequest
                                          success:success
                                          failure:failure];
 
}


@end
