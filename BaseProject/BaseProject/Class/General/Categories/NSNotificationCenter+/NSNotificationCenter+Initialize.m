//
//  NSNotificationCenter+Initialize.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "NSNotificationCenter+Initialize.h"

#import <objc/runtime.h>

////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////
//  自定义监听对象
@interface NSNObserver : NSObject

- (void)nsnobseverSel:(id)anObject; // < 用于通知中心的观察者响应方法
@property (copy, nonatomic) NSNBlock aBlcok;
+ (instancetype)observerWithBlock:(NSNBlock)aBlock;

@end

@implementation NSNObserver

+ (instancetype)observerWithBlock:(NSNBlock)aBlock
{
    NSNObserver *obsever = [[NSNObserver alloc] init];
    obsever.aBlcok = aBlock;
    return obsever;
}
- (void)nsnobseverSel:(id)anObject
{
    if (self.aBlcok) {
        self.aBlcok(anObject);
    }
}

@end
////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////

@implementation NSNotificationCenter (Initialize)

#pragma mark - Block封装

static const char *kObserversKey = "kObserversKey";
- (void)addObserverWithName:(NSNotificationName)aName forObject:(id)anObject respondBlock:(NSNBlock)aBlock
{
    aBlock = [aBlock copy];
    if (!aName || !aBlock) return;
    NSMutableDictionary *obseverDict = objc_getAssociatedObject(self, kObserversKey);
    if (!obseverDict) {
        obseverDict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, kObserversKey, obseverDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    NSMutableArray *obsevers = obseverDict[aName];
    if (!obsevers) {
        obsevers = [NSMutableArray array];
    }
    NSNObserver *obsever = [NSNObserver observerWithBlock:aBlock];
    [self addObserver:obsever selector:@selector(nsnobseverSel:) name:aName object:anObject];
    [obsevers addObject:obsever];
    [obseverDict setValue:obsevers forKey:aName];
}

- (void)removeBlockObseverForName:(NSNotificationName)aName
{
    if (!aName) return;
    NSMutableDictionary *obseverDict = objc_getAssociatedObject(self, kObserversKey);
    if (!obseverDict) return;
    NSMutableArray *obsevers = obseverDict[aName];
    [obsevers removeAllObjects];
    [obseverDict removeObjectForKey:aName];
}

- (void)removeBlockObsever
{
    NSMutableDictionary *obseverDict = objc_getAssociatedObject(self, kObserversKey);
    if (!obseverDict) return;
    [obseverDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, NSMutableArray *obj, BOOL * _Nonnull stop) {
        [obj removeAllObjects];
    }];
    [obseverDict removeAllObjects];
}

@end
