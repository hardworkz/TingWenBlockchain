//
//  UITextField+Extension.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "UITextField+Extension.h"

@implementation UITextField (Extension)

#pragma mark - 输入框范围限制

- (void)spaceToLeft:(CGFloat)space
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, space, 1)];
    self.leftViewMode = UITextFieldViewModeAlways;
    self.leftView = leftView;
}

- (void)spaceToRight:(CGFloat)space
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, space, 1)];
    self.rightViewMode = UITextFieldViewModeAlways;
    self.rightView = rightView;
}

@end
