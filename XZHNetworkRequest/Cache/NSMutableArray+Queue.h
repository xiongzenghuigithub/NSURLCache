//
//  NSArray+Queue.h
//  OSChina
//
//  Created by xiongzenghui on 15/1/1.
//  Copyright (c) 2015年 Zain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Queue)

/**
 *  入队列尾部
 *
 *      当队列满时，返回出队的第一个对象，并入队当前对象
 */
- (id) my_enque:(id) obj;

/**
 *  出队列头部
 */
- (id) my_deque;

/**
 *  查看key是否存在
 */
- (BOOL)keyIsInQueue:(NSString *)key;

@end
