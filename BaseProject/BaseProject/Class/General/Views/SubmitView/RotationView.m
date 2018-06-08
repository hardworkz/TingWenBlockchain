//
//  RotationView.m
//  SubmitView
//
//  Created by 泡果 on 2018/6/7.
//  Copyright © 2018年 com.david. All rights reserved.
//

#import "RotationView.h"


@implementation RotationView{
    CGFloat width;
}
+ (instancetype)creatSubmitRotationWithFrame:(CGRect)frame {
    RotationView *rotationView = [[RotationView alloc] initWithFrame:frame];
    return rotationView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        width = frame.size.width;
        self.backgroundColor = [UIColor clearColor];
        self.layer.opacity = 0.;
    }
    return self;
}
- (void)showRotationWithAnimation {
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = greenColor.CGColor; //圆环底色
    layer.frame = CGRectMake(0, 0, width, width);
    
    //创建一个圆环
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width * 0.5, width * 0.5) radius:width * 0.5 - 5 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    
    //圆环遮罩
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = greenColor.CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.strokeStart = 0;
    shapeLayer.strokeEnd = 0.8;
    shapeLayer.lineCap = @"round";
    shapeLayer.lineDashPhase = 0.8;
    shapeLayer.path = bezierPath.CGPath;
    
    //颜色渐变
    NSMutableArray *colors = [NSMutableArray arrayWithObjects:(id)greenColor.CGColor,(id)[UIColor whiteColor].CGColor, nil];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.shadowPath = bezierPath.CGPath;
    gradientLayer.frame = CGRectMake(0, 0, width, width);
    gradientLayer.startPoint = CGPointMake(0, 1);
    gradientLayer.endPoint = CGPointMake(1, 0);
    [gradientLayer setColors:[NSArray arrayWithArray:colors]];
    [layer addSublayer:gradientLayer]; //设置颜色渐变
    [layer setMask:shapeLayer]; //设置圆环遮罩
    [self.layer addSublayer:layer];
    
    //动画
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:6.0*M_PI];
    rotationAnimation.repeatCount = MAXFLOAT;
    rotationAnimation.beginTime = 0.8; //延时执行，注释掉动画会同时进行
    rotationAnimation.duration = 2;
    
    //动画
    [layer addAnimation:rotationAnimation forKey:@"groupAnnimation"];
}
- (void)showRotationView {
    self.hidden = NO;
}
- (void)hideRotationView {
    self.hidden = YES;
}
@end
