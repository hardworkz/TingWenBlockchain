//
//  AppDelegate+AppInitializeWindows.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (AppInitializeWindows)<UIScrollViewDelegate>
/**
 *  tabbar实例
 */
- (void)setTabbarController;
/**
 *  login实例
 */
- (void)setLoginController;
/**
 *  window实例
 */
- (void)setAppWindows;
/**
 *  根视图
 */
- (void)setRootViewController;
@end
