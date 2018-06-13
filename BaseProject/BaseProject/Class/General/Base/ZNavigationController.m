//
//  ZNavigationController.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZNavigationController.h"

@interface ZNavigationController ()

@end

@implementation ZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [self.viewControllers.lastObject preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    
    return self.topViewController;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    RDVTabBarController *VC = (RDVTabBarController *)self.parentViewController;
    if (self.childViewControllers.count > 0) {
        [VC setTabBarHidden:YES animated:NO];
    }
    [super pushViewController:viewController animated:animated];
}
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    RDVTabBarController *VC = (RDVTabBarController *)self.parentViewController;
    if (self.childViewControllers.count <= 2) {
        [VC setTabBarHidden:NO animated:NO];
    }
    return [super popViewControllerAnimated:animated];
}
@end
