//
//  NSTimer+Initialize.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "NSTimer+Initialize.h"

@implementation NSTimer (Initialize)

#pragma mark - Block封装

+ (void)timerRun:(NSTimer *)timer
{
    YXTimerBlock aBlcok = [timer userInfo];
    if (aBlcok) {
        aBlcok(timer);
    }
}

+ (NSTimer *)scheduledWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(YXTimerBlock)aBlock
{
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(timerRun:) userInfo:[aBlock copy] repeats:repeats];
}

+ (NSTimer *)timerTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(YXTimerBlock)aBlock
{
    NSTimer *timer = [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(timerRun:) userInfo:[aBlock copy] repeats:repeats];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    return timer;
}

@end
