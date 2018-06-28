//
//  ZNewsTableViewCellViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/21.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZNewsTableViewCellViewModel.h"

@implementation ZNewsTableViewCellViewModel
+ (void)load
{
    [ZNewsTableViewCellViewModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id":@"id"};
    }];
}
@end
