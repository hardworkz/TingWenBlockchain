//
//  ZHomeScreenSwitchListViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/30.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZHomeScreenSwitchListViewModel.h"
#import "ZHomeScreenSwitchTableViewCellViewModel.h"

@interface ZHomeScreenSwitchListViewModel()

@property (nonatomic, copy) NSString *maxId;

@property (nonatomic, copy) NSString *minId;

@end
@implementation ZHomeScreenSwitchListViewModel

- (void)z_initialize {
    
    @weakify(self);
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        
        @strongify(self);
        
        self.dataArray = [ZHomeScreenSwitchTableViewCellViewModel mj_objectArrayWithKeyValuesArray:dict[results]];
        
        ZHomeScreenSwitchTableViewCellViewModel *first = [self.dataArray firstObject];
        ZHomeScreenSwitchTableViewCellViewModel *last = [self.dataArray lastObject];
        self.maxId = first.Id;
        self.minId = last.Id;
        
        [self.refreshUI sendNext:nil];
        [self.refreshEndSubject sendNext:@(LSFooterRefresh_HasMoreData)];
        DismissHud();
    }];
    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        
        @strongify(self);
        
        NSMutableArray *reArray = [[NSMutableArray alloc] initWithArray:self.dataArray];
        
        [reArray addObjectsFromArray:[ZHomeScreenSwitchTableViewCellViewModel mj_objectArrayWithKeyValuesArray:dict[results]]];
        
        self.dataArray = reArray;
        
        ZHomeScreenSwitchTableViewCellViewModel *first = [self.dataArray firstObject];
        ZHomeScreenSwitchTableViewCellViewModel *last = [self.dataArray lastObject];
        self.maxId = first.Id;
        self.minId = last.Id;
        
        [self.refreshEndSubject sendNext:@(LSFooterRefresh_HasMoreData)];
        DismissHud();
    }];
    
}

- (RACSubject *)refreshUI {
    
    if (!_refreshUI) {
        
        _refreshUI = [RACSubject subject];
    }
    
    return _refreshUI;
}

- (RACSubject *)refreshEndSubject {
    
    if (!_refreshEndSubject) {
        
        _refreshEndSubject = [RACSubject subject];
    }
    
    return _refreshEndSubject;
}

- (RACCommand *)refreshDataCommand {
    
    if (!_refreshDataCommand) {
        
        @weakify(self);
        _refreshDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
                [parameter setObject:@"10" forKey:@"limit"];
                [self.request POST:FLASH_LIST parameters:parameter success:^(CMRequest *request, id responseObject) {

                    NSDictionary *dict = responseObject;
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];

                } failure:^(CMRequest *request, NSError *error) {

                    ShowErrorStatus(@"网络连接失败");
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    
    return _refreshDataCommand;
}

- (RACCommand *)nextPageCommand {
    
    if (!_nextPageCommand) {
        
        @weakify(self);
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            @strongify(self);
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                @strongify(self);
                NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
                [parameter setObject:@"10" forKey:@"limit"];
                [parameter setObject:self.maxId forKey:@"max_id"];
                [parameter setObject:self.minId forKey:@"min_id"];
                [self.request POST:FLASH_LIST parameters:parameter success:^(CMRequest *request, id responseObject) {

                    NSDictionary *dict = responseObject;
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];

                } failure:^(CMRequest *request, NSError *error) {

                    ShowErrorStatus(@"网络连接失败");
                    [subscriber sendCompleted];
                }];
                return nil;
            }];
        }];
    }
    
    return _nextPageCommand;
}

- (NSArray *)dataArray {
    
    if (!_dataArray) {
        
        _dataArray = [[NSArray alloc] init];
    }
    
    return _dataArray;
}

- (RACSubject *)cellClickSubject {
    
    if (!_cellClickSubject) {
        
        _cellClickSubject = [RACSubject subject];
    }
    
    return _cellClickSubject;
}
- (RACSubject *)cellCommentClickSubject
{
    if (!_cellCommentClickSubject) {
        
        _cellCommentClickSubject = [RACSubject subject];
    }
    
    return _cellCommentClickSubject;
}
@end
