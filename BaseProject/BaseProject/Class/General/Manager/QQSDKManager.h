//
//  QQSDKManager.h
//  BaseProject
//
//  Created by 泡果 on 2018/7/6.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

/*! @brief QQ请求发送场景
 *
 */
enum QQScene {
    QQSceneQQ  = 0,        /**< 聊天界面    */
    QQSceneQZone = 1       /**< QQ空间      */
};

@interface QQSDKManager : NSObject<TencentSessionDelegate,TencentLoginDelegate,QQApiInterfaceDelegate>

@property (nonatomic, strong) TencentOAuth *tencentOAuth;

+(instancetype)sharedManager;

/**
 QQ第三方注册
 */
+ (void)registerQQ;
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
 @param scene 分享类型
 */
+ (void)sendLinkURL:(NSString *)urlString
              Title:(NSString *)title
        Description:(NSString *)description
         ThumbImage:(NSString *)thumbImage
            InScene:(enum QQScene)scene;

@end
