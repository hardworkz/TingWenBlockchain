//
//  ZPlayerViewModel.h
//  BaseProject
//
//  Created by 泡果 on 2018/6/27.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZViewModel.h"

@class ZPlayerViewContentTextTableViewCellViewModel;
@interface ZPlayerViewModel : ZViewModel

@property (nonatomic, strong) NSString *post_id;

@property (nonatomic, strong) RACSubject *refreshEndSubject;

@property (nonatomic, strong) RACSubject *refreshUI;

@property (nonatomic, strong) RACCommand *refreshDataCommand;

@property (nonatomic, strong) ZPlayerViewContentTextTableViewCellViewModel *viewModel;

@property (nonatomic, strong) RACSubject *cellClickSubject;

@end
