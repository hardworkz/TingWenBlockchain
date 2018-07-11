//
//  WeChatSDKManager.m
//  BaseProject
//
//  Created by 泡果 on 2018/7/6.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "WeChatSDKManager.h"

@implementation WeChatSDKManager
#pragma mark - LifeCycle
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WeChatSDKManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[WeChatSDKManager alloc] init];
    });
    return instance;
}
/**
 微信第三方注册
 */
+ (void)registerWeChat {
    
    //向微信注册
    [WXApi registerApp:KweChatappID enableMTA:YES];
    
    //向微信注册支持的文件类型
//    UInt64 typeFlag = MMAPP_SUPPORT_TEXT | MMAPP_SUPPORT_PICTURE | MMAPP_SUPPORT_LOCATION | MMAPP_SUPPORT_VIDEO |MMAPP_SUPPORT_AUDIO | MMAPP_SUPPORT_WEBPAGE | MMAPP_SUPPORT_DOC | MMAPP_SUPPORT_DOCX | MMAPP_SUPPORT_PPT | MMAPP_SUPPORT_PPTX | MMAPP_SUPPORT_XLS | MMAPP_SUPPORT_XLSX | MMAPP_SUPPORT_PDF;
//    
//    [WXApi registerAppSupportContentFlag:typeFlag];
}

/**
 微信授权登录
 */
+ (BOOL)authLogin {
    if (![WXApi isWXAppInstalled]){
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请安装微信" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [al show];
        return NO;
    }
    //构造SendAuthReq结构体
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    req.state = @"1234567890";//瞎填就行，据说用于防攻击
    
    //第三方向微信终端发送一个SendAuthReq消息结构
    return [WXApi sendReq:req];
}

/*! @brief 处理微信通过URL启动App时传递的数据
 *
 * 需要在 application:openURL:sourceApplication:annotation:或者application:handleOpenURL中调用。
 * @param url 微信启动第三方应用时传递过来的URL
 * @return 成功返回YES，失败返回NO。
 */
+(BOOL) handleOpenURL:(NSURL *) url {
    return [WXApi handleOpenURL:url delegate:[WeChatSDKManager sharedManager]];
}

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
         ThumbImage:(UIImage *)thumbImage
            InScene:(enum WXScene)scene {
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaObject = ext;
    [message setThumbImage:thumbImage];
    
    SendMessageToWXReq* req = [self requestWithText:nil
                                     OrMediaMessage:message
                                              bText:NO
                                            InScene:scene];
    return [WXApi sendReq:req];
}

/**
 封装SendMessageToWXReq对象

 @param text 标题
 @param message 分享对象
 @param bText 是否文本
 @param scene 分享类型
 @return SendMessageToWXReq对象
 */
+ (SendMessageToWXReq *)requestWithText:(NSString *)text
                         OrMediaMessage:(WXMediaMessage *)message
                                  bText:(BOOL)bText
                                InScene:(enum WXScene)scene {
    if (![WXApi isWXAppInstalled]){
        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先安装微信" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [al show];
        return nil;
    }
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = bText;
    req.scene = scene;
    if (bText)
        req.text = text;
    else
        req.message = message;
    return req;
}

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
                       sign:(NSString *)sign {
    
    //调起微信支付
    PayReq *req             = [[PayReq alloc] init];
    req.openID              = openID;
    req.partnerId           = partnerId;
    req.prepayId            = prepayId;
    req.nonceStr            = nonceStr;
    req.timeStamp           = timestamp.intValue;
    req.package             = package;
    req.sign                = sign;
    return [WXApi sendReq:req];
}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 */
-(void)onResp:(BaseResp*)resp {
    
    ZLog(@"%d",resp.errCode);
    
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:{
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                
                //注册微信
                [WXApi registerApp:KweChatappID];
            }
                break;
            default:{
                //注册微信
                [WXApi registerApp:KweChatappID];
                
                NSLog(@"支付失败，retcode=%d",resp.errCode);
            }
                break;
        }
    }
    else if ([resp isKindOfClass:[SendAuthResp class]]){
        
        SendAuthResp *response = (SendAuthResp*)resp;
        if (response.errCode == 0) {
            //微信授权成功
            [self WechatSSOSuccessWithCode:response.code];
        }
    }
}

/**
 微信授权成功处理，获取用户数据

 @param code 微信返回码
 */
- (void)WechatSSOSuccessWithCode:(NSString *)code{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 40;
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",nil];
    [manager GET:[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",KweChatappID,KweChatAppSecret,code] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //这里处理微信获得的用户信息，上传到自己的服务器
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
@end
