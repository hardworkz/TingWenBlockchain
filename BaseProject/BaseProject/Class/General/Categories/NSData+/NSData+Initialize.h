//
//  NSData+Initialize.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Initialize)

/**
 初始化实例
 */
+ (id)dateFormatter;
/**
 初始化实例并设置formatter格式
 */
+ (id)dateFormatterWithFormat:(NSString *)dateFormat;
/**
 初始化实例并设置默认formatter格式
 */
+ (id)defaultDateFormatter;/*yyyy-MM-dd HH:mm:ss*/
@end
