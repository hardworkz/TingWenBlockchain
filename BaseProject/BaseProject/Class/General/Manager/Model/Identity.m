//
//  Identity.m
//  RealmDemo
//
//  Created by haigui on 16/7/2.
//  Copyright © 2016年 com.luohaifang. All rights reserved.
//
#import "Identity.h"
#import "UserLoginManager.h"

@implementation Identity

MJExtensionCodingImplementation

- (instancetype)init
{
    self = [super init];
    if (self) {
        //是否为第一次使用软件
        _firstUseSoft = YES;
        //初始化获取软件版本号
        NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
        _lastSoftVersion = currentVersion;
        
        //获取当前登录状态
        UserLoginManager *userLoginManager = [UserLoginManager shareUserLoginManager];
        if ([userLoginManager.user.userNo intValue] != 0) {
            _isLogin = NO;
        }else{
            _isLogin = YES;
        }
    }
    return self;
}

@end
