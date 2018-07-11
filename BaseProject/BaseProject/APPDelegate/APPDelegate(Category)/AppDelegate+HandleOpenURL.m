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

//#define __IPHONE_10_0    100000
//#if __IPHONE_OS_VERSION_MAX_ALLOWED > 100000

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    [QQApiInterface handleOpenURL:url delegate:[QQSDKManager sharedManager]];
    
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    
    NSString *string  = [url absoluteString];
    if ([string hasPrefix:@"wx"]) {
        return [WeChatSDKManager handleOpenURL:url];
    }
    return [WeBoSDKManager handleOpenURL:url];
}
@end
