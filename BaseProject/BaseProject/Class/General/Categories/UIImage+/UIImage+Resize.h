//
//  UIImage+Resize.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

+ (UIImage *)imageWithNamed:(NSString *)name;
+ (UIImage *)resizeImageWithNamed:(NSString *)name;
+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)resizableImage:(NSString *)name;
@end
