//
//  NSURL+Commom.m
//  OSChina
//
//  Created by xiongzenghui on 15/1/1.
//  Copyright (c) 2015年 Zain. All rights reserved.
//

#import "NSURL+Commom.h"

@implementation NSURL (Commom)

- (BOOL) isEqualToURL:(NSURL *)otherURL {
    return [[self absoluteURL] isEqual:[otherURL absoluteURL]] ||
    ([self isFileURL] && [otherURL isFileURL] &&
     ([[self path] isEqual:[otherURL path]]));
}

- (NSString *)MIMEType {
    
    return [[self absoluteURL] MIMEType];
}

@end
