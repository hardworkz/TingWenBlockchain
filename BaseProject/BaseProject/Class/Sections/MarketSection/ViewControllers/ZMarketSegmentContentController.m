//
//  ZMarketSegmentContentController.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/1.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZMarketSegmentContentController.h"

#import "ZSegmentListView.h"
#import "ZSegmentListViewModel.h"

@interface ZMarketSegmentContentController ()

@property (nonatomic, strong) ZSegmentListView *mainView;

@property (nonatomic, strong) ZSegmentListViewModel *viewModel;

@end

@implementation ZMarketSegmentContentController
#pragma mark - system
- (void)updateViewConstraints {
    
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [super updateViewConstraints];
}

#pragma mark - private
- (void)z_addSubviews {
    
    [self.view addSubview:self.mainView];
    self.mainView.backgroundColor = randomColor;
}

- (void)z_bindViewModel {
    
    @weakify(self);
    //cell点击方法实现代码
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        //        @strongify(self);
        //        YDViewController *circleMainVC = [[YDViewController alloc] init];
        //        [self.navigationController pushViewController:circleMainVC animated:YES];
    }];
}
- (void)z_layoutNavigation {
//    [self hideNavigationBar:YES animated:NO];
}
#pragma mark - layzLoad
- (ZSegmentListView *)mainView
{
    if (!_mainView) {
        _mainView = [[ZSegmentListView alloc] initWithViewModel:self.viewModel];
    }
    return _mainView;
}
- (ZSegmentListViewModel *)viewModel
{
    if (!_viewModel) {
        _viewModel = [[ZSegmentListViewModel alloc] init];
    }
    return _viewModel;
}
@end
