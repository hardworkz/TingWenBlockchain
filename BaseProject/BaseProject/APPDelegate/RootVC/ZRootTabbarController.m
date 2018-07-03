//
//  ZRootTabbarController.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZRootTabbarController.h"

@interface ZRootTabbarController ()

@end

@implementation ZRootTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZViewController *Home = [[ZHomeViewController alloc]init];
    [self setTitle:@"快讯" image:@"kx" viewController:Home];
    ZNavigationController *NAV1 = [[ZNavigationController alloc] initWithRootViewController:Home];
    
    ZViewController *News = [[ZNewsViewController alloc]init];
    [self setTitle:@"首页" image:@"sy" viewController:News];
    ZNavigationController *NAV2 = [[ZNavigationController alloc] initWithRootViewController:News];
    
    ZViewController *Market = [[ZMarketViewController alloc]init];
    [self setTitle:@"行情" image:@"hq" viewController:Market];
    ZNavigationController *NAV3 = [[ZNavigationController alloc] initWithRootViewController:Market];
    
    ZViewController *My = [[ZMyViewController alloc]init];
    [self setTitle:@"我" image:@"wo" viewController:My];
    ZNavigationController *NAV4 = [[ZNavigationController alloc] initWithRootViewController:My];
    
    self.itemTitleFont          = [UIFont boldSystemFontOfSize:13];
    self.itemTitleColor         = MAIN_TEXT_COLOR;
    self.selectedItemTitleColor = MAINCOLOR;
    
    self.viewControllers        = @[NAV2, NAV1, NAV3, NAV4];
}
/**
 设置tabbar控制器的属性
 
 @param title 标题
 @param image 图片
 @param viewController 控制器
 */
- (void)setTitle:(NSString *)title image:(NSString *)image viewController:(UIViewController *)viewController
{
//    viewController.tabBarItem.badgeValue = @"1";
    viewController.title = title;
    viewController.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@0",image]];
    viewController.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",image]];
}

@end
