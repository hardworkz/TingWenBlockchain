//
//  UITextField+Extension.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Extension)

#pragma mark - 输入框范围限制

/**
 从左边的第几个位置开始输入
 */
- (void)spaceToLeft:(CGFloat)space;

/**
 右边的结束位置
 */
- (void)spaceToRight:(CGFloat)space;

@end
