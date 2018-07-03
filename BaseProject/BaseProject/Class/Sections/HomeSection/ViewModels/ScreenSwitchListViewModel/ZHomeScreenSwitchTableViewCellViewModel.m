//
//  ZHomeScreenSwitchTableViewCellViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/30.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZHomeScreenSwitchTableViewCellViewModel.h"

@implementation ZHomeScreenSwitchTableViewCellViewModel
+ (void)load {
    [ZHomeScreenSwitchTableViewCellViewModel mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{@"Id":@"id"};
    }];
}
@end
