//
//  AppDelegate+HandleOpenURL.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "AppDelegate+HandleOpenURL.h"

@implementation AppDelegate (HandleOpenURL)
#pragma mark - UIApplicationDelegate 回调url相关
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    return nil;
//}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
//{
//    return nil;
//}

//#define __IPHONE_10_0    100000
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    return nil;
}
@end
