//
//  SubmitView.m
//  SubmitAnimation
//
//  Created by David on 16/2/19.
//  Copyright © 2016年 com.david. All rights reserved.
//

#import "SubmitView.h"
#import "RotationView.h"

@interface SubmitView ()

@property(nonatomic, strong) SubmitButton *submitButton;

@property(nonatomic, strong) SubmitLabel *showLabel;

@property(nonatomic, strong) RotationView *rotationView;

@property(nonatomic, assign) CGRect originRect;
@property(nonatomic, assign) CGPoint viewCenter;

@property (nonatomic, copy) NSString *downloadUrl;

@end

@implementation SubmitView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _originRect = self.bounds;
        [self setupSubViews]; 
    }
    return self;
}

- (void)setupSubViews {
    _submitButton = [SubmitButton creatSubmitButtonWithFrame:self.bounds]; 
    [_submitButton addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_submitButton addTarget:self action:@selector(buttonTouchDown) forControlEvents:UIControlEventTouchDown];
    [self addSubview:_submitButton];
    
    _showLabel = [[SubmitLabel alloc] initWithFrame:self.bounds];
    [self addSubview:_showLabel];
}

- (void)buttonTouchDown {
    [_showLabel touchDownAnimation];
} 

- (void)submitBtnClick:(UIButton *)submitBtn {
    //缩小动画
    [self scaleLayerAnimtaion];
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        //隐藏按钮
        self.showLabel.alpha = 0;
        [self.submitButton setHiddenSubmitButton];
    } completion:^(BOOL finished) {
        self.submitButton.hidden = YES;
        [self drawProgressLayer];
        if (self.clickedSubmitBlock) {
            self.clickedSubmitBlock(self.submitButton);
        }
    }];
}

- (void)setupSureLayer {
    self.showLabel.hidden = YES;
    CAShapeLayer *sureLayer = [CAShapeLayer layer];
    sureLayer.fillColor = [UIColor whiteColor].CGColor;
    sureLayer.strokeColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *newPath = [UIBezierPath bezierPath];
    [newPath moveToPoint:(CGPoint){_viewCenter.x-5 , _viewCenter.y}];
    [newPath addLineToPoint:CGPointMake(_viewCenter.x, _viewCenter.y + 5)];
    [newPath addLineToPoint:CGPointMake(_viewCenter.x+10, _viewCenter.y -5)];
    
    sureLayer.path = newPath.CGPath;
    [self.submitButton.layer addSublayer:sureLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    
    [sureLayer addAnimation:pathAnimation forKey:nil];
}

//进度环动画
- (void)drawProgressLayer {
    _viewCenter = (CGPoint){self.bounds.size.width/2, self.bounds.size.height/2};
    
    CGFloat layerWith = 3.0;
    CGFloat progressRadius = self.bounds.size.height/2;
    CGFloat progressX = self.bounds.size.width/2-progressRadius-layerWith;
    CGFloat progressWH = self.bounds.size.height + 2*layerWith;
    CGRect progressFrame = (CGRect){{progressX, -layerWith}, {progressWH, progressWH}};
    
    //创建一个进度环view
    _rotationView = [RotationView creatSubmitRotationWithFrame:progressFrame];
    [self addSubview:_rotationView];
    [_rotationView showRotationWithAnimation];
    
    [UIView animateWithDuration:0.5  animations:^{
        self.rotationView.layer.opacity = 1.0;
    }];
}


//成功动画
- (void)expandLayerAnimation {
    [_rotationView removeFromSuperview];
    [_submitButton setShowSubmitButton];
    [_showLabel showLabelAnimation];

}
//失败恢复原状
- (void)expandLayerAnimationFailure {
    [_rotationView removeFromSuperview];
    [_submitButton setShowSubmitButton];
    [_showLabel showLabelAnimationWihtFailure];
    
//    CABasicAnimation *anima = [CABasicAnimation animation];
//    anima.duration = 1.0;
//    anima.keyPath = @"bounds";
//    anima.toValue = [NSValue valueWithCGRect:_originRect];
//    anima.removedOnCompletion = NO;
//    anima.fillMode = kCAFillModeForwards;
//    [self.submitButton.layer addAnimation:anima forKey:nil];
    [self springAni];
}
- (void)springAni {
    CASpringAnimation * ani = [CASpringAnimation animationWithKeyPath:@"bounds"];
    ani.mass = 5.0; //质量，影响图层运动时的弹簧惯性，质量越大，弹簧拉伸和压缩的幅度越大
    ani.stiffness = 5000; //刚度系数(劲度系数/弹性系数)，刚度系数越大，形变产生的力就越大，运动越快
    ani.damping = 50.0;//阻尼系数，阻止弹簧伸缩的系数，阻尼系数越大，停止越快
    ani.initialVelocity = 1.f;//初始速率，动画视图的初始速度大小;速率为正数时，速度方向与运动方向一致，速率为负数时，速度方向与运动方向相反
    ani.duration = ani.settlingDuration;
    ani.toValue = [NSValue valueWithCGRect:_originRect];
    ani.removedOnCompletion = NO;
    ani.fillMode = kCAFillModeForwards;
    ani.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.submitButton.layer addAnimation:ani forKey:@"boundsAni"];
}
//缩放动画
- (void)scaleLayerAnimtaion {
    CABasicAnimation *anima = [CABasicAnimation animation];
    anima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    anima.duration = 0.5;
    anima.keyPath = @"bounds";
    anima.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, _originRect.size.height, _originRect.size.height)];
    anima.removedOnCompletion = NO;
    anima.fillMode = kCAFillModeForwards;
    [self.submitButton.layer addAnimation:anima forKey:nil];
}
- (void)loadCompleteSuccess
{
    //改代码放在登录请求成功的回调里面
    [UIView animateWithDuration:0.5 animations:^{
        [self expandLayerAnimation];
    }];
}
- (void)loadCompletefailure
{
    [UIView animateWithDuration:0.5 animations:^{
        [self expandLayerAnimationFailure];
    }];
}
@end
