//
//  UIView+Extension.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

@property (nonatomic) CGFloat x;           // < frame.origin.x
@property (nonatomic) CGFloat y;           // < frame.origin.y
@property (nonatomic) CGFloat left;        // < frame.origin.x
@property (nonatomic) CGFloat top;         // < frame.origin.y
@property (nonatomic) CGFloat right;       // < frame.origin.x + frame.size.width
@property (nonatomic) CGFloat bottom;      // < frame.origin.y + frame.size.height
@property (nonatomic) CGFloat width;       // < frame.size.width.
@property (nonatomic) CGFloat height;      // < frame.size.height.
@property (nonatomic) CGFloat centerX;     // < center.x
@property (nonatomic) CGFloat centerY;     // < center.y
@property (nonatomic) CGPoint origin;      // < frame.origin.
@property (nonatomic) CGSize  size;        // < frame.size.

/**
 清除所有加在本视图上的视图和图层
 */
- (void)clearAll;
@end
