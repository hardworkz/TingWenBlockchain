//
//  UIColor+Extension.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Extension)

/**
 将十六进制数直接转化为UIColor对象
 */
UIColor * ColorWithHex(uint32_t hexColor);

/**
 根据十六进制和颜色的透明度初始化UIColor对象
 */
UIColor * ColorWithHexAndOpacity(uint32_t hexColor,CGFloat opacity);

/**
 根据比例将两个颜色混合，返回UIColor对象
 @param ratio 混合比例，color1*ratio+color2*ratio
 */
UIColor * MixColor(UIColor *color1, UIColor *color2, CGFloat ratio);

/**
 根据UIColor对象初始化一个UIImage对象，UIImage对象的大小由rect控制
 */
UIImage * CreateImageWithColor(UIColor * color, CGRect rect);

@end
