//
//  NSData+Initialize.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "NSData+Initialize.h"

@implementation NSData (Initialize)

+ (id)dateFormatter
{
    return [[self alloc] init];
}

+ (id)dateFormatterWithFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatter];
    dateFormatter.dateFormat = dateFormat;
    return dateFormatter;
}

+ (id)defaultDateFormatter
{
    return [self dateFormatterWithFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
