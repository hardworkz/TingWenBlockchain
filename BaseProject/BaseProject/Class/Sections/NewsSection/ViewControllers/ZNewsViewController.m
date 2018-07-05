//
//  ZNewsViewController.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/31.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZNewsViewController.h"
#import "ZNewsListView.h"
#import "ZNewsListViewModel.h"
#import "ZNewsTableViewCellViewModel.h"

@interface ZNewsViewController ()

@property (nonatomic, strong) ZNewsListView *mainView;

@property (nonatomic, strong) ZNewsListViewModel *viewModel;

@end

@implementation ZNewsViewController

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
    
}
- (void)z_layoutNavigation
{
}
#pragma mark - lazyload
- (ZNewsListView *)mainView
{
    if (!_mainView) {
        _mainView = [[ZNewsListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}
- (ZNewsListViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZNewsListViewModel alloc] init];
    }
    
    return _viewModel;
}
@end
