//
//  ZViewControllerProtocol.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ZViewModelProtocol;

@protocol ZViewControllerProtocol <NSObject>

@optional
- (instancetype)initWithViewModel:(id <ZViewModelProtocol>)viewModel;

- (void)z_bindViewModel;
- (void)z_addSubviews;
- (void)z_layoutNavigation;
- (void)z_getNewData;
- (void)recoverKeyboard;

@end
