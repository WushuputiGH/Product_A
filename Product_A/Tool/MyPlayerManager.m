//
//  MyPlayerManager.m
//  Product_A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 H. All rights reserved.
//

#import "MyPlayerManager.h"

static MyPlayerManager *defaultManager = nil;

@implementation MyPlayerManager

+(MyPlayerManager *)defaultManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultManager = [[MyPlayerManager alloc] init];
    });
    return defaultManager;
}

-(instancetype)init{
    self = [super init];
    if (self) {
        _playType = ListPlay;
        _playState = Pause;
    }
    return self;
}

// 设置数据
- (void)setMediaLists:(NSMutableArray *)mediaLists{
    

    if (mediaLists && mediaLists.count) {
        [_mediaLists removeAllObjects];
        _mediaLists = [mediaLists mutableCopy];
        AVPlayerItem *avPlayerItem = [AVPlayerItem playerItemWithURL:_mediaLists[_index]];
        if (!_avPlayer) {
            // 如果没有, 就初始化
            _avPlayer = [[AVPlayer alloc] initWithPlayerItem:avPlayerItem];
        }else{
            [_avPlayer replaceCurrentItemWithPlayerItem:avPlayerItem];
        }
    }
}

// 更新数据
- (void)upDateMediaLists: (NSArray *)mediaLists{
    _mediaLists = [mediaLists mutableCopy];
}


// 播放

- (void)play{
    [_avPlayer play];
    self.playState = Play;
    if (_changeState) {
        _changeState(_playState);
    }
    
}


- (void)setPlayState:(PlayState)playState{
    // 播放状态改变, 发送一个通知, 通知所有监听者, 状态改变
    _playState = playState;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PLAYSTATECHANGE" object:nil userInfo:@{@"playState": @(playState)}];
}


//暂停
- (void)pause{
    [_avPlayer pause];
    self.playState = Pause;
    if (_changeState) {
        _changeState(_playState);
    }
}

// 停止
- (void)stop {
    [self seekToSecondsWith:0];
    [_avPlayer pause];
    self.playState = Pause;
}

// 改变当前播放源的时间
- (void)seekToSecondsWith:(float)seconds{
    CMTime newTime = _avPlayer.currentTime;
    newTime.value = newTime.timescale * seconds;
    [_avPlayer seekToTime:newTime];
}

#pragma mark ---时间获取----
- (float)theCurrentTime{
    if (_avPlayer.currentTime.timescale == 0) {
        return 0;
    }
    return _avPlayer.currentTime.value / _avPlayer.currentTime.timescale;
}

- (float)totalTime{
    if (_avPlayer.currentItem.duration.timescale == 0) {
        return 0;
    }
    return _avPlayer.currentItem.duration.value / _avPlayer.currentItem.duration.timescale;
}


// 上一首
- (void)lastMusic{
    
    if (_playType == RandomPlay){
        _index = arc4random()%_mediaLists.count;
    }else{
        if (_playType == ListPlay){
            if (_index == 0) {
                _index = _mediaLists.count - 1;
            }else{
                _index -- ;
            }
        }
    }
    [self changeMediaWith:_index];
    
}

// 下一首
- (void)nextMusic {
    if (_playType == RandomPlay){
        _index = arc4random()%_mediaLists.count;
    }else{
        if (_playType == ListPlay) {
            if (_index == _mediaLists.count - 1) {
                _index = 0;
            }else{
                _index ++ ;
            }
        }
    
    }
    [self changeMediaWith:_index];

}

// 根据index来切歌
- (void)changeMediaWith:(NSInteger)index{
    _index = index;
    AVPlayerItem *playerItem = [[AVPlayerItem alloc] initWithURL:_mediaLists[_index]];
    [_avPlayer replaceCurrentItemWithPlayerItem:playerItem];
    [self play];
    
    // 当切歌的时候, 发布一通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICECHANGEMEDIA" object:nil userInfo:@{@"index": @(_index)}];

    
}


- (void)playerDidFinish {
    if (_playType == SignelPlay) {
        [self pause];
    }else{
        [self nextMusic];
    }
}

@end
















