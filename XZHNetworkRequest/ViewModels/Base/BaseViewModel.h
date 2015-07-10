//
//  BaseViewModel.h
//  XZHNetwork
//
//  Created by xiongzenghui on 15/2/9.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseViewModel : RVMViewModel

//---------------Blocks-----------------

@property (nonatomic, copy) SuccessComplet  successComplet;
@property (nonatomic, copy) ErrorCompelt    errorCompelt;
@property (nonatomic, copy) FailComplet     failComplet;

/**
 *  保存传入的回调执行的Blocks
 */
- (void) addSuccessComplet:(SuccessComplet) success
              ErrorCompelt:(ErrorCompelt) error
               FailComplet:(FailComplet) fail;

/**
 *  清空保存的Blocks ，解决循环引用的问题
 */
- (void) releaseAllComplets;

//---------------------------------------

@end
