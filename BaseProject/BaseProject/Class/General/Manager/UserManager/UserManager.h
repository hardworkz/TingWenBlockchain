//
//  UserManager.h
//  RealmDemo
//
//  Created by haigui on 16/7/2.
//  Copyright © 2016年 com.luohaifang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface UserManager : NSObject

//全局的用户信息
@property (nonatomic, strong ,readonly) User *user;

+ (instancetype)manager;

#pragma mark -- User
//更新用户数据
- (void)updateUser:(User*)user;
//通过用户uid加载用户
- (void)loadUserWithNo:(NSString *)userNo;
/**
 退出登录
 */
- (void)logout;
@end
