//
//  DataCache.h
//  fadein
//
//  Created by Maverick on 15/12/31.
//  Copyright © 2015年 Maverick. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataCache : NSObject

/**
 归档

 @param data 归档数据
 @param key 键
 */
+ (void)setCache:(id)data forKey:(NSString *)key;

/**
 解档

 @param key 键
 @return 返回归档数据
 */
+ (id)loadCache:(NSString *)key;

@end
