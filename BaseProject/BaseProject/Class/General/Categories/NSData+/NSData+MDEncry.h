//
//  NSData+MDEncry.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MDEncry)

#pragma mark - NSData -> NSString

+ (NSString *)stringFromData:(NSData *)aData;
- (NSString *)dataString;

#pragma mark - NSData -> NSDictionary

+ (NSDictionary *)dictionaryFromData:(NSData *)aData;
- (NSDictionary *)dataDictionary;

#pragma mark - md

- (NSString *)md2String;
- (NSString *)md4String;
- (NSString *)md5String;
- (NSData *)md2Data;
- (NSData *)md4Data;
- (NSData *)md5Data;
@end
