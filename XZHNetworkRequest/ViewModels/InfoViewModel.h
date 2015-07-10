//
//  InfoViewModel.h
//  XZHNetwork
//
//  Created by xiongzenghui on 15/2/9.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModel.h"

@interface InfoViewModel : BaseViewModel


+ (AFHTTPRequestOperation *)getLatestInfoListWithPage:(NSInteger)page
                                       SuccessComplet:(SuccessComplet) success
                                         ErrorComplet:(ErrorCompelt) error
                                          FailComplet:(FailComplet) fail;

@end
