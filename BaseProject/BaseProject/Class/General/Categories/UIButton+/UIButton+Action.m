//
//  UIButton+Action.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "UIButton+Action.h"

@implementation UIButton (Action)

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark - Block

static const char *kButtonActionBlockKey = "kButtonActionBlockKey";

- (void)addTouchUpInsideActionForBlock:(ButtonActionBlock)aBlock
{
    [self addTarget:self action:@selector(respondsToTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    aBlock = [aBlock copy];
    // 设置关联
    objc_setAssociatedObject(self, kButtonActionBlockKey, aBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)respondsToTouchUpInside:(UIButton *)sender
{
    // 获取Block
    ButtonActionBlock block = objc_getAssociatedObject(self, kButtonActionBlockKey);
    if (block) {
        block(sender);
    }
}

#pragma mark - 自定义title和image位置

- (void)edgeInsetsStyle:(YXButtonEdgeInsetsStyle)style imgTitleSpace:(CGFloat)space {
    /**
     *  知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
     *  如果只有title，那它上下左右都是相对于button的，image也是一样；
     *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
     */
    
    // 1. 得到imageView和titleLabel的宽、高
    CGFloat imageWith = self.imageView.frame.size.width;
    CGFloat imageHeight = self.imageView.frame.size.height;
    
    CGFloat labelWidth = 0.0;
    CGFloat labelHeight = 0.0;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        labelWidth = self.titleLabel.intrinsicContentSize.width;
        labelHeight = self.titleLabel.intrinsicContentSize.height;
    } else {
        labelWidth = self.titleLabel.frame.size.width;
        labelHeight = self.titleLabel.frame.size.height;
    }
    
    // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
    UIEdgeInsets imageEdgeInsets = UIEdgeInsetsZero;
    UIEdgeInsets labelEdgeInsets = UIEdgeInsetsZero;
    
    // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
    /**
     YXButtonEdgeInsetsStyleTop, // image在上，label在下
     YXButtonEdgeInsetsStyleLeft, // image在左，label在右
     YXButtonEdgeInsetsStyleBottom, // image在下，label在上
     YXButtonEdgeInsetsStyleRight // image在右，label在左
     */
    switch (style) {
        case ImageTop:
        {
//            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space/2.0, 0, 0, -labelWidth);
//            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith, -imageHeight-space/2.0, 0);
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-space, 0, 0, - labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(0, - imageWith, - imageHeight - space, 0);
        }
            break;
        case ImageLeft:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, -space/2.0, 0, space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, space/2.0, 0, -space/2.0);
        }
            break;
        case ImageBottom:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-space/2.0, -labelWidth);
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight-space/2.0, -imageWith, 0, 0);
        }
            break;
        case ImageRight:
        {
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+space/2.0, 0, -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith-space/2.0, 0, imageWith+space/2.0);
        }
            break;
        default:
            break;
    }
    
    // 4. 赋值
    self.titleEdgeInsets = labelEdgeInsets;
    self.imageEdgeInsets = imageEdgeInsets;
}

@end
