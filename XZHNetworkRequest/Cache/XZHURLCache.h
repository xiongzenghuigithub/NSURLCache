//
//  XZHURLCache.h
//  XZHNetworkRequest
//
//  Created by sfpay on 15/2/11.
//  Copyright (c) 2015年 xiongzenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^VoidBlock)(void);

//是否缓存response
#define URLCACHE_CACHE_KEY @"MobileAppCacheKey"

//缓存的超时Key
#define URLCACHE_EXPIRATION_AGE_KEY @"MobileAppExpirationAgeKey"

//最大缓存时间
#define MAX_AGE 604800000

#define MAX_MEMORY_CACHE_SIZE  10

//缓存数据文件的位置
#define CACHE_FOLDER @"XZHCache"

//缓存数据的总大小（2^24 = 16MB，1向左移的位数）
#define M_MAX_FILE_SIZE 27  //内存
#define D_MAX_FILE_SIZE 27  //文件

//debug log
#ifdef CACHE_DEBUG_MODE
#define CacheDebugLog( s, ... ) NSLog(@"<%@:(%d)> %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define CacheDebugLog( s, ... ) //
#endif

@interface XZHURLCache : NSURLCache

@property (nonatomic, copy) VoidBlock cacheTimeoutCallback;

/**
 *  使用NSURLCache
 */
+ (void)active;

@end
