//
//  PlayContainerViewController.m
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import "PlayContainerViewController.h"
#import "PlayMainViewController.h"




@interface PlayContainerViewController ()<PlayControllerViewDelegate>

@property (nonatomic, strong)UIScrollView *theScrollView;
@property (nonatomic, strong)PlayMainViewController *playMainVC;
@property (nonatomic, strong)NSTimer *timer;

@end

@implementation PlayContainerViewController


- (void)initialize{
    // 重新定义button按钮(即返回按钮)
    [self.button setTitle:@"" forState:(UIControlStateNormal)];
    UIImage *buttomImage = [UIImage imageNamed:@"u9_start.png"];
    self.button.tintColor = [UIColor darkGrayColor];
    [self.button setImage:buttomImage forState:(UIControlStateNormal)];
    
    self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview:_theScrollView];
    
    self.playMainVC = [[PlayMainViewController alloc] init];
    [_theScrollView addSubview:_playMainVC.view];
    [self addChildViewController:_playMainVC];
    
    // 添加playControllerView
    _playControllerView  = [[PlayControllerView alloc] init];
    _playControllerView.frame = CGRectMake(0, kScreenHeight - 64, kScreenWidth, 64);
    [self.view addSubview:_playControllerView];
    _playControllerView.delegate = self;
    
    // 加载音乐播放器
    _myPlayer = [MyPlayerManager defaultManager];
    NSArray *urlString = [_musicList valueForKeyPath:@"musicUrl"];
    NSMutableArray *musicList = [NSMutableArray array];
    for (NSString *item in urlString) {
        NSURL *url = [NSURL URLWithString:item];
        [musicList addObject:url];
    }

    if (!_myPlayer.mediaLists) {
        _myPlayer.index = _index;
        _myPlayer.mediaLists = musicList;
    }else{
        // 如果已经在播放, 获取目前播放是url
        NSInteger currentIndex = _myPlayer.index;
        NSURL *radioId = _myPlayer.mediaLists[currentIndex];
        //判断是否是正在需要播放的歌曲
        NSURL *willRadioId = musicList[_index];
        
        if (![radioId isEqual:willRadioId ]) {
            _myPlayer.index = _index;
            _myPlayer.mediaLists = musicList;
        }
    }
    // 添加定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
    [self.timer fire];
    
    // 添加通知, 当播放结束的时候
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(nextMusic) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    
    // 播放音乐
    [self playMusic];
    
    // 添加切换音乐的通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMedia:) name:@"NOTICECHANGEMEDIA" object:nil];

}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialize];
}

- (void)playMusic{

    [_myPlayer play];

    _playMainVC.musicInfo = _musicList[_index];
    
}

- (void)viewWillAppear:(BOOL)animated{
     _playMainVC.musicInfo = _musicList[_index];
}



- (void)timerAction:(NSTimer *)timer{
    
    // 获取歌曲总时间
    NSInteger totalTime = (NSInteger) _myPlayer.totalTime;
    _playMainVC.totalTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", totalTime / 60,totalTime % 60];
    
    _playMainVC.progressView.maximumValue = totalTime;
    NSInteger currentTime = (NSInteger)_myPlayer.theCurrentTime;
    _playMainVC.progressView.value = currentTime;

}


- (void)nextMusic{
    [_myPlayer nextMusic];
}


// 重写button的点击方法
- (void)buttonAction:(UIButton *)button{
        
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)setIndex:(NSInteger)index{
    if (_index != index) {
        if (_myPlayer) {
            if (_myPlayer.index != index) {
                [_myPlayer changeMediaWith: index];
            }
        }
        _index = index;
    }
}


//- (void)setMusicList:(NSMutableArray *)musicList{
//    
//}

#pragma mark --- 监听音乐改变时候的通知 ---
- (void)changeMedia: (NSNotification *)sender{
    NSNumber *indexNum = sender.userInfo[@"index"];
    _index = indexNum.integerValue;
    // 更改播放主界面的画面
    _playMainVC.musicInfo = _musicList[_index];
}

#pragma mark ----实现PlayController的代理方法

- (void)nextButton:(UIButton *)sender{
    [_myPlayer nextMusic];
    _playControllerView.playState = Play;
}
- (void)lastButton:(UIButton *)sender{
    [_myPlayer lastMusic];
    _playControllerView.playState = Play;
}
- (void)playButton:(UIButton *)sender{
    
    if (_playControllerView.playState == Play) {
        [[MyPlayerManager defaultManager] pause];
        _playControllerView.playState = Pause;
    }else{
        [[MyPlayerManager defaultManager] play];
        _playControllerView.playState = Play;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
