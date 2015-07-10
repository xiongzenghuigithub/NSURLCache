//
//  NSArray+Queue.m
//  OSChina
//
//  Created by xiongzenghui on 15/1/1.
//  Copyright (c) 2015年 Zain. All rights reserved.
//

#import "NSMutableArray+Queue.h"

@implementation NSMutableArray (Queue)

- (id)my_enque:(id)obj {
    
    //内存最多存放规定长度的response data
    if ([self count] >= MAX_MEMORY_CACHE_SIZE) {
        id dequeObj = [self my_deque];
        [self addObject:obj];
        return dequeObj;
        
    } else {
        
        [self addObject:obj];
        return nil;
    }
}

- (id)my_deque {
    if ([self count] == 0) return nil;
    id firstObject = [self objectAtIndex:0];
    [self removeObjectAtIndex:0];
    return firstObject;
}

- (BOOL)keyIsInQueue:(NSString *)key {
    BOOL isInQueue = nil;
    for (NSString *cachedKey in self) {
        if ([cachedKey isEqualToString:key]) {
            isInQueue = YES;
            break;
        }
    }
    return isInQueue;
}

@end
