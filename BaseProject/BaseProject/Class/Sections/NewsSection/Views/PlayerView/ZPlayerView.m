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
{
    //view的显示时间默认5s
    NSInteger showTime;
}
@property (strong, nonatomic) UITableView *mainTableView;

@property (strong, nonatomic) ZPlayerViewModel *viewModel;

@property (nonatomic, strong) ZView *headView;

@property (nonatomic, strong) ZView *playControlView;

@property (nonatomic, strong) UIImageView *newsImage;

@property (nonatomic, strong) ZPlayerViewContentTextTableViewCell *tempCell;

@property (nonatomic, strong) UIView *forwardBackView;

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
/**
 是否显示快进后退
 */
@property (assign, nonatomic) BOOL isShowfastBackView;

/**
 自动消失定时器
 */
@property (strong, nonatomic) NSTimer *showForwardBackViewTimer;
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
    
    // 远程控制事件 Remote Control Event
    // 加速计事件 Motion Event
    // 触摸事件 Touch Event
    // 开始监听远程控制事件
    // 成为第一响应者（必备条件）
    [self becomeFirstResponder];
    
    WS(weakSelf)
    [ZRT_PlayerManager manager].resetUIStatus = ^(float bufferProgress) {
        [weakSelf.prgBufferProgress setProgress:0. animated:NO];
    };
    [ZRT_PlayerManager manager].playTimeObserve = ^(float progress,float currentTime,float totalDuration) {
        
        weakSelf.currenTime.text = [[ZRT_PlayerManager manager] convertStringWithTime:currentTime];
        weakSelf.totalTime.text =  [[ZRT_PlayerManager manager] convertStringWithTime:totalDuration];
        weakSelf.sliderProgress.value = currentTime;
        weakSelf.sliderProgress.maximumValue = totalDuration;
    };
    [ZRT_PlayerManager manager].reloadBufferProgress = ^(float bufferProgress,float totalDuration) {
        //更新播放条进度
        if (bufferProgress > 0) {
            [weakSelf.prgBufferProgress setProgress:bufferProgress animated:YES];
        }else{
            [weakSelf.prgBufferProgress setProgress:0. animated:NO];
        }
    };
    
    //播放器状态改变
    RegisterNotify(SONGPLAYSTATUSCHANGE, @selector(playStatusChange:))
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}
- (void)z_bindViewModel
{
//    if (self.viewModel.post_id) {
//        [self.viewModel.refreshDataCommand execute:nil];
//    }
    
    @weakify(self);
    
    [self.viewModel.refreshUI subscribeNext:^(id x) {
        
        @strongify(self);
        
        [self.newsImage sd_setImageWithURL:[NSURL URLWithString:self.viewModel.viewModel.smeta]];
        [self.newsImage startTransitionAnimation];//设置图片切换动画
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
        //解决详情页面切换时候导致底部出现空白
        _mainTableView.estimatedRowHeight = 0;
        _mainTableView.estimatedSectionHeaderHeight = 0;
        _mainTableView.estimatedSectionFooterHeight = 0;
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
        [_bofangLeftBtn setImage:[UIImage imageNamed:@"icon_player_previous"] forState:UIControlStateNormal];
        [_bofangLeftBtn setImage:[UIImage imageNamed:@"icon_player_previous"] forState:UIControlStateDisabled];
        [_bofangLeftBtn addTarget:self action:@selector(bofangLeftAction:) forControlEvents:UIControlEventTouchUpInside];
        _bofangLeftBtn.contentMode = UIViewContentModeScaleToFill;
        [_playControlView addSubview:_bofangLeftBtn];
        
        //底部播放右按钮
        _bofangRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bofangRightBtn setImage:[UIImage imageNamed:@"icon_player_next"] forState:UIControlStateNormal];
        [_bofangRightBtn setImage:[UIImage imageNamed:@"icon_player_next"] forState:UIControlStateDisabled];
        [_bofangRightBtn addTarget:self action:@selector(bofangRightAction:) forControlEvents:UIControlEventTouchUpInside];
        _bofangRightBtn.contentMode = UIViewContentModeScaleToFill;
        [_playControlView addSubview:_bofangRightBtn];
        
        //底部播放暂停按钮
        _bofangCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bofangCenterBtn setImage:[UIImage imageNamed:@"iocn_player_play"] forState:UIControlStateNormal];
        [_bofangCenterBtn setImage:[UIImage imageNamed:@"icon_player_pause"] forState:UIControlStateSelected];
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
            make.trailing.equalTo(weakSelf.sliderProgress.mas_trailing);
            make.top.equalTo(weakSelf.sliderProgress.mas_bottom).offset(MARGIN_10);
        }];
        [_currenTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.sliderProgress.mas_leading);
            make.top.equalTo(weakSelf.sliderProgress.mas_bottom).offset(MARGIN_10);
        }];
        [_bofangCenterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.playControlView);
            make.top.equalTo(weakSelf.totalTime.mas_bottom).offset(MARGIN_10);
            make.size.equalTo(CGSizeMake(50, 50));
        }];
        
        [_bofangLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(weakSelf.bofangCenterBtn.mas_leading).offset(-MARGIN_10);
            make.top.equalTo(weakSelf.totalTime.mas_bottom).offset(MARGIN_10);
            make.size.equalTo(CGSizeMake(50, 50));
        }];
        [_bofangRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(weakSelf.bofangCenterBtn.mas_trailing).offset(MARGIN_10);
            make.top.equalTo(weakSelf.totalTime.mas_bottom).offset(MARGIN_10);
            make.size.equalTo(CGSizeMake(50, 50));
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
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
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
    if ([ZRT_PlayerManager manager].isPlaying) {//点击暂停
        [[ZRT_PlayerManager manager] pausePlay];
        sender.selected = NO;
    }else{//点击播放
        [[ZRT_PlayerManager manager] startPlay];
        sender.selected = YES;
    }
}
/**
 上一首
 */
- (void)bofangLeftAction:(UIButton *)sender
{
    //播放上一首
    BOOL isfirst = [[ZRT_PlayerManager manager] previousSong];
    ZLog(@"现在播放index：%ld",[ZRT_PlayerManager manager].currentSongIndex);
    //已经是第一首，则不往下执行
    if (isfirst) {
        return;
    }
    //切换界面
    self.viewModel.post_id = [ZRT_PlayerManager manager].currentSong[@"id"];
    //刷新界面数据
    [self.viewModel.refreshDataCommand execute:nil];
}
/**
 下一首
 */
- (void)bofangRightAction:(UIButton *)sender
{
    //播放下一首
    BOOL isLast = [[ZRT_PlayerManager manager] nextSong];
    ZLog(@"现在播放index：%ld",[ZRT_PlayerManager manager].currentSongIndex);
    //已经是最后一首，则不往下执行
    if (isLast) {
        return;
    }
    //切换界面
    self.viewModel.post_id = [ZRT_PlayerManager manager].currentSong[@"id"];
    //刷新界面数据
    [self.viewModel.refreshDataCommand execute:nil];
}
/**
 拖拽播放进度
 */
- (void)doChangeProgress:(UISlider *)slider
{
    //调到指定时间去播放
    if ([ZRT_PlayerManager manager].player.status == AVPlayerStatusReadyToPlay) {//防止未缓冲完成进行拖拽报错：AVPlayerItem cannot service a seek request with a completion handler until its status is AVPlayerItemStatusReadyToPlay
        
        //显示快进后退按钮
        if (!_isShowfastBackView) {
            [self showForwardBackView];
            
            _isShowfastBackView = YES;
            [self attAction];
        }
        [[ZRT_PlayerManager manager].player seekToTime:CMTimeMake(self.sliderProgress.value * [ZRT_PlayerManager manager].playRate, [ZRT_PlayerManager manager].playRate) completionHandler:^(BOOL finished) {
            ZLog(@"拖拽结果：%d",finished);
            if (finished == YES){
                [[ZRT_PlayerManager manager] startPlay];
            }
        }];
    }else{
        XWAlerLoginView *alert = [XWAlerLoginView alertWithTitle:@"请等待音频缓冲完成"];
        [alert show];
    }
}
/**
 开始拖拽进度条调用
 */
- (void)sliderTouchDown:(UISlider *)sender
{
    //显示快进后退按钮
    if (!_isShowfastBackView) {
        [self showForwardBackView];
        
        _isShowfastBackView = YES;
        [self attAction];
    }
    //暂停播放
    if ([ZRT_PlayerManager manager].isPlaying) {
        [[ZRT_PlayerManager manager] pausePlay];
    }
}
/**
 点击进度条调用
 */
- (void)handleTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint touchPoint = [recognizer locationInView:self.sliderProgress];
    CGFloat value = touchPoint.x / CGRectGetWidth(self.sliderProgress.frame);
    
    //显示快进后退按钮
    if (!_isShowfastBackView) {
        [self showForwardBackView];
        
        _isShowfastBackView = YES;
        [self attAction];
    }
    [[ZRT_PlayerManager manager].player seekToTime:CMTimeMake((value * [ZRT_PlayerManager manager].duration) * [ZRT_PlayerManager manager].playRate, [ZRT_PlayerManager manager].playRate) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if (finished == YES){
            [[ZRT_PlayerManager manager] startPlay];
        }
    }];
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
    
    
    [self.viewModel.scrollSubject sendNext:[NSNumber numberWithFloat:scrollView.contentOffset.y]];
    
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
#pragma mark - 快进 后退 15秒控件
- (UIView *)forwardBackView
{
    if (_forwardBackView == nil) {
        CGFloat height = 70;
        _forwardBackView = [[UIView alloc] init];
        _forwardBackView.frame = CGRectMake(0, SCREEN_HEIGHT - 160 - height, SCREEN_WIDTH, height);
        _forwardBackView.backgroundColor = COLOR(0, 0, 0, 0.5);
        
        UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH * 0.5, height)];
        [back setImage:[UIImage imageNamed:@"fast_back_2"] forState:UIControlStateNormal];
        [back setImage:[UIImage imageNamed:@"fast_back_blue_2"] forState:UIControlStateHighlighted];
        [back addTarget:self action:@selector(back15)];
        [_forwardBackView addSubview:back];
        
        UIButton *go = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 0.5, 0, SCREEN_WIDTH * 0.5, height)];
        [go setImage:[UIImage imageNamed:@"fast_go_2"] forState:UIControlStateNormal];
        [go setImage:[UIImage imageNamed:@"fast_go_blue_2"] forState:UIControlStateHighlighted];
        [go addTarget:self action:@selector(go15)];
        [_forwardBackView addSubview:go];
    }
    return _forwardBackView;
}

/**
 后退15s
 */
- (void)back15
{
    [self attAction];
    if ([ZRT_PlayerManager manager].isPlaying) {
        [[ZRT_PlayerManager manager] pausePlay];
    }
    //调到指定时间去播放
    [[ZRT_PlayerManager manager].player seekToTime:CMTimeMake(self.sliderProgress.value > 15?self.sliderProgress.value - 15:0, 1) completionHandler:^(BOOL finished) {
        ZLog(@"拖拽结果：%d",finished);
        if (finished == YES){
            [[ZRT_PlayerManager manager] startPlay];
        }
    }];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:[[NSUserDefaults standardUserDefaults] boolForKey:@"shoushi"]];
}
/**
 快进15s
 */
- (void)go15
{
    [self attAction];
    if ([ZRT_PlayerManager manager].isPlaying) {
        [[ZRT_PlayerManager manager] pausePlay];
    }
    //调到指定时间去播放
    [[ZRT_PlayerManager manager].player seekToTime:CMTimeMake(self.sliderProgress.value + 15, 1) completionHandler:^(BOOL finished) {
        ZLog(@"拖拽结果：%d",finished);
        if (finished == YES){
            [[ZRT_PlayerManager manager] startPlay];
        }
    }];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:[[NSUserDefaults standardUserDefaults] boolForKey:@"shoushi"]];
}

/**
 显示快进/后退控件
 */
- (void)showForwardBackView
{
    WS(weakSelf)
    self.forwardBackView.alpha = 0.;
    [self addSubview:self.forwardBackView];
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.forwardBackView.alpha = 1.;
    }];
}
/**
 隐藏快进/后退控件
 */
- (void)hideForwardBackView
{
    WS(weakSelf)
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.forwardBackView.alpha = 0.;
    } completion:^(BOOL finished) {
        [weakSelf.forwardBackView removeFromSuperview];
        weakSelf.isShowfastBackView = NO;
    }];
}
/**
 快进，后退15sView隐藏定时器
 */
- (void)attAction
{
    showTime = 5;
    [_showForwardBackViewTimer invalidate];
    _showForwardBackViewTimer = nil;
    //启动定时器
    _showForwardBackViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                                 target:self
                                                               selector:@selector(timeAction)
                                                               userInfo:nil
                                                                repeats:YES];
    [_showForwardBackViewTimer fire];//
    [[NSRunLoop currentRunLoop] addTimer:_showForwardBackViewTimer forMode:NSDefaultRunLoopMode];
    
}

/**
 定时器调用方法
 */
- (void)timeAction
{
    showTime --;
    if (showTime == 0) {
        //隐藏快进，后退view
        [self hideForwardBackView];
    }
}
#pragma mark - 远程控制事件监听

- (BOOL)canBecomeFirstResponder{
    return YES;
}
#pragma mark - 蓝牙线控方法
- (void)systemMusicPlayerControl:(NSNotification *)notification
{
    NSData *data = [notification.object objectForKey:@"musicControlData"];  //蓝牙设备传来的控制信息
    Byte *bytes = (Byte *)[data bytes];
    if (bytes[1] == 0x01) {  //验证
        if (bytes[2] == 0x01) { // 播放/停止
            
            if ([ZRT_PlayerManager manager].isPlaying) {
                [[ZRT_PlayerManager manager] pausePlay]; //暂停
            }
            if (![ZRT_PlayerManager manager].isPlaying) {
                [[ZRT_PlayerManager manager] startPlay]; //播放
            }
        } else if (bytes[2] == 0x02) { // 切换上一曲
            //上一首
            [self bofangLeftAction:_bofangLeftBtn];
        } else if (bytes[2] == 0x03) { // 切换下一曲
            //下一首
            [self bofangRightAction:_bofangRightBtn];
        } else {
            NSLog(@"Music Control Error Data!");
        }
    }
}
#pragma mark - 耳机线控方法
- (void)remoteControlReceivedWithEvent:(UIEvent *)event{
    
    //    event.type; // 事件类型
    //    event.subtype; // 事件的子类型
    //    UIEventSubtypeRemoteControlPlay                 = 100,
    //    UIEventSubtypeRemoteControlPause                = 101,
    //    UIEventSubtypeRemoteControlStop                 = 102,
    //    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
    //    UIEventSubtypeRemoteControlNextTrack            = 104,
    //    UIEventSubtypeRemoteControlPreviousTrack        = 105,
    //    UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
    //    UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
    //    UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
    //    UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
            //开始播放
            [[ZRT_PlayerManager manager] startPlay];
            break;
        case UIEventSubtypeRemoteControlPause:
            //暂停播放
            [[ZRT_PlayerManager manager] pausePlay];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            //下一首
            [self bofangRightAction:_bofangRightBtn];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            //上一首
            [self bofangLeftAction:_bofangLeftBtn];
            
        default:
            break;
    }
}
#pragma mark -通知- 拔插耳机线方法
/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *interuptionDict = notification.userInfo;
    
    NSInteger routeChangeReason = [[interuptionDict valueForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    switch (routeChangeReason) {
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
            // 耳机插入
            break;
            
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            // 耳机拔掉
            // 拔掉耳机继续播放
            [[ZRT_PlayerManager manager] startPlay];
        }
            break;
            
        case AVAudioSessionRouteChangeReasonCategoryChange:
            // called at start - also when other audio wants to play
            NSLog(@"AVAudioSessionRouteChangeReasonCategoryChange");
            break;
    }
}
#pragma mark -通知- 播放状态改变
- (void)playStatusChange:(NSNotification *)note
{
    switch ([ZRT_PlayerManager manager].status) {
        case ZRTPlayStatusPlay:
            _bofangCenterBtn.selected = YES;
            break;
        case ZRTPlayStatusPause:
            _bofangCenterBtn.selected = NO;
            break;
        case ZRTPlayStatusStop:
            _bofangCenterBtn.selected = NO;
            break;
        default:
            break;
    }
}
@end
