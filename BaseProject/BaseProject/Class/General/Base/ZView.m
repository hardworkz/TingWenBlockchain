//
//  ZView.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZView.h"

@implementation ZView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self z_setupViews];
        [self z_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<ZViewModelProtocol>)viewModel {
    
    self = [super init];
    if (self) {
        
        [self z_setupViews];
        [self z_bindViewModel];
    }
    return self;
}

- (void)z_bindViewModel {
}

- (void)z_setupViews {
}

- (void)z_addReturnKeyBoard {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [tap.rac_gestureSignal subscribeNext:^(id x) {
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.window endEditing:YES];
    }];
    [self addGestureRecognizer:tap];
}

@end
