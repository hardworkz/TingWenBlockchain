//
//  Z_ThirdPartLoadService.m
//  IOS_BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.*. All rights reserved.
//

#import "Z_ThirdPartLoadService.h"

@implementation Z_ThirdPartLoadService

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [[self class] initCoredata];
        
        [[self class] ls_setKeyBord];
        
        [[self class] ls_testReachableStaus];
        
    });
}

#pragma mark - 初始化coredata
+ (void)initCoredata {
    
    //注册QQ
    [QQSDKManager registerQQ];
    //注册微信
    [WeChatSDKManager registerWeChat];
    //注册微博
    [WeBoSDKManager registerWeiBo];
    //注册小米推送
    [MiPushSDKManager registerMIPush];
}

#pragma mark - 键盘回收相关
+ (void)ls_setKeyBord {
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}

#pragma mark － 检测网络相关
+ (void)ls_testReachableStaus {
    
}

@end
