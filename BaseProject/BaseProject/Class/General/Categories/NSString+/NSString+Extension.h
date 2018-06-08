//
//  NSString+Extension.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 * 返回字符串的 自定义 大小
 */
- (CGSize)textSizeWithFont:(UIFont *)font constrainedToSize:(CGSize)size;
/**
 根据最大宽度和字号获取NSString的size
 */
- (CGSize)sizeForMaxWidth:(CGFloat)max strFont:(UIFont *)font;

#pragma mark - 数字格式化
// eg: 1234556.0012
typedef NS_ENUM(NSUInteger, NSNFormatStyle) {
    NSNFormatStyleNoStyle = kCFNumberFormatterNoStyle,                                                                  // > 1234556
    NSNFormatStyleDecimalStyle = kCFNumberFormatterDecimalStyle,                                                        // > 1,234,556.001
    NSNFormatStyleCurrencyStyle = kCFNumberFormatterCurrencyStyle,                                                      // > ￥1,234,556.00
    NSNFormatStylePercentStyle = kCFNumberFormatterPercentStyle,                                                        // > 123,455,600%
    NSNFormatStyleScientificStyle = kCFNumberFormatterScientificStyle,                                                  // > 1.2345560012E6
    NSNFormatStyleSpellOutStyle = kCFNumberFormatterSpellOutStyle,                                                      // > 一百二十三万四千五百五十六点〇〇一二
    NSNFormatStyleOrdinalStyle NS_ENUM_AVAILABLE(10_11, 9_0) = kCFNumberFormatterOrdinalStyle,                          // > 第123,4556
    NSNFormatStyleCurrencyISOCodeStyle NS_ENUM_AVAILABLE(10_11, 9_0) = kCFNumberFormatterCurrencyISOCodeStyle,          // > CNY1,234,556.00
    NSNFormatStyleCurrencyPluralStyle NS_ENUM_AVAILABLE(10_11, 9_0) = kCFNumberFormatterCurrencyPluralStyle,            // > 1,234,556.00人民币
    NSNFormatStyleCurrencyAccountingStyle NS_ENUM_AVAILABLE(10_11, 9_0) = kCFNumberFormatterCurrencyAccountingStyle,    // > ￥1,234,556.00
};
+ (NSString *)formatStringForNumber:(NSNumber *)number withStyle:(NSNFormatStyle)style;

#pragma mark - NSString -> NSData

+ (NSData *)dataFromString:(NSString *)aString;
- (NSData *)stingData;

#pragma mark - JSON -> NSDictionary

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
- (NSDictionary *)dictionaryWithJsonString;

#pragma mark - Utils（工具方法）

/**********************************************************************************************
 **********************************************************************************************
 例如：正则判断、时间戳转化、md
 参考资料：http://blog.csdn.net/chaoyuan899/article/details/38583759
 **********************************************************************************************
 **********************************************************************************************/

/// 正则判断
/**
 邮箱格式
 */
+ (BOOL)isVaildEmailForString:(NSString *)aString;
- (BOOL)isVaildEamil;

/**
 电话号
 */
+ (BOOL)isVaildTelphoneFroString:(NSString *)aString;
- (BOOL)isVaildTelphone;

/**
 时间戳按要求转化为字符串
 */
+ (NSString *)timeIntervalToString:(NSTimeInterval)timeInterval forFormat:(NSString *)aFormat;

- (nullable NSString *)md2String;
- (nullable NSString *)md4String;
- (nullable NSString *)md5String;

@end
