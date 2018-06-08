//
//  AppDelegate+AppInitializeWindows.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "AppDelegate+AppInitializeWindows.h"
#import "RDVTabBarController.h"
#import "ZTabBarController.h"

@implementation AppDelegate (AppInitializeWindows)
- (void)setAppWindows
{
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}
- (void)setRootViewController
{
    //获取当前应用版本和上一个应用版本进行比较，如果不相同则为进行过更新
//    IdentityManager *identityManager = [IdentityManager manager];
//    [identityManager readAuthorizeData];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    if (/*[identityManager.identity.lastSoftVersion isEqualToString:currentVersion]*/YES)
    {
        //不是第一次安装
        [self setRoot];
    }
    else
    {
        //新特性界面展示
        UIViewController *emptyView = [[UIViewController alloc] init];
        self.window.rootViewController = emptyView;
        [self createLoadingScrollView];
        
        //保存当前版本号
//        identityManager.identity.lastSoftVersion = currentVersion;
//        identityManager.identity.realmDataVersion += 0.1;
//        [identityManager saveAuthorizeData];
    }
}
- (void)setTabbarController
{
    
}
- (void)setLoginController
{
    
}
- (void)setRoot
{
    [[[UIApplication sharedApplication].delegate window] setRootViewController:[[ZTabBarController alloc] init]/*需要切换的控制器*/];
    
    //切换根控制器动画方案一
//    [UIView transitionWithView:[[UIApplication sharedApplication].delegate window]
//                      duration:0.4
//                       options:UIViewAnimationOptionTransitionCrossDissolve|UIViewAnimationOptionCurveEaseInOut
//    animations:^{
//
//        BOOL oldState = [UIView areAnimationsEnabled];
//
//        [UIView setAnimationsEnabled:NO];
//
//        [[[UIApplication sharedApplication].delegate window] setRootViewController:tabBarController/*需要切换的控制器*/];
//
//        [UIView setAnimationsEnabled:oldState];
//
//    }completion:nil];
    
    //切换根控制器动画方案二
//    CATransition *animation = [CATransition animation];
//
//    [animation setDuration:0.6];//设置动画时间
//
//    animation.type = kCATransitionFade;//设置动画类型
//
//    [[UIApplication sharedApplication].keyWindow.layer addAnimation:animation forKey:nil];
}
#pragma mark - 引导页
/**
 *  首次启动轮播图
 */
- (void)createLoadingScrollView
{
    //引导页
    UIScrollView *sc = [[UIScrollView alloc]initWithFrame:self.window.bounds];
    sc.pagingEnabled = YES;
    sc.delegate = self;
    sc.showsHorizontalScrollIndicator = NO;
    sc.showsVerticalScrollIndicator = NO;
    [self.window.rootViewController.view addSubview:sc];
    
    NSArray *arr = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg"];
    for (NSInteger i = 0; i<arr.count; i++)
    {
        UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, self.window.frame.size.height)];
        img.image = [UIImage imageNamed:arr[i]];
        [sc addSubview:img];
        img.userInteractionEnabled = YES;
        if (i == arr.count - 1)
        {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake((self.window.frame.size.width/2)-50, SCREEN_WIDTH - 110, 100, 40);
            btn.backgroundColor = white_color;
            [btn setTitle:@"开始体验" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(goToMain) forControlEvents:UIControlEventTouchUpInside];
            [img addSubview:btn];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = white_color.CGColor;
        }
    }
    sc.contentSize = CGSizeMake(SCREEN_WIDTH * arr.count, self.window.frame.size.height);
}
- (void)goToMain
{
    [self setRoot];
}
@end
