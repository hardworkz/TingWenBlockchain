//
//  ZMyViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZMyViewModel.h"
#import "ZMyTableViewCellViewModel.h"

@implementation ZMyViewModel
- (void)z_initialize {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (int i = 0; i < 1; i++) {
        
        if (i == 0) {
            ZMyTableViewCellViewModel *viewModel = [[ZMyTableViewCellViewModel alloc] init];
            viewModel.title = @"设置";
            viewModel.icon = @"icon_setting";
            [array addObject:viewModel];
        }
    }
    self.dataArray = array;
    
    [self.refreshUI sendNext:nil];
}
- (RACSubject *)refreshUI {
    
    if (!_refreshUI) {
        
        _refreshUI = [RACSubject subject];
    }
    
    return _refreshUI;
}

- (NSArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [[NSArray alloc] init];
    }
    
    return _dataArray;
}
- (RACSubject *)headClickSubject
{
    if (!_headClickSubject) {
        
        _headClickSubject = [RACSubject subject];
    }
    
    return _headClickSubject;
}
- (RACSubject *)cellClickSubject {
    
    if (!_cellClickSubject) {
        
        _cellClickSubject = [RACSubject subject];
    }
    
    return _cellClickSubject;
}
@end
