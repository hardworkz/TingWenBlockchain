//
//  UserLoginManager.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/8.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "UserLoginManager.h"

@implementation UserLoginManager
singleM(UserLoginManager)

- (void)readAuthorizeData {
    _identity = [DataCache loadCache:@"IdentityLocCache"];
    if(!_identity) {
        _identity = [Identity new];
    }
}
- (void)saveAuthorizeData {
    [DataCache setCache:_identity forKey:@"IdentityLocCache"];
}
- (void)logOut {
    //登录模块重新初始化
    _identity = [Identity new];
    _identity.firstUseSoft = NO;
    [self saveAuthorizeData];
    //退出清除用户数据
    [self logout];
}
#pragma mark -- User
//更新用户数据
- (void)updateUser:(User*)user {
    [DataCache setCache:user forKey:string(@"UserLocCache",user.userNo)];
}
//通过用户guid加载用户
- (void)loadUserWithNo:(NSString *)userNo {
    _user = [DataCache loadCache:string(@"UserLocCache",userNo)];
    if(!_user) {
        _user = [User new];
    }
}
- (void)logout
{
    _user = [User new];
    [self updateUser:_user];
}
@end
