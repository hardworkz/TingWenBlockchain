//
//  ZHomeListViewModel.h
//  BaseProject
//
//  Created by 泡果 on 2018/5/31.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewModel.h"

@interface ZHomeListViewModel : ZViewModel

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshUI;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
