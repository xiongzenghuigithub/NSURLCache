//
//  XZHURLCache.m
//  XZHNetworkRequest
//
//  Created by sfpay on 15/2/11.
//  Copyright (c) 2015年 xiongzenghui. All rights reserved.
//

#import "XZHURLCache.h"
#import <sys/stat.h>
#import <CommonCrypto/CommonDigest.h>
#import "NSMutableArray+Queue.h"
#import "CacheItem.h"
#import "NSObject+ObjectMap.h"

static NSString* _cacheDirectory;
static NSMutableDictionary *_memoryCache;       //以key保存CacheItem对象
static NSMutableArray *_keysQueue;              //保存所有的key

@implementation XZHURLCache

#pragma mark - md5 sha1
+ (NSString *)MD5:(NSString *)value
{
    if(self == nil || [value length] == 0)
        return nil;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([value UTF8String], (int)[value lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

+ (NSString *)SHA1:(NSString *)value
{
    if(self == nil || [value length] == 0)
        return nil;
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH], i;
    CC_SHA1([value UTF8String], (int)[value lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    for(i=0;i<CC_SHA1_DIGEST_LENGTH;i++)
    {
        [ms appendFormat: @"%02x", (int)(digest[i])];
    }
    return [ms copy];
}


#pragma mark - File Path
+ (NSString *)getCachePathInSandBox {
    static NSString *cacheDirectory;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSArray *cacheDirectories = NSSearchPathForDirectoriesInDomains( NSCachesDirectory, NSUserDomainMask, YES );
        cacheDirectory = [cacheDirectories objectAtIndex:0];
    });
    
    return cacheDirectory;
}

+ (NSString *)getCachePathInCacheFolder {
    static NSString *cacheDir;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cacheDir = [[self getCachePathInSandBox] stringByAppendingPathComponent:CACHE_FOLDER];
    });
    return cacheDir;
}

+ (NSString *)getRequestMD5Key:(NSURLRequest *)request {
    NSString *md5Key = [self MD5:[[request URL] absoluteString]];
    return md5Key;
}

//返回本地缓存文件的全路径
+ (NSString *)responseFilePathForRequest:(NSURLRequest *)request
                                RootPath:(NSString *)rootPath
{
    NSString *isCache = [[request allHTTPHeaderFields] objectForKey:URLCACHE_CACHE_KEY];
    
    if ([isCache isEqualToString:@"YES"]) {
        
        NSString *fileKey = [self getRequestMD5Key:request];
        NSString *filePath =[rootPath stringByAppendingPathComponent:fileKey];
        return filePath;
    }
    
    return @"";
}

#pragma mark - 创建目录
- (BOOL)createdDir:(NSString *)dirPath {
    
    BOOL isCreate = NO;
    BOOL isDir = NO;
    BOOL isExists = NO;
    
    isExists = [[NSFileManager defaultManager] fileExistsAtPath:dirPath isDirectory:&isDir];
    
    if (!(isExists && isDir)) {
        //创建文件夹
        isCreate = [[NSFileManager defaultManager]
                    createDirectoryAtPath:dirPath
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:nil];
    }
    
    if (isExists) {
        isCreate = YES;
    }
    
    return isCreate;
}

#pragma mark - NSURLCache 实例化
+ (void)active {
    
    //1.
    _cacheDirectory = [self getCachePathInCacheFolder];
    CacheDebugLog(@"_cacheDirectory: %@\n", _cacheDirectory);
    
    int flag = mkdir([_cacheDirectory UTF8String], 0700);
    CacheDebugLog(@"FLAG = %d\n", flag);
    
    //2.
    XZHURLCache *cache = [[XZHURLCache alloc] initWithMemoryCapacity:1<<M_MAX_FILE_SIZE
                                                        diskCapacity:1<<D_MAX_FILE_SIZE
                                                            diskPath:_cacheDirectory];
    
    [NSURLCache setSharedURLCache:cache];
}

#pragma mark - NSURLCache 初始化
- (instancetype)initWithMemoryCapacity:(NSUInteger)memoryCapacity
                          diskCapacity:(NSUInteger)diskCapacity
                              diskPath:(NSString *)path
{
    self = [super initWithMemoryCapacity:memoryCapacity diskCapacity:diskCapacity diskPath:path];
    if (self) {
        [self initConfigs];
    }
    return self;
}

- (void)initConfigs {
    _memoryCache = [@{} mutableCopy];
    _keysQueue = [@[] mutableCopy];
    
    [self addObserveNotification];
}

- (void) addObserveNotification {
    
    @weakify(self);
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
//    [center addObserverForName:AFNetworkingOperationDidStartNotification
//                        object:nil
//                         queue:[NSOperationQueue mainQueue]
//                    usingBlock:^(NSNotification *note)
//    {
//        BFLog(@"note = %@\n", note);
//    }];
//    
//    [center addObserverForName:AFNetworkingOperationDidFinishNotification
//                        object:nil
//                         queue:[NSOperationQueue mainQueue]
//                    usingBlock:^(NSNotification *note)
//     {
//        BFLog(@"note = %@\n", note);
//    }];
    
    //程序进入后台
    [center addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        @strongify(self);
        [self archiverAllCacheItems];
    }];
    
    //程序进入前台
//    [center addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
//        
//    }];
    
    //接收到系统内存警告
    [center addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        @strongify(self);
        [self archiverAllCacheItems];
    }];
    
    //程序退出
    [center addObserverForName:UIApplicationWillTerminateNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        @strongify(self);
        [self archiverAllCacheItems];
    }];
}

- (void) removeObserveNotification {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
//    [center removeObserver:self forKeyPath:AFNetworkingOperationDidStartNotification];
//    [center removeObserver:self forKeyPath:AFNetworkingOperationDidFinishNotification];
    
    [center removeObserver:self forKeyPath:UIApplicationDidEnterBackgroundNotification];
    [center removeObserver:self forKeyPath:UIApplicationDidReceiveMemoryWarningNotification];
    [center removeObserver:self forKeyPath:UIApplicationWillTerminateNotification];
}

- (void)dealloc {
    _memoryCache = nil;
    _keysQueue = nil;
    
    [self removeObserveNotification];
}

#pragma mark - NSURLCache 核心方法

#pragma mark  查找缓存数据
//注：该方法返回nil时，才会调用 storeCachedResponse:forRequest: 方法

- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    
    //1. 判断当前request是否可以被缓存（如果不可以，就不用查找缓存数据了）
    if (![self requestCanCachable:request]) {
        
        CacheDebugLog(@"Request:%@ 不允许被缓存\n", request);
        return nil;
    }
    
    //2. 优先从内存字典查找
     NSCachedURLResponse *cachedResponse = [self findCacheItemInMemory:request];
    
    if (!cachedResponse) {
        
        //3. 再考虑从本地文件查找
        return [self findCacheResponseInDisk:request];
    }
    
    return cachedResponse;
}

#pragma mark 保存新response成为缓存数据
- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse
                 forRequest:(NSURLRequest *)request
{
    if ([[[request allHTTPHeaderFields] objectForKey:URLCACHE_CACHE_KEY] isEqualToString:@"YES"]) {
        
        //保存response为缓存数据
        [self saveCacheResponse:cachedResponse forRequest:request];
    }
  
    CacheDebugLog( @"CACHE currentDiskUsage:   %@", [NSString stringWithFormat:@"%lu/%lu", [self currentDiskUsage], [self diskCapacity]]);
    CacheDebugLog( @"CACHE currentMemoryUsage: %@", [NSString stringWithFormat:@"%lu/%lu", [self currentMemoryUsage], [self memoryCapacity]]);
}

#pragma mark - 网络连接是否可达
+(BOOL)networkAvailable{
    AFNetworkReachabilityManager *reachabilityManager = [[API_CLIENT requestOperationsManager] reachabilityManager];
    
    return [reachabilityManager isReachable];
}

#pragma mark - 磁盘缓存
#pragma mark 从本地文件系统 查找缓存数据
- (NSCachedURLResponse *)findCacheResponseInDisk:(NSURLRequest *)request {
    
    NSString *path = [XZHURLCache responseFilePathForRequest:request RootPath:_cacheDirectory];
    
    //从本地文件恢复对象
    CacheItem *cachedItem = [CacheItem unArchiverFromPath:path];
    
    if (cachedItem) {
        
        if ([XZHURLCache networkAvailable]) {   //服务器可达，需要判断缓存是否超时，不可达直接返回缓存
            
            if ([cachedItem isExpirat]) {
                CacheDebugLog(@"Request: %@ 对应的缓存已经超时\n", request);
                
                if (self.cacheTimeoutCallback) {
                    self.cacheTimeoutCallback();
                }
                
                return nil;
            }
        }
        
        //1）服务器不可达 2）缓存未过期
        CacheDebugLog(@"找到request: %@ 对应的缓存文件\n", request);
        return [XZHURLCache getCacheURLResponseWithData:[cachedItem cacheData] Request:request];
    }
    //------------------------------------------------------
    
    CacheDebugLog(@"没有找到request: %@ 对应的缓存文件\n", request);
    return nil;
}

#pragma mark - 从内存字典对象 查找缓存数据
- (NSCachedURLResponse *)findCacheItemInMemory:(NSURLRequest *)request {
    
    NSString *key = [XZHURLCache getRequestMD5Key:request];
    BOOL isInMemoryCache = [_keysQueue keyIsInQueue:key];

    if (!isInMemoryCache) {
        return nil;
    }
    
    //从内存字典中找到了缓存项
    CacheItem *cacheItem = _memoryCache[key];
    
    if (![cacheItem isExpirat]) {
        
        [_keysQueue removeObject:key];       //将找到的key从数组删除 (数组长度自动减1)
        [_keysQueue my_enque:key];           //再将key入队尾部
        
        return [XZHURLCache getCacheURLResponseWithData:[cacheItem cacheData] Request:request];
    }
    
    //缓存已经超时
    return nil;
}

#pragma mark 保存数据为缓存数据
- (void)saveCacheResponse:(NSCachedURLResponse *)cachedResponse
               forRequest:(NSURLRequest *)request
{
    CacheDebugLog(@"为Request:%@ 缓存response数据\n", request);
    
    NSString *key = [XZHURLCache getRequestMD5Key:request];
    
    CacheItem *cacheItem = [CacheItem createInstance];
    cacheItem.lastModifyDate = [NSDate date];
    cacheItem.cacheKey = key;
    cacheItem.cacheData = [cachedResponse data];
    
    //1. 设置缓存的最后修改时间
    NSString *cacheMaxTime = [[request allHTTPHeaderFields] objectForKey:URLCACHE_EXPIRATION_AGE_KEY];
    if ([cacheMaxTime isEqualToString:@"0"] || cacheMaxTime == nil) {
        cacheItem.durationTime = MAX_AGE;
    }else {
        cacheItem.durationTime = [cacheMaxTime doubleValue];
    }
    
    BOOL isInMemoryCache = [_keysQueue keyIsInQueue:key];
    
    //2. 将Item缓存项加入缓存
    
    //2.1 已经存在于内存中
    if (isInMemoryCache) {
        _memoryCache[key] = cacheItem;
        
        [_keysQueue removeObject:key];
        [_keysQueue my_enque:key];
        
        return;
    }
    
    //2.2 不在内存中
    NSString *popedKey = [_keysQueue my_enque:key];
    
    if (popedKey) {
        
        //2.2.1.1 将退出队列item写入本地文件
        CacheItem *popCacheItem = _memoryCache[popedKey];
        NSString *path = [XZHURLCache responseFilePathForRequest:request RootPath:_cacheDirectory];
        [popCacheItem archiverToPath:path];
        
        //2.2.1.2 从内存删除
        [_memoryCache removeObjectForKey:popedKey];
        
    } else {
        
        //2.2.2 放入内存
        _memoryCache[key] = cacheItem;
    }
}

#pragma mark - 判断当前request是否可以被缓存
- (BOOL)requestCanCachable:(NSURLRequest *)request {
    
    BOOL isCachable = (request.cachePolicy == NSURLCacheStorageNotAllowed ||    \
                       [request.URL.absoluteString hasPrefix:@"file://"]  ||    \
                       [request.URL.absoluteString hasPrefix:@"data:"])  &&     \
                       [XZHURLCache networkAvailable];

    return isCachable;
}

#pragma mark - NSData 转换成 NSCachedURLResponse
+ (NSCachedURLResponse *)getCacheURLResponseWithData:(NSData *)cachedData    //内存中查找到缓存NSData
                                             Request:(NSURLRequest *)request //被缓存的request

{
    //1.
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[request URL] MIMEType:@"cache" expectedContentLength:[cachedData length] textEncodingName:nil];
    
    //2.
    NSCachedURLResponse *cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:cachedData];
    
    return cachedResponse;
}

#pragma mark - 将内存保存的CacheItem对象全部保存到本地文件
- (void)archiverAllCacheItems {
    
    //将内存保存的CacheItem对象全部归档到本地
    for (NSString *cachedKey in _keysQueue) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",_cacheDirectory,cachedKey];
        BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
       
        if (isExists) {
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            CacheItem *cachedItem = [_memoryCache objectForKey:cachedKey];
            [cachedItem archiverToPath:filePath];
            return;
        }
        
        CacheItem *cachedItem = [_memoryCache objectForKey:cachedKey];
        [cachedItem archiverToPath:filePath];
    }
    
    //清空内存缓存
    [_memoryCache removeAllObjects];
    [_keysQueue removeAllObjects];
}

@end
