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
- (void)setPlayList:(NSArray *)playList
{
    _playList = playList;
    //设置播放器播放列表数据
   
    //设置播放器播放完成自动加载更多block
    WS(weakSelf)
    [ZRT_PlayerManager manager].loadMoreList = ^(NSInteger currentSongIndex) {
        
    };
    //播放内容切换后刷新对应的播放列表
    [ZRT_PlayerManager manager].playReloadList = ^(NSInteger currentSongIndex) {
        
    };
    NSMutableArray *dictArray = [NSMutableArray array];
    //判断是否是点击当前正在播放的新闻，如果是则直接跳转
    
    //设置播放器播放数组
    [ZRT_PlayerManager manager].songList = dictArray;
    //设置新闻ID
    [ZPlayerViewController shareManager].post_id = dictArray[self.index][@"id"];
    //调用播放对应Index方法
//    [[NewPlayVC shareInstance] playFromIndex:self.index];
    //跳转播放界面
    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController pushViewController:[ZPlayerViewController shareManager] animated:YES];
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
