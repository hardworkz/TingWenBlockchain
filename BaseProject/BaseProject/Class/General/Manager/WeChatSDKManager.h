//
//  WeChatSDKManager.h
//  BaseProject
//
//  Created by 泡果 on 2018/7/6.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface WeChatSDKManager : NSObject<WXApiDelegate>

+(instancetype)sharedManager;


/**
 微信第三方注册
 */
+ (void)registerWeChat;

/**
 微信授权登录
 */
+ (BOOL)authLogin;

/**
 微信分享网页链接
 
 @param urlString 链接
 @param title 标题
 @param description 描述
 @param thumbImage 拇指图
 @param scene 分享类型
 @return 是否成功
 */
+ (BOOL)sendLinkURL:(NSString *)urlString
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(NSString *)thumbImage
            InScene:(enum WXScene)scene;

/**
 调起微信支付
 
 @param openID 由用户微信号和AppID组成的唯一标识，发送请求时第三方程序必须填写，用于校验微信用户是否换号登录
 @param partnerId 商家向财付通申请的商家id
 @param prepayId 预支付订单
 @param nonceStr 随机串，防重发
 @param timestamp 时间戳，防重发
 @param package 商家根据财付通文档填写的数据和签名
 @param sign 商家根据微信开放平台文档对数据做的签名
 @return 成功返回YES，失败返回NO
 */
+ (BOOL)wechatPayWithOpenID:(NSString *)openID
                  partnerId:(NSString *)partnerId
                   prepayId:(NSString *)prepayId
                   nonceStr:(NSString *)nonceStr
                  timestamp:(NSString *)timestamp
                    package:(NSString *)package
                       sign:(NSString *)sign;

/*! @brief 处理微信通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 微信启动第三方应用时传递过来的URL
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) handleOpenURL:(NSURL *) url;
@end
