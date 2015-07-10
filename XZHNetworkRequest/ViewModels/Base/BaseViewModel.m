//
//  BaseViewModel.m
//  XZHNetwork
//
//  Created by xiongzenghui on 15/2/9.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- (void)addSuccessComplet:(SuccessComplet)success
             ErrorCompelt:(ErrorCompelt)error
              FailComplet:(FailComplet)fail
{
    self.successComplet = success;
    self.errorCompelt = error;
    self.failComplet = fail;
}

- (void)releaseAllComplets {
    self.successComplet = nil;
    self.errorCompelt = nil;
    self.failComplet = nil;
}

@end
