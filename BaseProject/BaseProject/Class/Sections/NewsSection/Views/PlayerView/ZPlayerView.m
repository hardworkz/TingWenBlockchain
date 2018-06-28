//
//  ZPlayerView.m
//  BaseProject
//
//  Created by 泡果 on 2018/6/27.
//  Copyright © 2018年 com.general.*. All rights reserved.
//

#import "ZPlayerView.h"
#import "ZPlayerViewModel.h"
#import "ZPlayerViewContentTextTableViewCell.h"
#import "ZPlayerViewContentTextTableViewCellViewModel.h"

@interface ZPlayerView () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *mainTableView;

@property (strong, nonatomic) ZPlayerViewModel *viewModel;

@property (nonatomic, strong) ZView *headView;

@property (nonatomic, strong) ZView *playControlView;

@property (nonatomic, strong) UIImageView *newsImage;

@property (nonatomic, strong) ZPlayerViewContentTextTableViewCell *tempCell;


/**
 播放/暂停按钮
 */
@property (nonatomic, strong) UIButton *bofangCenterBtn;

/**
 上一条按钮
 */
@property (nonatomic, strong) UIButton *bofangLeftBtn;

/**
 下一条按钮
 */
@property (nonatomic, strong) UIButton *bofangRightBtn;
/**
 播放进度条
 */
@property(strong,nonatomic)UISlider *sliderProgress;
/**
 缓冲进度条
 */
@property(strong,nonatomic)UIProgressView *prgBufferProgress;

/**
 总时长
 */
@property(strong,nonatomic)UILabel *totalTime;

/**
 当前播放时长
 */
@property(strong,nonatomic)UILabel *currenTime;

@property (assign, nonatomic) CGFloat lastContenOffsetY;
@end
@implementation ZPlayerView

#pragma mark - system

- (instancetype)initWithViewModel:(id<ZViewModelProtocol>)viewModel {
    
    self.viewModel = (ZPlayerViewModel *)viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)updateConstraints {
    
    WS(weakSelf)
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(weakSelf);
    }];
    [self.playControlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(160);
        make.leading.trailing.equalTo(0);
        make.bottom.equalTo(weakSelf);
    }];
    [super updateConstraints];
}

#pragma mark - private
- (void)z_setupViews {
    
    [self addSubview:self.mainTableView];
    [self addSubview:self.playControlView];
    self.mainTableView.tableHeaderView = self.headView;
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)z_bindViewModel
{
    [self.viewModel.refreshDataCommand execute:nil];
    
    @weakify(self);
    
    [self.viewModel.refreshUI subscribeNext:^(id x) {
        
        @strongify(self);
        
        [self.newsImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.viewModel.smeta]];
        [self.mainTableView reloadData];
    }];
    
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        
        [self.mainTableView reloadData];
        
        switch ([x integerValue]) {
            case LSHeaderRefresh_HasMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
            }
                break;
            case LSHeaderRefresh_HasNoMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
            }
                break;
            case LSFooterRefresh_HasMoreData: {
                
                [self.mainTableView.mj_header endRefreshing];
            }
                break;
            case LSFooterRefresh_HasNoMoreData: {
                [self.mainTableView.mj_header endRefreshing];
            }
                break;
            case LSRefreshError: {
                
                [self.mainTableView.mj_header endRefreshing];
            }
                break;
                
            default:
                break;
        }
    }];
}
#pragma mark - lazyLoad
- (ZPlayerViewModel *)viewModel {
    
    if (!_viewModel) {
        
        _viewModel = [[ZPlayerViewModel alloc] init];
    }
    
    return _viewModel;
}

- (UITableView *)mainTableView {
    
    if (!_mainTableView) {
        
        _mainTableView = [[UITableView alloc] init];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
        _mainTableView.backgroundColor = white_color;
        _mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //tableView页面无导航栏时，顶部出现44高度的空白解决方法
        if (@available(iOS 11.0, *)) {
            _mainTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        [_mainTableView registerClass:[ZPlayerViewContentTextTableViewCell class] forCellReuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZPlayerViewContentTextTableViewCell class])]];
        
        self.tempCell = [[ZPlayerViewContentTextTableViewCell alloc] initWithStyle:0 reuseIdentifier:[NSString stringWithUTF8String:object_getClassName([ZPlayerViewContentTextTableViewCell class])]];
    }
    
    return _mainTableView;
}
- (ZView *)headView
{
    if (!_headView) {
        _headView = [[ZView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 0.6)];
        
        _newsImage = [[UIImageView alloc] init];
        _newsImage.contentMode = UIViewContentModeScaleAspectFill;
        [_headView addSubview:_newsImage];
        
        WS(weakSelf)
        [_newsImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.headView);
        }];
    }
    return _headView;
}
- (ZView *)playControlView
{
    if (!_playControlView) {
        _playControlView = [[ZView alloc] init];
        _playControlView.backgroundColor = white_color;
        
        UIView *devider = [[UIView alloc] init];
        devider.backgroundColor = MAIN_LINE_COLOR;
        [_playControlView addSubview:devider];
        
        [_playControlView addSubview:self.sliderProgress];
        [_playControlView addSubview:self.prgBufferProgress];
        
        _totalTime = [[UILabel alloc] init];
        _totalTime.text = @"00:00";
        _totalTime.textColor = MAINCOLOR;
        _totalTime.font = FONT(12);
        [_playControlView addSubview:_totalTime];
        
        _currenTime = [[UILabel alloc] init];
        _currenTime.text = @"00:00";
        _currenTime.textColor = MAINCOLOR;
        _currenTime.font = FONT(12);
        _currenTime.textAlignment = NSTextAlignmentRight;
        [_playControlView addSubview:_currenTime];
        
        //底部播放左按钮
        _bofangLeftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bofangLeftBtn setImage:[UIImage imageNamed:@"home_news_ic_before"] forState:UIControlStateNormal];
        [_bofangLeftBtn setImage:[UIImage imageNamed:@"home_news_ic_before"] forState:UIControlStateDisabled];
        [_bofangLeftBtn addTarget:self action:@selector(bofangLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        _bofangLeftBtn.contentMode = UIViewContentModeScaleToFill;
        [_playControlView addSubview:_bofangLeftBtn];
        
        //底部播放右按钮
        _bofangRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bofangRightBtn setImage:[UIImage imageNamed:@"home_news_ic_next"] forState:UIControlStateNormal];
        [_bofangRightBtn setImage:[UIImage imageNamed:@"home_news_ic_next"] forState:UIControlStateDisabled];
        [_bofangRightBtn addTarget:self action:@selector(bofangRightAction:) forControlEvents:UIControlEventTouchUpInside];
        _bofangRightBtn.contentMode = UIViewContentModeScaleToFill;
        [_playControlView addSubview:_bofangRightBtn];
        
        //底部播放暂停按钮
        _bofangCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bofangCenterBtn setImage:[UIImage imageNamed:@"home_news_ic_play"] forState:UIControlStateNormal];
        [_bofangCenterBtn setImage:[UIImage imageNamed:@"home_news_ic_pause"] forState:UIControlStateSelected];
        [_bofangCenterBtn addTarget:self action:@selector(playPauseClicked:) forControlEvents:UIControlEventTouchUpInside];
        _bofangCenterBtn.contentMode = UIViewContentModeScaleToFill;
        _bofangCenterBtn.selected = YES;
        [_playControlView addSubview:_bofangCenterBtn];
        
        WS(weakSelf)
        [devider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(0.5);
        }];
        [_sliderProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.playControlView).offset(MARGIN_10);
            make.leading.equalTo(MARGIN_15);
            make.trailing.equalTo(-MARGIN_15);
            make.height.equalTo(10);
        }];
        [_prgBufferProgress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(MARGIN_15);
            make.trailing.equalTo(-MARGIN_15);
            make.centerY.equalTo(weakSelf.sliderProgress);
            make.height.equalTo(3);
        }];
        [_totalTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.sliderProgress.mas_leading);
            make.top.equalTo(weakSelf.sliderProgress.mas_bottom).offset(MARGIN_10);
        }];
        [_currenTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.sliderProgress.mas_trailing);
            make.top.equalTo(weakSelf.sliderProgress.mas_bottom).offset(MARGIN_10);
        }];
        [_bofangCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.playControlView);
            make.top.equalTo(weakSelf.totalTime.mas_bottom).offset(MARGIN_10);
            make.size.equalTo(CGSizeMake(50, 30));
        }];
        
        [_bofangLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.bofangCenterBtn.mas_leading).offset(-MARGIN_10);
            make.top.equalTo(weakSelf.totalTime.mas_bottom).offset(MARGIN_10);
            make.size.equalTo(CGSizeMake(50, 30));
        }];
        [_bofangRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.bofangCenterBtn.mas_trailing).offset(MARGIN_10);
            make.top.equalTo(weakSelf.totalTime.mas_bottom).offset(MARGIN_10);
            make.size.equalTo(CGSizeMake(50, 30));
        }];
    }
    return _playControlView;
}
- (UIProgressView *)prgBufferProgress
{
    if (!_prgBufferProgress)
    {
        _prgBufferProgress = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
        _prgBufferProgress.progressTintColor = MAINCOLOR;
    }
    return _prgBufferProgress;
}
- (UISlider *)sliderProgress
{
    if (!_sliderProgress)
    {
        _sliderProgress = [[UISlider alloc]init];
        _sliderProgress.value = 0.0f;
        _sliderProgress.continuous = NO;
        [_sliderProgress setThumbImage:[UIImage imageNamed:@"slider"] forState:UIControlStateNormal];
        _sliderProgress.minimumTrackTintColor = MAINCOLOR;
        _sliderProgress.maximumTrackTintColor = [UIColor clearColor];
        
        [_sliderProgress addTarget:self action:@selector(doChangeProgress:) forControlEvents:UIControlEventValueChanged];
        [_sliderProgress addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sliderTap:)];
        [tap setNumberOfTouchesRequired:1];
    }
    return _sliderProgress;
}
#pragma mark - action
/**
 播放/暂停
 */
- (void)playPauseClicked:(UIButton *)sender
{
}
/**
 上一首
 */
- (void)bofangLeftAction:(UIButton *)sender
{
}
/**
 下一首
 */
- (void)bofangRightAction:(UIButton *)sender
{
}
/**
 拖拽播放进度
 */
- (void)doChangeProgress:(UISlider *)slider
{
}
/**
 开始拖拽进度条调用
 */
- (void)sliderTouchDown:(UISlider *)sender
{
}
/**
 点击进度条调用
 */
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
}
#pragma mark - table datasource

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    ZPlayerViewContentTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithUTF8String:object_getClassName([ZPlayerViewContentTextTableViewCell class])] forIndexPath:indexPath];
    
    cell.viewModel = self.viewModel.viewModel;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ZPlayerViewContentTextTableViewCellViewModel *viewModel = self.viewModel.viewModel;
    if (viewModel.cellHeight == 0) {
        CGFloat cellHeight = [self.tempCell cellHeightForViewModel:self.viewModel.viewModel];
        
        // 缓存给model
        viewModel.cellHeight = cellHeight;
        
        return cellHeight;
    } else {
        return viewModel.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel.cellClickSubject sendNext:nil];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //设置置顶按钮alpha
//    float alpha = scrollView.contentOffset.y/(SCREEN_HEIGHT * 1.5);
//    if (alpha >= 0.75) {
//        alpha = 0.75;
//    }else{
//        alpha = alpha;
//    }
//    _scrollTopBtn.alpha = alpha;
    
    //播放控制器显示隐藏
    if (scrollView.contentOffset.y < 0) {
        [self showPlayControl];
    }else{
        if (_lastContenOffsetY < scrollView.contentOffset.y) {//上滑
            [self hidePlayControl];
        }else if (_lastContenOffsetY > scrollView.contentOffset.y){//下滑
            [self showPlayControl];
        }
    }
}
/**
 监听拖拽事件，退下播放控制器
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _lastContenOffsetY = scrollView.contentOffset.y;
}
#pragma mark - 播放控制器动画
/**
 *  显示
 */
- (void)showPlayControl
{
    if (SCREEN_HEIGHT - 160 != self.playControlView.y) {
        [UIView animateWithDuration:0.5 animations:^{
            self.playControlView.y = SCREEN_HEIGHT - 160;
        }];
    }
}
/**
 *  隐藏
 */
- (void)hidePlayControl
{
    if (SCREEN_HEIGHT != self.playControlView.y) {
        [UIView animateWithDuration:0.5 animations:^{
            self.playControlView.y = SCREEN_HEIGHT;
        }];
    }
}
@end
