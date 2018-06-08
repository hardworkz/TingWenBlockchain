//
//  UIView+Gesture.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Gesture)
/**
 *  快速为UIView添加一个Tap 手势
 *
 *  @param sender 手势响应对象
 *  @param action 手势响应对象调用的函数
 *
 *  @return 手势
 */
-(UITapGestureRecognizer *)addTapGestureWithTarget:(id)sender action:(SEL)action;

-(UILongPressGestureRecognizer *)addLongPressGestureWithTarget:(id)sender action:(SEL)action;

/**
 *  快速为UIView 添加一个点击block 回调
 */
-(void)addTapCallBack:(void (^)(id _Nullable gesture,...)) cb;


/**
 *  移除所有手势
 */
-(void)removeAllGesture;
@end
