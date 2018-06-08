//
//  Single.h
//  BaseProject
//
//  Created by 泡果 on 2018/6/8.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#ifndef Single_h
#define Single_h

/**
 创建一个单例（兼容ARC和MRC）
 任何项目中，当我们要使用单例类的时候只要在项目中导入h文件然后
 在.h文件中调用singleH(类名)
 在.m文件中调用singleM(类名)
 创建类时直接调用share类名方法即可
 */
#define singleH(name) +(instancetype)share##name;

#if __has_feature(objc_arc)

#define singleM(name) static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)share##name\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}
#else
#define singleM static id _instance;\
+(instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+(instancetype)shareTools\
{\
return [[self alloc]init];\
}\
-(id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
-(oneway void)release\
{\
}\
\
-(instancetype)retain\
{\
return _instance;\
}\
\
-(NSUInteger)retainCount\
{\
return MAXFLOAT;\
}
#endif

#endif /* Single_h */
