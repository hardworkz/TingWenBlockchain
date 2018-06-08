//
//  UIImage+Scale.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Scale)
+ (id)colorImg:(UIColor*)color;
+ (id)colorImg:(UIColor*)color size:(CGSize)size;
//尺寸压缩，质量不变
- (UIImage *)scaleToSize:(CGSize)size;
//质量压缩，尺寸不变，可能压缩不到你要的大小，因为没办法到那么小 这时候你就需要调用尺寸压缩了
- (NSData *)dataInNoSacleLimitBytes:(NSInteger)bytes;
//裁剪图片 取中上部分
- (UIImage *)cutToSize:(CGSize)size;

@end
