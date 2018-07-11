//
//  ZPlayerViewModel.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/27.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZPlayerViewModel.h"
#import "ZPlayerViewContentTextTableViewCellViewModel.h"

@implementation ZPlayerViewModel
- (void)setPost_id:(NSString *)post_id
{
    _post_id = post_id;
    
    [self.refreshDataCommand execute:nil];
}
- (void)z_initialize {
    
    @weakify(self);
    [self.refreshDataCommand.executionSignals.switchToLatest subscribeNext:^(NSDictionary *dict) {
        
        @strongify(self);
        self.viewModel = [ZPlayerViewContentTextTableViewCellViewModel mj_objectWithKeyValues:dict[results]];
        
        [self.refreshUI sendNext:nil];
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
                [parameter setObject:self.post_id forKey:@"id"];
                [self.request POST:HOME_NEWS_DETAIL parameters:parameter success:^(CMRequest *request, id responseObject) {

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

- (ZPlayerViewContentTextTableViewCellViewModel *)viewModel{
    if (!_viewModel) {
        _viewModel = [[ZPlayerViewContentTextTableViewCellViewModel alloc] init];
    }
    return _viewModel;
}

- (RACSubject *)cellClickSubject {
    
    if (!_cellClickSubject) {
        
        _cellClickSubject = [RACSubject subject];
    }
    
    return _cellClickSubject;
}
- (RACSubject *)scrollSubject {
    
    if (!_scrollSubject) {
        
        _scrollSubject = [RACSubject subject];
    }
    
    return _scrollSubject;
}

@end
