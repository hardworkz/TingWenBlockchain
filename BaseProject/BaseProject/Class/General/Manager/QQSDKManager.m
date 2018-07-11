//
//  QQSDKManager.m
//  BaseProject
//
//  Created by 泡果 on 2018/7/6.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "QQSDKManager.h"

@implementation QQSDKManager
#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static QQSDKManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[QQSDKManager alloc] init];
    });
    return instance;
}

/**
 QQ第三方注册
 */
+ (void)registerQQ {
    
    //注册QQ
    [QQSDKManager sharedManager].tencentOAuth = [[TencentOAuth alloc] initWithAppId:kAppId_QQ andDelegate:[QQSDKManager sharedManager]];
}

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
            InScene:(enum QQScene)scene {
    
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:urlString]
                                title:title
                                description:description
                                previewImageURL:[NSURL URLWithString:thumbImage]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    switch (scene) {
        case QQSceneQQ:{
            //将内容分享到qq
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                QQApiSendResultCode sent = [QQApiInterface sendReq:req];
                if (sent == EQQAPISENDSUCESS) {
                    ZLog(@"分享QQ成功");
                }
            });
        }
            break;
        case QQSceneQZone:{
            //将内容分享到qzone
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
                if (sent == EQQAPISENDSUCESS) {
                    ZLog(@"分享QQ空间成功");
                }
            });
        }
            break;
        default:
            break;
    }
}

/**
 QQ授权登录
 */
- (void)authLogin {
    
    NSArray *permissions = [NSArray arrayWithObjects:
                   kOPEN_PERMISSION_GET_USER_INFO,
                   kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                   kOPEN_PERMISSION_ADD_SHARE,
                   nil];
    [_tencentOAuth authorize:permissions inSafari:NO];
}


/**
 系统会调用QQ回调方法（我们需要提前实现）QQ登录

 @param response 返回信息
 */
-(void)getUserInfoResponse:(APIResponse *)response{
    
    NSString *name = response.jsonResponse[@"nickname"];
    NSString *head = @"";
    if ([response.jsonResponse[@"figureurl_qq_2"] isEqualToString:@""]){
        head = response.jsonResponse[@"figureurl_qq_1"];
    }
    else{
        head = response.jsonResponse[@"figureurl_qq_2"];
    }
    //这里处理登录逻辑，上传数据到自己的服务器
}

- (void)tencentDidLogin {
    
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        //  记录登录用户的OpenID、Token以及过期时间
        //        tokenLable.text =tencentOAuth.accessToken;
        NSLog(@"tencentOAuth.accessToken = %@",_tencentOAuth.accessToken);
//        openid = _tencentOAuth.openId;
//        access_token = _tencentOAuth.accessToken;
//        expires_in = _tencentOAuth.expirationDate;
    }
    else
    {
        //        tokenLable.text =@"登录不成功没有获取accesstoken";
        NSLog(@"登录不成功没有获取accesstoken");
    }
    [_tencentOAuth getUserInfo];
}
//非网络错误导致登录失败：
-(void)tencentDidNotLogin:(BOOL)cancelled{
    NSLog(@"tencentDidNotLogin");
    if (cancelled){
        NSLog(@"用户取消登录");
    }
    else{
        NSLog(@"登录失败");
    }
}
// 网络错误导致登录失败：
-(void)tencentDidNotNetWork{
    NSLog(@"无网络连接，请设置网络");
}
/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response {
    
}
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req {
    NSLog(@"%@",req);
}
/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp {
    NSLog(@"%@",resp.errorDescription);
}

@end
