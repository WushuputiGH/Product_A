//
//  MyPlayerManager.h
//  Product_A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

// 定义播放模式
typedef NS_ENUM(NSInteger, PlayType)
{
    SignelPlay,
    RandomPlay,
    ListPlay
};

// 播放状态
typedef NS_ENUM(NSInteger, PlayState) {
    Play,
    Pause
};

@interface MyPlayerManager : NSObject
@property (nonatomic, assign, readwrite) PlayState playState;
@property (nonatomic, assign, readwrite) PlayType playType;
@property (nonatomic, strong, readwrite) AVPlayer *avPlayer;
@property (nonatomic, strong, readwrite) NSMutableArray *mediaLists;
@property (nonatomic, assign, readwrite) NSInteger index;
@property (nonatomic, assign, readwrite) float theCurrentTime;
@property (nonatomic, assign, readwrite) float totalTime;


@property (nonatomic, copy, readwrite) void (^changeState) (PlayState state);

+ (MyPlayerManager *)defaultManager;



//暂停
- (void)pause;

// 停止
- (void)stop;
- (void)lastMusic;
- (void)play;
- (void)nextMusic;
- (void)seekToSecondsWith:(float)seconds;
- (void)changeMediaWith:(NSInteger)index;
@end
