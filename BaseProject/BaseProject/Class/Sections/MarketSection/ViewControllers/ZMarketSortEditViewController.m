//
//  ZMarketSortEditViewController.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/12.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZMarketSortEditViewController.h"
#import "ZSortEditViewModel.h"
#import "ZSortEditView.h"

@interface ZMarketSortEditViewController ()

@property (nonatomic, strong) ZSortEditView *mainView;

@property (nonatomic, strong) ZSortEditViewModel *viewModel;

@end

@implementation ZMarketSortEditViewController

#pragma mark - system
- (void)updateViewConstraints {
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [super updateViewConstraints];
}
#pragma mark - private
- (void)z_addSubviews
{
    [self.view addSubview:self.mainView];
}
- (void)z_bindViewModel
{
    @weakify(self)
    [self.viewModel.cellClickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //点击cell操作
    }];
}
#pragma mark - lazyload
- (ZSortEditView *)mainView
{
    if (!_mainView) {
        _mainView = [[ZSortEditView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}
- (ZSortEditViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZSortEditViewModel alloc] init];
    }
    
    return _viewModel;
}
@end
