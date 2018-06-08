//
//  UIButton+Extension.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)

@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *highlightedTitleColor;
@property (strong, nonatomic) UIColor *selectedTitleColor;

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *highlightedTitle;
@property (copy, nonatomic) NSString *selectedTitle;

@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *highlightedImage;
@property (copy, nonatomic) NSString *selectedImage;

@property (copy, nonatomic) NSString *bgImage;
@property (copy, nonatomic) NSString *highlightedBgImage;
@property (copy, nonatomic) NSString *selectedBgImage;


@end
