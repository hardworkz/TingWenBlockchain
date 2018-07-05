//
//  ZNewsProgramCollectionViewCellViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/7/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZNewsProgramCollectionViewCellViewModel.h"

@implementation ZNewsProgramCollectionViewCellViewModel
+ (void)load
{
    [ZNewsProgramCollectionViewCellViewModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id":@"id"};
    }];
}
@end
