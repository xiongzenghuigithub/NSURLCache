//
//  User.h
//  XZHNetwork
//
//  Created by xiongzenghui on 15/2/9.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : JSONModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *created_at;
@property (nonatomic, copy) NSString <Optional>*last_device;
@property (nonatomic, copy) NSString *last_visited_at;
@property (nonatomic, copy) NSString *login;
@property (nonatomic, copy) NSString *icon;

@end
