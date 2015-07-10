//
//  CacheItem.m
//  XZHNetworkRequest
//
//  Created by sfpay on 15/2/13.
//  Copyright (c) 2015年 xiongzenghui. All rights reserved.
//

#import "CacheItem.h"

@implementation CacheItem 

+ (instancetype)createInstance {
    return [[CacheItem alloc] init];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.cacheKey forKey:@"cacheKey"];
    [aCoder encodeObject:self.cacheData forKey:@"cacheData"];
    [aCoder encodeDouble:self.durationTime forKey:@"durationTime"];
    [aCoder encodeObject:self.lastModifyDate forKey:@"lastModifyDate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
        self.cacheKey = [aDecoder decodeObjectForKey:@"cacheKey"];
        self.cacheData = [aDecoder decodeObjectForKey:@"cacheData"];
        self.durationTime = [aDecoder decodeDoubleForKey:@"durationTime"];
        self.lastModifyDate = [aDecoder decodeObjectForKey:@"lastModifyDate"];
        
        return self;
    }
    
    return nil;
}

- (void)archiverToPath:(NSString *)path {
    [NSKeyedArchiver archiveRootObject:self toFile:path];
}

+ (CacheItem *)unArchiverFromPath:(NSString *)path {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:path];
}

- (BOOL)isExpirat {
    
    //1. 当前最新时间
    NSDate *now = [NSDate date];
    
    //2. 当前最新时间 - 最后一次使用缓存的时间
    NSTimeInterval times = [now timeIntervalSinceDate:self.lastModifyDate];
    
    //3. 保存当前时间
    self.lastModifyDate = now;
    
    if (times > self.durationTime) {
        
        //缓存超时
        return YES;
    }
    return NO;
}

@end
