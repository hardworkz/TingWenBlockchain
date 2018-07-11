//
//  ZHomeListTableViewCellViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/31.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZHomeListTableViewCellViewModel.h"

@implementation ZHomeListTableViewCellViewModel
+ (void)load {
    [ZHomeListTableViewCellViewModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id":@"id"};
    }];
}
@end
