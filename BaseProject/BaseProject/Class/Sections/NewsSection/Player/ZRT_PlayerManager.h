//
//  ZRT_PlayerManager.h
//  kuangjiaTingWen
//
//  Created by 泡果 on 2017/7/25.
//  Copyright © 2017年 zhimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#define SONGPLAYSTATUSCHANGE @"SongPlayStatusChange"

static NSString *const currenPlayID = @"currenPlayID";
static NSString *const currenPlayDict = @"currenPlayDict";
static NSString *const currenPlayList = @"currenPlayList";

typedef NS_ENUM(NSInteger, ZRTPlayStatus) {
    ZRTPlayStatusNone = 0,//播放界面：未知状态
    ZRTPlayStatusLoadSongInfo,//播放界面：加载信息
    ZRTPlayStatusReadyToPlay,//播放界面：准备播放
    ZRTPlayStatusPlay,//播放界面：继续播放
    ZRTPlayStatusPause,//播放界面：暂停播放
    ZRTPlayStatusStop//播放界面：停止播放
};
@class ClassPlayHistoryDataModel,StudyRecordTimer;
@interface ZRT_PlayerManager : NSObject
{
    id _timeObserve; //监控进度
}
/**
 加载更多列表数据
 */
@property (copy, nonatomic) void (^loadMoreList)(NSInteger currentSongIndex);
/**
 播放完成回调
 */
@property (copy, nonatomic) void (^playDidEnd)(NSInteger currentSongIndex);
/**
 播放，刷新列表
 */
@property (copy, nonatomic) void (^playReloadList)(NSInteger currentSongIndex);
/**
 清空缓冲进度
 */
@property (copy, nonatomic) void (^resetUIStatus)(float bufferProgress);
/**
 刷新缓冲进度
 */
@property (copy, nonatomic) void (^reloadBufferProgress)(float bufferProgress,float totalDuration);
/**
 播放监控进度回调
 */
@property (copy, nonatomic) void (^playTimeObserve)(float progress,float currentTime,float totalDuration);
#pragma mark - 播放状态
/*
 * 播放状态
 */
@property (nonatomic, assign, readonly) ZRTPlayStatus status;
#pragma mark - 列表
/*
 * 歌曲列表
 */
@property (nonatomic, strong) NSArray * songList;

/*
 * 当前播放音频数据
 */
@property (nonatomic, strong) NSDictionary * currentSong;
/*
 * 当前播放音频封面图
 */
@property (nonatomic, strong) NSString * currentCoverImage;

/*
 * 当前播放歌曲索引
 */
@property (nonatomic, assign) NSInteger currentSongIndex;

#pragma mark - 播放器
/*
 * 播放器
 */
@property (nonatomic, strong) AVPlayer * player;
/*
 * 播放器学习记录计时器
 */
@property (nonatomic, strong) StudyRecordTimer* studyRecordTimer;
/**
 播放属性
 */
@property (nonatomic, strong) AVPlayerItem *playerItem;
/**
 课堂播放历史记录数据
 */
@property (strong, nonatomic) ClassPlayHistoryDataModel *playHistoryDataModel;
/*
 * 课堂ID
 */
@property (nonatomic, copy) NSString * act_id;
/*
 * 课堂内节目ID
 */
@property (nonatomic, copy) NSString * act_sub_id;
/*
 * 播放器播放状态
 */
@property (nonatomic, assign) BOOL isPlaying;

/*
 * 播放进度
 */
@property (nonatomic, assign) float progress;

/*
 * 播放速率
 */
@property (nonatomic, assign) float playRate;

/*
 * 缓冲进度 0.0 .. 1.0
 */
@property (nonatomic, assign, readonly) float bufferProgress;

/*
 * 当前播放时间(秒)
 */
@property (nonatomic, assign) float playDuration;

/*
 * 总时长(秒)
 */
@property (nonatomic, assign) float duration;

/*
 * 当前播放时间(00:00)
 */
@property (nonatomic, copy, readonly) NSString * playTime;

/*
 * 总时长(00:00)
 */
@property (nonatomic, copy, readonly) NSString * totalTime;
/*
 * 获取单例
 */
+ (instancetype)manager;
/**
 开始播放
 */
- (void)startPlay;
/*
 * 暂停播放
 */
- (void)pausePlay;
/*
 * 下一条
 */
- (BOOL)nextSong;
/*
 * 上一条
 */
- (BOOL)previousSong;
/**
 选中播放对应index的音频
 
 @param index 对应index
 */
- (void)loadSongInfoFromIndex:(NSInteger)index;
/**
 判断当前的列表标题的颜色（正在播放为主题色，已经播放过为灰色，没有播放过为黑色）

 @param post_id 新闻ID
 @return 返回颜色
 */
- (UIColor *)textColorFormID:(NSString *)post_id;
/**
 转换秒数为时间格式字符串
 */
- (NSString *)convertStringWithTime:(float)time;
@end
