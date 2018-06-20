//
//  InterfaceConfigManager.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/13.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "InterfaceConfigManager.h"


//测试
NSString* const KBASE_API_URL = @"http://test.dashun.applinzi.com/";
//正式
//NSString* const KBSSDKAPIURL = @"http://dashun.applinzi.com/";
@implementation InterfaceConfigManager

- (NSString *)LoginAPI
{
    return string(KBASE_API_URL, @"");
}
@end
