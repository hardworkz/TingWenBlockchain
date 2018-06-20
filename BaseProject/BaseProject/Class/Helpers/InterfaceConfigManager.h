//
//  InterfaceConfigManager.h
//  BaseProject
//
//  Created by 泡果 on 2018/6/13.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const KBASE_API_URL;
/**
 应用api管理类
 */
@interface InterfaceConfigManager : NSObject
/**
 登录接口
 */
@property (strong, nonatomic) NSString *LoginAPI;
@end
