//
//  PlayControllerView.m
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import "PlayControllerView.h"


@implementation PlayControllerView


- (instancetype)init
{
    self = [super init];
    if (self) {
        _lastButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_lastButton setImage:[UIImage imageNamed:@"music_icon_last_highlighted"] forState:(UIControlStateNormal)];
        [self addSubview:_lastButton];
        [_lastButton addTarget:self.delegate action:@selector(lastButton:) forControlEvents:(UIControlEventTouchUpInside)];
        _nextButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_nextButton setImage:[UIImage imageNamed:@"music_icon_next_highlighted"] forState:(UIControlStateNormal)];
         [_nextButton addTarget:self.delegate action:@selector(nextButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_nextButton];
        
        _playButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_playButton setImage:[UIImage imageNamed:@"music_icon_play_highlighted"] forState:(UIControlStateNormal)];
        [_playButton addTarget:self.delegate action:@selector(playButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_playButton];
    }
    return self;
}


-(void)layoutSubviews{
    [_lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(60);
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.equalTo(@30);
    }];
    
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-60);
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.equalTo(@30);
    }];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.width.equalTo(@30);
    }];
}


-(void)setPlayState:(PlayState)playState{
    if (playState == Play) {
         [_playButton setImage:[UIImage imageNamed:@"music_icon_play_highlighted"] forState:(UIControlStateNormal)];
    }
    if (playState == Pause) {
         [_playButton setImage:[UIImage imageNamed:@"music_icon_stop_highlighted"] forState:(UIControlStateNormal)];
    }
    _playState = playState;
    
}


@end
