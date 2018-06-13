//
//  ZHomeViewController.m
//  BaseProject
//
//  Created by 泡果 on 2018/5/29.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZHomeViewController.h"
#import "ZHomeScreenSwitchListView.h"
#import "ZHomeScreenSwitchListViewModel.h"
#import "ZHomeListView.h"
#import "ZHomeListViewModel.h"
#import "ZHomeCommentListView.h"
#import "ZHomeCommentListViewModel.h"

@interface ZHomeViewController ()

@property (nonatomic, strong) ZHomeScreenSwitchListView *mainView;
@property (nonatomic, strong) ZHomeListView *allListView;

@property (nonatomic, strong) ZHomeScreenSwitchListViewModel *viewModel;
@property (nonatomic, strong) ZHomeListViewModel *allListViewModel;

@property (nonatomic, strong) ZHomeCommentListViewModel *commentViewModel;
@property (nonatomic, strong) ZHomeCommentListView *commentListView;

@property (nonatomic, strong) ZView *headerSwitchView;

@property (nonatomic, strong) UIButton *selectedSwitchButton;

@property (nonatomic, strong) MASConstraint *topConstant;
@end

@implementation ZHomeViewController
#pragma mark - system
- (void)updateViewConstraints {
    
    WS(weakSelf)
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        if (iPhoneX) {
            make.bottom.equalTo(weakSelf.view).offset(- IPHONEX_BOTTOM_BACK_BAR_H);
        }else{
            make.bottom.equalTo(weakSelf.view);
        }
    }];
    self.allListView.hidden = YES;
    [self.allListView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        if (iPhoneX) {
            make.bottom.equalTo(weakSelf.view).offset(- IPHONEX_BOTTOM_BACK_BAR_H);
        }else{
            make.bottom.equalTo(weakSelf.view);
        }
    }];
    [self.headerSwitchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(iPhoneX?IPHONEX_TOP_STATUS_BAR_H + 10:30);
        make.centerX.equalTo(weakSelf.view);
        make.size.equalTo(CGSizeMake(150, 50));
    }];
    
    [super updateViewConstraints];
}

#pragma mark - private
- (void)z_addSubviews {
    
    [self.view addSubview:self.mainView];
    
    [self.view insertSubview:self.allListView aboveSubview:self.mainView];
    
    [self.view insertSubview:self.headerSwitchView aboveSubview:self.allListView];
    
    [self.view insertSubview:self.commentListView aboveSubview:self.headerSwitchView];
}

- (void)z_bindViewModel {
    
    @weakify(self);
    //cell点击方法实现代码
    [[self.viewModel.cellClickSubject takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        @strongify(self);
//        YDViewController *circleMainVC = [[YDViewController alloc] init];
//        [self.navigationController pushViewController:circleMainVC animated:YES];
    }];
    [[self.viewModel.cellCommentClickSubject takeUntil:self.rac_willDeallocSignal]subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        [self.view insertSubview:self.commentListView.cover belowSubview:self.commentListView];
        //添加评论view
        //设置动画
        [UIView animateWithDuration:0.25 animations:^{
            self.commentListView.y = SCREEN_HEIGHT * 0.3;
        }];
    }];
}
- (void)z_layoutNavigation {
    [self hideNavigationBar:YES animated:NO];
}
#pragma mark - layzLoad
- (ZHomeScreenSwitchListView *)mainView {
    
    if (!_mainView) {
        
        _mainView = [[ZHomeScreenSwitchListView alloc] initWithViewModel:self.viewModel];
    }
    
    return _mainView;
}

- (ZHomeScreenSwitchListViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZHomeScreenSwitchListViewModel alloc] init];
    }
    
    return _viewModel;
}
- (ZHomeListView *)allListView
{
    if (!_allListView) {
        _allListView = [[ZHomeListView alloc] initWithViewModel:self.allListViewModel];
    }
    return _allListView;
}
- (ZHomeListViewModel *)allListViewModel {
    
    if (!_allListViewModel) {
        
        _allListViewModel = [[ZHomeListViewModel alloc] init];
    }
    
    return _allListViewModel;
}
- (ZHomeCommentListView *)commentListView
{
    if (!_commentListView) {
        _commentListView = [[ZHomeCommentListView alloc] initWithViewModel:self.commentViewModel];
        _commentListView.backgroundColor = white_color;
        _commentListView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT * 0.7);
        _commentListView.layer.cornerRadius = 10;
        _commentListView.layer.masksToBounds = YES;
    }
    return _commentListView;
}
- (ZHomeCommentListViewModel *)commentViewModel
{
    if (!_commentViewModel) {
        
        _commentViewModel = [[ZHomeCommentListViewModel alloc] init];
    }
    
    return _commentViewModel;
}

- (ZView *)headerSwitchView
{
    if (!_headerSwitchView) {
        _headerSwitchView = [[ZView alloc] init];
        
        UIButton *recommendBtn = [[UIButton alloc] init];
        [recommendBtn setTitle:@"推荐" forState:UIControlStateNormal];
        recommendBtn.titleLabel.font = BOLDSYSTEMFONT(17);
        recommendBtn.backgroundColor = clear_color;
        recommendBtn.tag = 10000;
        recommendBtn.selected = YES;
        [recommendBtn addTarget:self action:@selector(switch_Clicked:)];
        [_headerSwitchView addSubview:recommendBtn];
        self.selectedSwitchButton = recommendBtn;
        
        UIButton *allBtn = [[UIButton alloc] init];
        [allBtn setTitle:@"全部" forState:UIControlStateNormal];
        allBtn.titleLabel.font = BOLDSYSTEMFONT(14);
        allBtn.backgroundColor = clear_color;
        allBtn.tag = 20000;
        [allBtn addTarget:self action:@selector(switch_Clicked:)];
        [_headerSwitchView addSubview:allBtn];
        
        UIView *deviderView = [[UIView alloc] init];
        deviderView.layer.cornerRadius = 2;
        deviderView.backgroundColor = white_color;
        [_headerSwitchView addSubview:deviderView];
        
        WS(weakSelf);
        [recommendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.headerSwitchView);
            make.left.equalTo(weakSelf.headerSwitchView);
            make.bottom.equalTo(weakSelf.headerSwitchView);
            make.size.equalTo(CGSizeMake(75, 50));
        }];
        [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.headerSwitchView);
            make.right.equalTo(weakSelf.headerSwitchView);
            make.bottom.equalTo(weakSelf.headerSwitchView);
            make.size.equalTo(CGSizeMake(75, 50));
        }];
        
        [deviderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.headerSwitchView).offset(15);
            make.centerX.equalTo(weakSelf.headerSwitchView);
            make.size.equalTo(CGSizeMake(4, 20));
        }];
    }
    return _headerSwitchView;
}
#pragma mark - action
/**
 切换推荐和全部的显示内容
 */
- (void)switch_Clicked:(UIButton *)button{
    
    if ([self.selectedSwitchButton isEqual:button]) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedSwitchButton.titleLabel.font = BOLDSYSTEMFONT(14);
        button.titleLabel.font = BOLDSYSTEMFONT(17);
    }];
    self.selectedSwitchButton.selected = NO;
    button.selected = YES;
    self.selectedSwitchButton = button;
    
    switch (button.tag) {
        case 10000:
            self.allListView.hidden = YES;
            self.mainView.hidden = NO;
            break;
        case 20000:
            self.allListView.hidden = NO;
            self.mainView.hidden = YES;
            break;
        default:
            break;
    }
}

@end
