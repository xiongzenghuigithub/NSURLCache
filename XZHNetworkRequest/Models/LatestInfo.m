//
//  LatestInfo.m
//  XZHNetwork
//
//  Created by xiongzenghui on 15/2/9.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "LatestInfo.h"

@implementation LatestInfo

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"infoId"
                                                       }];
}

@end
