//
//  PlayControllerView.h
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPlayerManager.h"

@protocol PlayControllerViewDelegate <NSObject>

- (void)nextButton:(UIButton *)sender;
- (void)lastButton:(UIButton *)sender;
- (void)playButton:(UIButton *)sender;

@end


@interface PlayControllerView : UIView

@property (nonatomic, strong, readwrite) UIButton *lastButton;
@property (nonatomic, strong, readwrite) UIButton *nextButton;
@property (nonatomic, strong, readwrite) UIButton *playButton;
@property (nonatomic, assign, readwrite) PlayState playState;

@property (nonatomic, assign, readwrite) id <PlayControllerViewDelegate> delegate;
@end
