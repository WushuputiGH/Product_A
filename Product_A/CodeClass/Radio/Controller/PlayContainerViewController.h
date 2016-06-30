//
//  PlayContainerViewController.h
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RightViewController.h"
#import "PlayControllerView.h"
#import "MyPlayerManager.h"
@interface PlayContainerViewController : RightViewController

@property (nonatomic, strong, readwrite) NSMutableArray *musicList;
@property (nonatomic, assign, readwrite) NSInteger index;
@property (nonatomic, strong, readwrite) NSString *currentRadioId;
@property (nonatomic, strong)PlayControllerView *playControllerView;
@property (nonatomic, strong)MyPlayerManager *myPlayer;
@property (nonatomic, strong, readwrite) NSString *name;

- (void)initialize;

@end
