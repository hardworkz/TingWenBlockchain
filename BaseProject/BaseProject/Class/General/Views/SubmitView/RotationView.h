//
//  RotationView.h
//  SubmitView
//
//  Created by 泡果 on 2018/6/7.
//  Copyright © 2018年 com.david. All rights reserved.
//

#import <UIKit/UIKit.h>

#define greenColor [UIColor colorWithRed:33.0/255.0 green:197.0/255.0 blue:131.0/255.0 alpha:1]

@interface RotationView : UIView
+ (instancetype)creatSubmitRotationWithFrame:(CGRect)frame;

- (void)showRotationWithAnimation;

- (void)showRotationView;
- (void)hideRotationView;
@end
