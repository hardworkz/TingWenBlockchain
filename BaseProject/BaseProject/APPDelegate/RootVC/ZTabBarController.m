//
//  ZTabBarController.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/31.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZTabBarController.h"
#import "RDVTabBar.h"
#import "RDVTabBarItem.h"

@interface ZTabBarController ()

@end

@implementation ZTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ZViewController *Home = [[ZHomeViewController alloc]init];
    UINavigationController *NAV1 = [[UINavigationController alloc] initWithRootViewController:Home];
    
    ZViewController *News = [[ZNewsViewController alloc]init];
    UINavigationController *NAV2 = [[UINavigationController alloc] initWithRootViewController:News];
    
    ZViewController *Market = [[ZMarketViewController alloc]init];
    UINavigationController *NAV3 = [[UINavigationController alloc] initWithRootViewController:Market];
    
    ZViewController *My = [[ZMyViewController alloc]init];
    UINavigationController *NAV4 = [[UINavigationController alloc] initWithRootViewController:My];
    
    self.viewControllers = @[NAV2,NAV1,NAV3,NAV4];
    [self customizeTabBarForController:self];
    
    self.rdv_tabBarItem.y = iPhoneX? SCREEN_HEIGHT - IPHONEX_BOTTOM_H : self.rdv_tabBarItem.y;
}
- (void)customizeTabBarForController:(RDVTabBarController *)tabBarController {
    
    NSArray *tabBarItemImages = @[@"首页select", @"首页select",@"首页select",@"首页select"];
    
    NSInteger index = 0;
    for (RDVTabBarItem *tabberItem in [[tabBarController tabBar] items]) {
        
        switch (index) {
            case 0:
                tabberItem.title = @"首页";
                break;
            case 1:
                tabberItem.title = @"快讯";
                break;
            case 2:
                tabberItem.title = @"行情";
                break;
            case 3:
                tabberItem.title = @"我";
                break;
            default:
                break;
        }
        
        NSDictionary *tabBarTitleUnselectedDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:15]};
        NSDictionary *tabBarTitleSelectedDic = @{NSForegroundColorAttributeName:[UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:15]};
        //修改tabberItem的title颜色
        tabberItem.selectedTitleAttributes = tabBarTitleSelectedDic;
        tabberItem.unselectedTitleAttributes = tabBarTitleUnselectedDic;
        
        UIImage *selectedimage = [UIImage imageNamed:@"首页"];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@",
                                                        [tabBarItemImages objectAtIndex:index]]];
        //设置tabberItem的选中和未选中图片
        [tabberItem setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        
        index++;
    }
}

@end
