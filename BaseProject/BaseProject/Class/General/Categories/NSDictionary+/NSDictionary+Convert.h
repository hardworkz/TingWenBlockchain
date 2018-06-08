//
//  NSDictionary+Convert.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Convert)
#pragma mark - NSDictionary -> JSON

+ (NSString *)convertToJson:(NSDictionary *)dict;
- (NSString *)convertToJson;

#pragma mark - NSDictionary -> NSData

+ (NSData *)returnDataWithDictionary:(NSDictionary *)dict;
- (NSData *)dictionaryData;

@end
