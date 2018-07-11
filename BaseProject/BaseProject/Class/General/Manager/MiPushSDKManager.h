//
//  MiPushSDKManager.h
//  BaseProject
//
//  Created by 泡果 on 2018/7/6.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MiPushSDKManager : NSObject<MiPushSDKDelegate,UNUserNotificationCenterDelegate>

+(instancetype)sharedManager;

/**
 推送数据回调block
 */
@property (nonatomic, copy) void(^PushData)(NSDictionary *data);

/**
 小米推送第三方注册
 */
+ (void)registerMIPush;

/**
 小米推送点击通知进入应用

 @param userInfo 接收的推送数据
 */
- (void)miPushDidClickNotification:(NSDictionary *)userInfo;
@end
