//
//  UserManager.m
//  RealmDemo
//
//  Created by haigui on 16/7/2.
//  Copyright © 2016年 com.luohaifang. All rights reserved.
//

#import "UserManager.h"

@interface UserManager ()

@end

@implementation UserManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (instancetype)manager {
    static UserManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[UserManager alloc] init];
    });
    return manager;
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
