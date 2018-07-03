//
//  ZMyViewController.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/31.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZMyViewController.h"
#import "ZMyView.h"
#import "ZMyViewModel.h"

@interface ZMyViewController ()

@property (nonatomic, strong) ZMyView *mainView;

@property (nonatomic, strong) ZMyViewModel *viewModel;

@end

@implementation ZMyViewController

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
    [self.viewModel.headClickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //点击头像操作
        ZLoginViewController *loginVC = [[ZLoginViewController alloc] init];
        [self.navigationController presentViewController:loginVC animated:YES completion:nil];
    }];
}
- (void)z_layoutNavigation
{
    self.title = @"我";
    [self hideNavigationBar:YES animated:NO];
}
#pragma mark - lazyload
- (ZMyView *)mainView
{
    if (!_mainView) {
        _mainView = [[ZMyView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}
- (ZMyViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZMyViewModel alloc] init];
    }
    
    return _viewModel;
}
@end
