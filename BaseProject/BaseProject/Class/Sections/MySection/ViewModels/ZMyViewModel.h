//
//  ZMyViewModel.h
//  BaseProject
//
//  Created by 泡果 on 2018/6/5.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewModel.h"

@interface ZMyViewModel : ZViewModel

@property (nonatomic, strong) RACSubject *refreshUI;

@property (nonatomic, strong) RACSubject *headClickSubject;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) RACSubject *cellClickSubject;
@end
