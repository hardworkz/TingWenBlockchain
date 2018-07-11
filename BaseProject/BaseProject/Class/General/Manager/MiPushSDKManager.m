//
//  MiPushSDKManager.m
//  BaseProject
//
//  Created by 泡果 on 2018/7/6.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "MiPushSDKManager.h"

@implementation MiPushSDKManager
#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static MiPushSDKManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MiPushSDKManager alloc] init];
    });
    return instance;
}

/**
 小米推送第三方注册
 */
+ (void)registerMIPush {
    
    //小米推送注册
    [MiPushSDK registerMiPush:[MiPushSDKManager sharedManager] type:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound connect:YES];
}

/**
 小米推送点击通知进入应用
 
 @param userInfo 接收的推送数据
 */
- (void)miPushDidClickNotification:(NSDictionary *)userInfo {
    
    //小米统计客户端 通过push开启app行为
    NSString *messageId  = [userInfo objectForKey:@"_id_"];
    [MiPushSDK openAppNotify:messageId];
    
    //在这里处理点击推送后app内的业务逻辑（例如：跳转相应界面）
}


/**
 *  请求成功调用
 *
 */
- (void)miPushRequestSuccWithSelector:(NSString *)selector data:(NSDictionary *)data {
    //设置小米推送的客户端别名
    //    [MiPushSDK setAlias:@"15280855339"];
    if ([selector isEqualToString:@"bindDeviceToken:"]) {
        NSLog(@"regid = %@",data[@"regid"]);
    }
}

/**
 *  请求失败调用
 *
 */
- (void)miPushRequestErrWithSelector:(NSString *)selector error:(int)error data:(NSDictionary *)data {
    
}
/**
 *  接收推送数据
 *
 */
- (void)miPushReceiveNotification:(NSDictionary *)data
{
    NSLog(@"%@",data);
    if (self.PushData) {
        self.PushData(data);
    }
}
@end
