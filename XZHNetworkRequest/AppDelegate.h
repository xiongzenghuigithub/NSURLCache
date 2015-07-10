//
//  AppDelegate.h
//  XZHNetworkRequest
//
//  Created by xiongzenghui on 15/2/9.
//  Copyright (c) 2015年 xiongzenghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApiClientManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ApiClientManager *apiClientManager;

@end

