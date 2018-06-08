//
//  Z_AvoidCrashTool.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Z_AvoidCrashTool : NSObject
/**
 主要调用该方法,对服务器返回的数据，数组，字典，字符串，NSNumber类型做容错处理，替换掉（null）,nil,<null>,null等进行替换，替换为空字符串@""
 
 @param obj 判断数据
 @return 返回判断后进行替换的数据
 */
+ (id)replaceNullData:(id)obj;
@end
