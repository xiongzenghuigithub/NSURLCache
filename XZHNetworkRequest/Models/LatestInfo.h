//
//  LatestInfo.h
//  XZHNetwork
//
//  Created by xiongzenghui on 15/2/9.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface LatestInfo : JSONModel

@property (nonatomic, copy) NSString *infoId;
@property (nonatomic, copy) NSString <Optional>*image;
@property (nonatomic, copy) NSString *published_at;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *comments_count;

@property (nonatomic, strong) User *user;

@end
