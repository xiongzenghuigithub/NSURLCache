//
//  CacheItem.h
//  XZHNetworkRequest
//
//  Created by sfpay on 15/2/13.
//  Copyright (c) 2015年 xiongzenghui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheItem : NSObject <NSSecureCoding>

+ (instancetype)createInstance;

//加入缓存的key
@property (nonatomic, copy) NSString *cacheKey;

//缓存的NSData
@property (nonatomic, copy) NSData *cacheData;

//当前缓存项 最大的缓存时限
@property (nonatomic, assign) NSTimeInterval durationTime;

//最后一次使用缓存的时间
@property (nonatomic, strong) NSDate *lastModifyDate;

/**
 *  当前缓存对象是否已经超时
 */
- (BOOL)isExpirat;

/**
 *  当前对象归档到执行路径
 */
- (void)archiverToPath:(NSString *)path;

/**
 *  从指定路径恢复成对象
 */
+ (CacheItem *)unArchiverFromPath:(NSString *)path;

@end
