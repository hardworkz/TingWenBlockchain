//
//  APIMacro.h
//  PeachNet
//
//  Created by 牛哲 on 15/6/16.
//  Copyright (c) 2015年 王隆帅. All rights reserved.
//

/**
 *  本文件可放请求API 拼接的路径
 */

// *******************************王隆帅**************************

/**
 首页听闻区块链列表
 */
#define HOME_NEWS_LIST string(REQUEST_URL, @"News/newsList")
/**
 首页听闻区块链详情页
 */
#define HOME_NEWS_DETAIL string(REQUEST_URL, @"News/newsDetail")
/**
 快讯推荐列表
 */
#define FLASH_LIST string(REQUEST_URL, @"Flash/flash")
/**
 快讯全部列表
 */
#define FLASH_ALL_LIST string(REQUEST_URL, @"Flash/flashAll")


static NSString *const status = @"status";
static NSString *const msg = @"msg";
static NSString *const results = @"results";






