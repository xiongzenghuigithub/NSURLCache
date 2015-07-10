//
//  NSURL+Commom.h
//  OSChina
//
//  Created by xiongzenghui on 15/1/1.
//  Copyright (c) 2015年 Zain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Commom)

- (BOOL) isEqualToURL:(NSURL *)otherURL;
- (NSString *)MIMEType;

@end
