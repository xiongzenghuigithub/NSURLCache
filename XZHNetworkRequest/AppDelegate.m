//
//  AppDelegate.m
//  XZHNetwork
//
//  Created by sfpay on 15/2/7.
//  Copyright (c) 2015年 zain. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "XZHURLCache.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

/**
 *  设置缓存 和 网络请求菊花
 */
- (void)config {
    
    //1 ---------------------------------------------------------------------------
    _apiClientManager = [ApiClientManager sharedClientManager];
    
    //2 ---------------------------------------------------------------------------
    /*
     在AppDelegate中需要对NSURLCache进行初始化,固化后的缓存文件会放在(App Sandbox)/Library/Caches/(your bundle identifier)/NSURLCache中，以SQLite数据库文件的形式存放
     */
    [XZHURLCache active];
    
    //3 ---------------------------------------------------------------------------
    [UIImageView setSharedImageCache:[UIImageView sharedImageCache]];
    [UIButton setSharedImageCache:[UIButton sharedImageCache]];
    
    //4 ---------------------------------------------------------------------------
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    [self config];
    
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.window setRootViewController:nav];
    
    [self.window makeKeyAndVisible];
    [self.window setBackgroundColor:[UIColor whiteColor]];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
