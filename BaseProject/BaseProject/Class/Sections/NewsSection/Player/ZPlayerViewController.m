//
//  ZPlayerViewController.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/27.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZPlayerViewController.h"
#import "ZPlayerView.h"
#import "ZPlayerViewModel.h"

@interface ZPlayerViewController ()

@property (nonatomic, strong) ZPlayerView *mainView;

@property (nonatomic, strong) ZPlayerViewModel *viewModel;

@end

@implementation ZPlayerViewController

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
- (void)z_layoutNavigation
{
    [self hideNavigationBar:YES animated:NO];
//    [self setFd_interactivePopDisabled:YES];
}
#pragma mark - lazyload
- (ZPlayerView *)mainView
{
    if (!_mainView) {
        _mainView = [[ZPlayerView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}
- (ZPlayerViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZPlayerViewModel alloc] init];
        _viewModel.post_id = _post_id;
    }
    
    return _viewModel;
}
@end
