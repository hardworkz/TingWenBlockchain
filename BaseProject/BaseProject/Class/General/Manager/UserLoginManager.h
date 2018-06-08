//
//  UserLoginManager.h
//  BaseProject
//
//  Created by 泡果 on 2018/6/8.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Identity.h"
#import "User.h"

@interface UserLoginManager : NSObject

singleH(UserLoginManager)
//全局登录信息
@property (nonatomic, strong) Identity *identity;
//全局的用户信息
@property (nonatomic, strong ,readonly) User *user;

#pragma mark -- Identity
//从本地读取登录缓存信息
- (void)readAuthorizeData;
//把登录信息存入本地
- (void)saveAuthorizeData;
#pragma mark -- User
//更新用户数据
- (void)updateUser:(User*)user;
//通过用户uid加载用户
- (void)loadUserWithNo:(NSString *)userNo;

//登出
- (void)logOut;
@end
