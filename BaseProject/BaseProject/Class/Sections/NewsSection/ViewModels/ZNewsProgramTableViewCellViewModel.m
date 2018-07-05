//
//  ZNewsProgramTableViewCellViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/7/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZNewsProgramTableViewCellViewModel.h"
#import "ZNewsProgramCollectionViewCellViewModel.h"

@implementation ZNewsProgramTableViewCellViewModel
+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"column":[ZNewsProgramCollectionViewCellViewModel class]};
}
@end
