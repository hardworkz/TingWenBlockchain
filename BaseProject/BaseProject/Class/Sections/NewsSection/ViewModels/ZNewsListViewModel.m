//
//  ZNewsListViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/21.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZNewsListViewModel.h"
#import "ZNewsTableViewCellViewModel.h"

@interface ZNewsListViewModel()

@property (nonatomic, copy) NSString *maxId;

@property (nonatomic, copy) NSString *minId;

@end
@implementation ZNewsListViewModel
- (void)z_initialize {
    
    @weakify(self);
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        
        @strongify(self);
        if (self.dataArray.count == 0) {
            NSMutableArray *reArray = [[NSMutableArray alloc] init];
            reArray = [ZNewsTableViewCellViewModel mj_objectArrayWithKeyValuesArray:dict[results]];
            self.dataArray = reArray;
        }else{
            if ([dict[status] intValue] == 1) {
                NSMutableArray *reArray = [[NSMutableArray alloc] init];
                reArray = [ZNewsTableViewCellViewModel mj_objectArrayWithKeyValuesArray:dict[results]];
                [reArray addObjectsFromArray:self.dataArray];
                self.dataArray = reArray;
            }
        }
        ZNewsTableViewCellViewModel *first = [self.dataArray firstObject];
        ZNewsTableViewCellViewModel *last = [self.dataArray lastObject];
        self.maxId = first.Id;
        self.minId = last.Id;
        
        [self.refreshEndSubject sendNext:@(LSFooterRefresh_HasMoreData)];
        DismissHud();
    }];

    [self.nextPageCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        
        @strongify(self);
        NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataArray];
        NSMutableArray *tempArray = [[NSMutableArray alloc] init];
        tempArray = [ZNewsTableViewCellViewModel mj_objectArrayWithKeyValuesArray:dict[results]];
        [array addObjectsFromArray:tempArray];
        self.dataArray = array;
        
        ZNewsTableViewCellViewModel *last = [self.dataArray lastObject];
        self.minId = last.Id;
        if (tempArray.count < 10) {
            [self.refreshEndSubject sendNext:@(LSFooterRefresh_HasNoMoreData)];
        }else{
            [self.refreshEndSubject sendNext:@(LSFooterRefresh_HasMoreData)];
        }
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
                if (self.dataArray.count != 0) {
                    [parameter setObject:self.maxId forKey:@"max_id"];
                }
                [self.request POST:HOME_NEWS_LIST parameters:parameter success:^(CMRequest *request, id responseObject) {

                    NSDictionary *dict = responseObject;
                    [subscriber sendNext:dict];
                    [subscriber sendCompleted];
                } failure:^(CMRequest *request, NSError *error) {

                    ZLog(@"%@",error);
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
                [parameter setObject:self.minId forKey:@"min_id"];
                [self.request POST:HOME_NEWS_LIST parameters:parameter success:^(CMRequest *request, id responseObject) {
                    
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
@end
