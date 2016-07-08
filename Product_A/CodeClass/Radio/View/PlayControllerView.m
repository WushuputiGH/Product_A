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
//        self.backgroundColor = [UIColor orangeColor];
        _lastButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_lastButton setImage:[UIImage imageNamed:@"last3"] forState:(UIControlStateNormal)];
        [self addSubview:_lastButton];
        [_lastButton addTarget:self.delegate action:@selector(lastButton:) forControlEvents:(UIControlEventTouchUpInside)];
        _nextButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_nextButton setImage:[UIImage imageNamed:@"next"] forState:(UIControlStateNormal)];
         [_nextButton addTarget:self.delegate action:@selector(nextButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_nextButton];
        
        _playButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_playButton setImage:[UIImage imageNamed:@"pause"] forState:(UIControlStateNormal)];
        [_playButton addTarget:self.delegate action:@selector(playButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_playButton];
    }
    return self;
}


-(void)layoutSubviews{
    [_lastButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(60);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo (self.mas_height).multipliedBy (1/2.0);
        make.width.equalTo(_lastButton.mas_height);
    }];
    
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-60);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo (self.mas_height).multipliedBy (1/2.0);
        make.width.equalTo(_nextButton.mas_height);
    }];
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo (self.mas_height).multipliedBy (2/3.0);
        make.width.equalTo(_playButton.mas_height);
    }];
}


-(void)setPlayState:(PlayState)playState{
    if (playState == Play) {
         [_playButton setImage:[UIImage imageNamed:@"pause"] forState:(UIControlStateNormal)];
    }
    if (playState == Pause) {
         [_playButton setImage:[UIImage imageNamed:@"start"] forState:(UIControlStateNormal)];
    }
    _playState = playState;
    
}


@end
