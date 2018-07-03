//
//  ZRT_PlayerManager.m
//  kuangjiaTingWen
//
//  Created by 泡果 on 2017/7/25.
//  Copyright © 2017年 zhimi. All rights reserved.
//

#import "ZRT_PlayerManager.h"

#if DEBUG
#define BASE_INFO_FUN(info)    BASE_INFO_LOG([self class],_cmd,info)
#else
#define BASE_INFO_FUN(info)
#endif

static NSString *const kvo_status = @"status";
static NSString *const kvo_loadedTimeRanges = @"loadedTimeRanges";
static NSString *const kvo_playbackBufferEmpty = @"playbackBufferEmpty";
static NSString *const kvo_playbackLikelyToKeepUp = @"playbackLikelyToKeepUp";

@interface ZRT_PlayerManager ()
@property (assign, nonatomic) BOOL isUpdateStudyRecordLock;
/**
 定时器
 */
@property (strong, nonatomic) NSTimer *timer;
@end
@implementation ZRT_PlayerManager
+ (instancetype)manager {
    
    static ZRT_PlayerManager * player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[ZRT_PlayerManager alloc]init];
    });
    return player;
}

- (id)init {
    if (self = [super init]) {
        
        _isUpdateStudyRecordLock = NO;
        self.playRate = 1.0;
        timeCount = 5;
        
        //初始化播放器的播放URL，防止首条播放缓冲不完整
//        self.player = [AVPlayer playerWithPlayerItem:[[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://tingwen-1254240285.file.myqcloud.com/mp3/5abb9bcf28dca.mp3"]]];
    }
    return self;
}


#pragma mark - 播放器
/*
 * 播放器播放状态
 */
- (BOOL)isPlaying {
    if (@available(iOS 10.0, *)) {
        return self.player.timeControlStatus == AVPlayerTimeControlStatusPlaying;
    } else {
        return self.player.rate>0&&self.player.error == nil;
    }
}

/**
 拦截set方法保存当前播放新闻列表数据

 @param songList 当前新闻播放列表
 */
- (void)setSongList:(NSArray *)songList
{
    _songList = songList;
    
    [DataCache setCache:songList forKey:@"playList"];
}
/**
 拦截set方法保存当前播放新闻数据

 @param currentSong 当前播放新闻
 */
- (void)setCurrentSong:(NSDictionary *)currentSong
{
    _currentSong = currentSong;
    
}

/**
 当前播放index
 */
- (void)setCurrentSongIndex:(NSInteger)currentSongIndex
{
    _currentSongIndex = currentSongIndex;
    
}

/**
 播放速率
 */
- (void)setPlayRate:(float)playRate
{
    _playRate = playRate;
    if (self.isPlaying) {
        self.player.rate = playRate;
    }
}
/*
 * 总时长(秒)
 */
- (void)setPlayDuration:(float)playDuration {
    _playDuration = playDuration;
}

/*
 * 课堂ID
 */
- (void)setAct_id:(NSString *)act_id
{
    _act_id = act_id;
}
/*
 * 当前播放时间(00:00)
 */
- (NSString *)playTime {
    
    return [self convertStringWithTime:self.playTime.floatValue];
}
/*
 * 总时长(00:00)
 */
- (NSString *)totalTime {
    
    return [self convertStringWithTime:self.totalTime.floatValue];
}
/**
 *  根据playerItem，来添加移除观察者
 *
 *  @param playerItem playerItem
 */
- (void)setPlayerItem:(AVPlayerItem *)playerItem
{
    if (_playerItem == playerItem) {return;}
    
    if (_playerItem) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
        [_playerItem removeObserver:self forKeyPath:kvo_status];
        [_playerItem removeObserver:self forKeyPath:kvo_loadedTimeRanges];
        [_playerItem removeObserver:self forKeyPath:kvo_playbackBufferEmpty];
        [_playerItem removeObserver:self forKeyPath:kvo_playbackLikelyToKeepUp];
    }
    _playerItem = playerItem;
    if (playerItem) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
        [playerItem addObserver:self forKeyPath:kvo_status options:NSKeyValueObservingOptionNew context:nil];
        [playerItem addObserver:self forKeyPath:kvo_loadedTimeRanges options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区空了，需要等待数据
        [playerItem addObserver:self forKeyPath:kvo_playbackBufferEmpty options:NSKeyValueObservingOptionNew context:nil];
        // 缓冲区有足够数据可以播放了
        [playerItem addObserver:self forKeyPath:kvo_playbackLikelyToKeepUp options:NSKeyValueObservingOptionNew context:nil];
    }
}
/**
 开始播放
 */
- (void)startPlay
{
    _status = ZRTPlayStatusPlay;
    SendNotify(SONGPLAYSTATUSCHANGE, nil)
    [self.player play];
}
/*
 * 暂停播放
 */
- (void)pausePlay {
    _status = ZRTPlayStatusPause;
    [self.player pause];
    SendNotify(SONGPLAYSTATUSCHANGE, nil)
}
/*
 * 播放完毕
 */
- (void)endPlay {
    if (self.player == nil) return;
    
    _status = ZRTPlayStatusStop;
    [self.player pause];
    
    //移除监控
    [self removeObserver];
    
    //重置进度
    _progress = 0.f;
    _playDuration = 0.f;
    _duration = 0.f;
    
    SendNotify(SONGPLAYSTATUSCHANGE, nil)
}
/*
 * 自动播放下一首
 */
- (void)playNext
{
    [self endPlay];
    [self loadSongInfoFromFirst:NO];
    [self startPlay];
}

/**
 切换到上一首
 */
- (BOOL)previousSong
{
    if (self.currentSongIndex == 0){
        XWAlerLoginView *alert = [XWAlerLoginView alertWithTitle:@"这已经是第一条了"];
        [alert show];
        return YES;
    }

    [self endPlay];
    //因为loadsong会将index加1，这里要减2，才是上一首
    self.currentSongIndex -= 2;
    [self loadSongInfoFromFirst:NO];
    [self startPlay];
    return NO;
}

/**
 切换到下一首
 */
- (BOOL)nextSong
{
    //如果是最后一首，先暂停播放下一首
    if (self.currentSongIndex == self.songList.count - 1){
        if (self.loadMoreList) {
            self.loadMoreList(self.currentSongIndex);
        }
        //防止越界
        if (self.currentSongIndex >= self.songList.count - 1){
            XWAlerLoginView *alert = [XWAlerLoginView alertWithTitle:@"请稍等，列表正在加载中~"];
            [alert show];
        }
        return YES;
    }
    
    [self playNext];
    return NO;
}
#pragma mark - 加载歌曲
/*
 * 加载下一条音乐文件
 * reset: isNew==YES:从头开始
 */
- (void)loadSongInfoFromFirst:(BOOL)isFirst {
    
    //更新当前歌曲位置
    self.currentSongIndex = isFirst ? 0 : self.currentSongIndex + 1;
    
    //回调列表，刷新界面
    if (self.playReloadList) {
        self.playReloadList(self.currentSongIndex);
    }
    
    //更新当前歌曲信息
    self.currentSong = self.songList[self.currentSongIndex];
    
    //刷新封面图片
    self.currentCoverImage = self.currentSong[@"smeta"];
    
    //获取播放器播放对象
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.currentSong[@"post_mp"]]];
    
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    if([[UIDevice currentDevice] systemVersion].intValue>=10){
        //增加下面这行可以解决iOS10兼容性问题了，设置后可以直接播放，不需要等待缓冲完成就可以播放mp3
        if (@available(iOS 10.0, *)) {
            self.player.automaticallyWaitsToMinimizeStalling = NO;
        } else {
            // Fallback on earlier versions
        }
    }
    
    //给当前歌曲添加监控
    [self addObserver];
    
    _status = ZRTPlayStatusLoadSongInfo;
    SendNotify(SONGPLAYSTATUSCHANGE, nil)
}

/**
 选中播放对应index的音乐

 @param index 对应index
 */
- (void)loadSongInfoFromIndex:(NSInteger)index
{
    [self endPlay];
    
    //判断是否会数组越界
    if (self.songList.count == 0 || self.songList.count < index) {
        return;
    }
    //更新当前歌曲信息
    self.currentSong = self.songList[index];
    
    //刷新index
    self.currentSongIndex = index;
    
    //回调列表，刷新界面
    if (self.playReloadList) {
        self.playReloadList(self.currentSongIndex);
    }
    //刷新封面图片
    self.currentCoverImage = self.currentSong[@"smeta"];
    
    
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    //      增加下面这行可以解决iOS10兼容性问题了
    if (@available(iOS 10.0, *)) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    } else {
        // Fallback on earlier versions
    }
    //给当前歌曲添加监控
    [self addObserver];
    
    _status = ZRTPlayStatusLoadSongInfo;
    SendNotify(SONGPLAYSTATUSCHANGE, nil)
    
    //开始播放
    [self startPlay];
}
/**
 播放url的音频
 
 @param urlString 音频url字符串
 */
- (void)loadSongInfoWithUrl:(NSString *)urlString
{
    [self endPlay];
    
    //刷新index
    self.currentSongIndex = -1;
    
    //加载playerItem
    NSURL * url = [NSURL URLWithString:urlString];
    self.playerItem = [[AVPlayerItem alloc]initWithURL:url];
    
    //重置播放器
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    //      增加下面这行可以解决iOS10兼容性问题了
    if (@available(iOS 10.0, *)) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    } else {
        // Fallback on earlier versions
    }
    //给当前歌曲添加监控
    [self addObserver];
    
    _status = ZRTPlayStatusLoadSongInfo;
    SendNotify(SONGPLAYSTATUSCHANGE, nil)
    
    //开始播放
    [self startPlay];
}
#pragma mark - KVO
- (void)addObserver
{
    AVPlayerItem *songItem = self.player.currentItem;
    //更新播放器进度
    MJWeakSelf
    _timeObserve = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:dispatch_get_main_queue() usingBlock:^(CMTime time)
    {
        float currentTime = CMTimeGetSeconds(time);
        float total = CMTimeGetSeconds(songItem.duration);
        
        //判断是否是NaN如果是则返回
        if (isnan(total)) {
            return;
        }
        if (currentTime) {
            weakSelf.progress = currentTime / total;
            weakSelf.playDuration = currentTime;
            weakSelf.duration = total;
        }
        if (weakSelf.playTimeObserve) {
            weakSelf.playTimeObserve(weakSelf.progress,currentTime,total);
        }
    }];
}
- (void)removeObserver
{
    if (_timeObserve) {
        [self.player removeTimeObserver:_timeObserve];
        _timeObserve = nil;
    }
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
}
/**
 播放完成通知调用方法
 */
- (void)playbackFinished:(NSNotification *)notice
{
    //当前播放的是单个音频文件，不是列表
    if (self.currentSongIndex < 0) return;
    
    //如果是最后一首，先暂停播放下一首
    if (self.currentSongIndex >= self.songList.count - 2){
        if (self.loadMoreList) {
            self.loadMoreList(self.currentSongIndex);
        }
        if (self.currentSongIndex >= self.songList.count - 1){
            XWAlerLoginView *alert = [XWAlerLoginView alertWithTitle:@"这已经是最后一条了"];
            [alert show];
        }
        //防止越界
        if (self.currentSongIndex >= self.songList.count - 1) return;
    }
    //播放列表中的下一条
    [self playNext];
    
    //播放完毕，回调block,方便外面做处理
    if (self.playDidEnd) {
        self.playDidEnd(self.currentSongIndex);
    }
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if (!self.player) return;
    
    AVPlayerItem * songItem = object;
    if ([keyPath isEqualToString:kvo_status]) {
        
        switch (self.player.status) {
            case AVPlayerStatusUnknown:
                ZLog(@"KVO：未知状态");
                break;
            case AVPlayerStatusReadyToPlay:{
                _status = ZRTPlayStatusReadyToPlay;
                _duration = CMTimeGetSeconds(songItem.duration);
//                [APPDELEGATE configNowPlayingCenter];
                
                
                ZLog(@"KVO：准备完毕");}
                break;
            case AVPlayerStatusFailed:
                ZLog(@"KVO：加载失败");
                break;
            default:
                break;
        }
        SendNotify(SONGPLAYSTATUSCHANGE, nil)
    }
    if ([keyPath isEqualToString:kvo_loadedTimeRanges]) {
        
        NSArray * array = songItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue]; //本次缓冲的时间范围
        NSTimeInterval totalBufferDuration = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration); //缓冲总长度
        NSTimeInterval totalDuration = CMTimeGetSeconds(songItem.duration);
        if (totalDuration<=0 || isinf(totalDuration)) return;
        self.duration = totalDuration;
        ZLog(@"共缓冲:%.2f秒",totalBufferDuration);
        ZLog(@"总时长:%.2f秒",totalDuration);
        if (self.reloadBufferProgress) {
            self.reloadBufferProgress(totalBufferDuration/totalDuration,totalDuration);
        }
        
        timeCount = 8;
        if (totalBufferDuration >= (totalDuration*0.9)) {
            [self removeTimer];
        }else {
            if (totalBufferDuration > 0) {//判断已经开始缓冲
                [self addTimer];
            }
        }
        
    }else if ([_playerItem isEqual:object]&&[keyPath isEqualToString:kvo_playbackBufferEmpty])
    {
        if (songItem.playbackBufferEmpty&& self.status == ZRTPlayStatusPlay) {
            //缓冲区域为空，暂停播放
            [self.player pause];
        }
    }
    
    else if ([_playerItem isEqual:object]&&[keyPath isEqualToString:kvo_playbackLikelyToKeepUp])
    {
            //缓存可用，继续播放
        if (songItem.playbackLikelyToKeepUp && self.status == ZRTPlayStatusPlay) {
            [self.player play];
        }
    }
}

#pragma mark - 私有方法
//计算缓冲进度
- (NSTimeInterval)availableDuration{
    
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];//获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;//计算缓冲总进度
    return result;
}

/**
 转换秒数为时间格式字符串
 */
- (NSString *)convertStringWithTime:(float)time
{
    if (isnan(time)) time = 0.f;
    int min = time / 60.0;
    int sec = time - min * 60;
    NSString * minStr = min > 9 ? [NSString stringWithFormat:@"%d",min] : [NSString stringWithFormat:@"0%d",min];
    NSString * secStr = sec > 9 ? [NSString stringWithFormat:@"%d",sec] : [NSString stringWithFormat:@"0%d",sec];
    NSString * timeStr = [NSString stringWithFormat:@"%@:%@",minStr, secStr];
    return timeStr;
}
/**
 判断当前的列表标题的颜色（正在播放为主题色，已经播放过为灰色，没有播放过为黑色）
 
 @param post_id 新闻ID
 @return 返回颜色
 */
- (UIColor *)textColorFormID:(NSString *)post_id
{
////    RTLog(@"cell-ID:%@---------pushID:%@",post_id,[CommonCode readFromUserD:dangqianbofangxinwenID]);
//    UIColor *returnColor = [UIColor blackColor];
//    if ([[NewPlayVC shareInstance].listenedNewsIDArray isKindOfClass:[NSArray class]]){
//        NSArray *yitingguoArr = [NSArray arrayWithArray:[NewPlayVC shareInstance].listenedNewsIDArray];
//        for (int i = 0; i < yitingguoArr.count; i ++){
//            if ([post_id isEqualToString:yitingguoArr[i]]){
//                if ([[CommonCode readFromUserD:dangqianbofangxinwenID] isEqualToString:post_id]){
//                    returnColor = gMainColor;
//                    break;
//                }
//                else{
//                    returnColor = [[UIColor grayColor]colorWithAlphaComponent:0.7f];
//                    break;
//                }
//            }
//            else{
//                returnColor = nTextColorMain;
//            }
//        }
//    }
    return nil;
}


#pragma mark - 播放器缓冲不完整重置播放器--定时器
- (void)bufferTimeAction
{
    timeCount--;
    if (timeCount <= 0) {
        [self removeTimer];
        
        [self endPlay];
        [self reloadSong];
        [self startPlay];
    }
}
/**
 重新加载播放器数据
 */
- (void)reloadSong
{
    //回调列表，刷新界面
    if (self.playReloadList) {
        self.playReloadList(self.currentSongIndex);
    }
    
    //更新当前歌曲信息
    if (self.songList) {//防止空数组和数组越界引发崩溃
        if (self.currentSongIndex<self.songList.count) {
            self.currentSong = self.songList[self.currentSongIndex];
        }else{
            return;
        }
    }else{
        return;
    }
    
    //刷新封面图片
    self.currentCoverImage = self.currentSong[@"smeta"];
    
    //获取播放器播放对象
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.currentSong[@"post_mp"]]];
    
    // 每次都重新创建Player，替换replaceCurrentItemWithPlayerItem:，该方法阻塞线程
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    //增加下面这行可以解决iOS10兼容性问题了，设置后可以直接播放，不需要等待缓冲完成就可以播放mp3
    if (@available(iOS 10.0, *)) {
        self.player.automaticallyWaitsToMinimizeStalling = NO;
    } else {
        // Fallback on earlier versions
    }
    
    //给当前歌曲添加监控
    [self addObserver];
    
    _status = ZRTPlayStatusLoadSongInfo;
    SendNotify(SONGPLAYSTATUSCHANGE, nil)
}
/**
 *  添加定时器
 */
- (void)addTimer
{
    if (self.timer == nil) {
        [self.timer invalidate];
        self.timer = nil;
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(bufferTimeAction) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}
/**
 *  移除定时器
 */
- (void)removeTimer
{
    // 停止定时器
    [self.timer invalidate];
    self.timer = nil;
}
static NSInteger timeCount = 0;
@end
