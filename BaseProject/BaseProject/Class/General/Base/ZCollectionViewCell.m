//
//  ZCollectionViewCell.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/28.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZCollectionViewCell.h"

@implementation ZCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self z_setupViews];
    }
    return self;
}

- (void)z_setupViews {}

@end
