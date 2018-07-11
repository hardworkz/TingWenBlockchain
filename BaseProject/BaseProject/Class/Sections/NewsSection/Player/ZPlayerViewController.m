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

@property (nonatomic, strong) ZView *navigationView;

@property (nonatomic, strong) ZPlayerView *mainView;

@property (nonatomic, strong) ZPlayerViewModel *viewModel;

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation ZPlayerViewController
+ (instancetype)shareManager {
    
    static ZPlayerViewController * vc;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        vc = [[ZPlayerViewController alloc]init];
    });
    return vc;
}
#pragma mark - system
- (void)updateViewConstraints {
    WS(weakSelf)
    [self.navigationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(0);
        make.top.equalTo(0);
        make.height.equalTo(kNavHeight);
    }];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view);
    }];
    [super updateViewConstraints];
}
#pragma mark - private
- (void)z_addSubviews
{
    [self.view addSubview:self.mainView];
    [self.view addSubview:self.navigationView];
}
- (void)z_bindViewModel
{
    @weakify(self)
    [self.viewModel.cellClickSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        //点击cell操作
    }];
    [self.viewModel.scrollSubject subscribeNext:^(id  _Nullable x) {
        
        @strongify(self);
        float contentOffsetY = [x floatValue];
        //设置导航栏alpha
        float alpha = contentOffsetY/(SCREEN_WIDTH * 0.6 - kNavHeight);
        if (alpha >= 1) {
            [self.leftBtn setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
            alpha = 1;
        }else{
            [self.leftBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
            alpha = alpha;
        }
        self.navigationView.backgroundColor = COLOR(255, 255, 255, alpha);
    }];
}
- (void)z_layoutNavigation
{
    [self hideNavigationBar:YES animated:NO];
//    [self setFd_interactivePopDisabled:YES];
}
- (void)setPlayList:(NSArray *)playList
{
    _playList = playList;
}
- (void)setPost_id:(NSString *)post_id
{
    _post_id = post_id;
    
    self.viewModel.post_id = _post_id;
    
    [DataCache setCache:post_id forKey:currenPlayID];
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
    }
    
    return _viewModel;
}
- (ZView *)navigationView
{
    if (!_navigationView) {
        _navigationView = [[ZView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kNavHeight)];
        _navigationView.backgroundColor = COLOR(255, 255, 255, 0);
        [self.view addSubview:_navigationView];
        
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _leftBtn.frame = CGRectMake(0, kStatusBarHeight, kTopBarHeight, kTopBarHeight);
        //    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 10)];
        _leftBtn.imageView.contentMode = UIViewContentModeCenter;
        [_leftBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        [_leftBtn addTarget:self action:@selector(backClicked) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView addSubview:_leftBtn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH - kTopBarHeight, kStatusBarHeight, kTopBarHeight, kTopBarHeight);
        _rightBtn.imageView.contentMode = UIViewContentModeCenter;
        [_rightBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(shareClicked) forControlEvents:UIControlEventTouchUpInside];
        [_navigationView addSubview:_rightBtn];
    }
    return _navigationView;
}
#pragma mark - action
- (void)shareClicked {
    
}
- (void)backClicked{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
