//
//  Z_StartLoadAPP.m
//  IOS_BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.*. All rights reserved.
//

#import "Z_StartLoadAPP.h"

@implementation Z_StartLoadAPP

+ (void)load {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [[self class] ls_initPersonData];
        
    });
}

#pragma mark - 初始化个人数据
+ (void)ls_initPersonData {
    
}

@end
