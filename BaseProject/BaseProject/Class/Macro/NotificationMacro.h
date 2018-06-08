//
//  NotificationMacro.h
//  PeachNet
//
//  Created by 牛哲 on 15/6/21.
//  Copyright (c) 2015年 王隆帅. All rights reserved.
//

/**
 *  本类放一些通知的宏定义
 */
// 消息通知
#define RegisterNotify(_name, _selector)                    \
[[NSNotificationCenter defaultCenter] addObserver:self  \
selector:_selector name:_name object:nil];

#define RemoveNofify            \
[[NSNotificationCenter defaultCenter] removeObserver:self];

#define SendNotify(_name, _object)  \
[[NSNotificationCenter defaultCenter] postNotificationName:_name object:_object];
