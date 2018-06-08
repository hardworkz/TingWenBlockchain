//
//  SubmitLabel.h
//  SubmitAnimation
//
//  Created by David on 16/2/22.
//  Copyright © 2016年 com.david. All rights reserved.
//

#import <UIKit/UIKit.h>

#define defaultText @"登录"
#define defaultTextColor [UIColor whiteColor]
#define textFont [UIFont systemFontOfSize:17];

@interface SubmitLabel : UILabel

+ (instancetype)creatSubmitLabelWithFrame:(CGRect)frame;
- (void)touchDownAnimation;

- (void)showLabelAnimation;
- (void)showLabelAnimationWihtFailure;
@end
