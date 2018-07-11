//
//  AlipaySDKManager.m
//  BaseProject
//
//  Created by 泡果 on 2018/7/6.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "AlipaySDKManager.h"

@implementation AlipaySDKManager
#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static AlipaySDKManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[AlipaySDKManager alloc] init];
    });
    return instance;
}

@end
