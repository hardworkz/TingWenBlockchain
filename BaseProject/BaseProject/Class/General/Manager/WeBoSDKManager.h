//
//  WeBoSDKManager.h
//  BaseProject
//
//  Created by 泡果 on 2018/7/6.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeBoSDKManager : NSObject<WeiboSDKDelegate>

/**
 授权登录token
 */
@property (strong, nonatomic) NSString *wbtoken;
/**
 授权刷新token
 */
@property (strong, nonatomic) NSString *wbRefreshToken;
/**
 当前用户微博ID
 */
@property (strong, nonatomic) NSString *wbCurrentUserID;

+(instancetype)sharedManager;

/**
 微博第三方注册
 */
+ (void)registerWeiBo;

/**
 QQ授权登录
 */
- (void)authLogin;

/**
 @@分享网页链接
 
 @param urlString 链接
 @param title 标题
 @param description 描述
 @param thumbImage 拇指图
 */
- (void)sendLinkURL:(NSString *)urlString
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(NSString *)thumbImage;

/*! @brief 处理微博通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 微博启动第三方应用时传递过来的URL
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) handleOpenURL:(NSURL *) url;
@end
