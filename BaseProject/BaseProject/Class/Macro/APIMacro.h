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

// *******************************首页**************************

/**
 * News/newsList
 * 获取听闻app中听闻区块链新闻内容
 * @param int $limit 条数，可不传，默认10
 * @param int $max_id 列表最大id，刷新时传
 * @param int $min_id 列表最小id，加载更多时传
 * @param int $type 数据类型
 *                  0：听闻区块链新闻
 *                  1：专栏推荐
 * @return json
 */
#define HOME_NEWS_LIST string(REQUEST_URL, @"News/newsList")
/**
 * News/newsDetail
 * 获取新闻详情
 * @param int $id 新闻id，必传
 * @return json
 */
#define HOME_NEWS_DETAIL string(REQUEST_URL, @"News/newsDetail")
/**
 * News/column
 * 获取区块链专栏图片和id
 * @return json
 */
#define HOME_COLUMN string(REQUEST_URL, @"News/column")
/**
 * News/columnDetail
 * 专栏详情及加载更多
 * @param int $id 专栏id，获取专栏信息时传入，加载更多时不传入
 * @param int $min_id 专栏新闻列表最小id，加载更多时传入，第一次进入专栏不传，传入会获取不到专栏信息
 * @param int $limit 每页显示条数，默认10，非必要参数
 * @return json
 */
#define HOME_COLUMN_DETAIL string(REQUEST_URL, @"News/columnDetail")

// *******************************快讯**************************

/**
 * Flash/flash
 * 获取快讯内容
 * @param int $max_id 列表最大id，必需
 * @param int $min_id 列表最小id，必需
 * @param int $limit 返回列表数量,非必需
 * @return json
 */
#define FLASH_LIST string(REQUEST_URL, @"Flash/flash")
/**
 * Flash/flashAll
 * 快讯：全部界面
 * @param int $max_id 刷新界面时传入
 * @param int $min_id 加载更多时传入
 * @return json
 */
#define FLASH_ALL_LIST string(REQUEST_URL, @"Flash/flashAll")
/**
 * Flash/bullOrBear
 * 利好/利空
 * @param int $id 快讯id
 * @param int $type 利好：1，利空：0
 * @param str $token 用户标识
 * @return json
 */
#define FLASH_BULL_OR_BEAR string(REQUEST_URL, @"Flash/bullOrBear")


// *******************************行情**************************


// *******************************我的**************************
/**
 * User/register
 * 注册接口
 * @param str $user_phone 用户手机号
 * @param str $user_pass 用户密码
 * @param sms_code 验证码
 * @return json
 */
#define USER_REGISTER string(REQUEST_URL, @"User/register")
/**
 * User/smsCode
 * 短信验证码
 * @param str $phone 用户手机号
 * @param int $type 验证码类型，1：注册   2：微信绑定手机号 3:修改密码
 * @return json
 */
#define USER_SMS_CODE string(REQUEST_URL, @"User/smsCode")
/**
 * User/bindingPhone
 * 第三方登陆用户绑定手机号
 * @param str $token 用户token
 * @param str $user_phone 用户手机号
 * @param int $sms_code 验证码
 * @return [type] [description]
 */
#define USER_BINDING_PHONE string(REQUEST_URL, @"User/bindingPhone")
/**
 * User/login
 * 用户登陆接口
 * @param str $user_phone 用户手机号
 * @param str $user_pass 用户密码
 * @return [type] [description]
 */
#define USER_LOGIN string(REQUEST_URL, @"User/login")



static NSString *const status = @"status";
static NSString *const msg = @"msg";
static NSString *const results = @"results";






