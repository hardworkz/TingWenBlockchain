//
//  SubmitView.h
//  SubmitAnimation
//
//  Created by David on 16/2/19.
//  Copyright © 2016年 com.david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubmitButton.h"
#import "SubmitLabel.h"


@interface SubmitView : UIView

@property (nonatomic, copy) void (^clickedSubmitBlock)(SubmitButton *button);
/**
 加载完成，结束动画
 */
- (void)loadCompleteSuccess;
/**
 加载失败，结束动画
 */
- (void)loadCompletefailure;
@end
