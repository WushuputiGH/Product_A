//
//  PlayContainerViewController.m
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import "PlayContainerViewController.h"
#import "PlayMainViewController.h"
#import "RadioListTableViewController.h"
#import "PlayTitleView.h"
#import "CommentContainerViewController.h"
#import "ArticleInfoModel.h"

#define kPlayControllerHeight (kScreenHeight / 7.0)


@interface PlayContainerViewController ()<PlayControllerViewDelegate>

@property (nonatomic, strong)UIScrollView *theScrollView;
@property (nonatomic, strong)PlayMainViewController *playMainVC;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)RadioListTableViewController *radioListVC;

@property (nonatomic, assign)BOOL isShowList;

// 添加play控制视图
@property (nonatomic, strong)PlayTitleView *playTitleView;




@end

@implementation PlayContainerViewController




- (void)initialize{
    // 重新定义button按钮(即返回按钮)
    [self.button setTitle:@"" forState:(UIControlStateNormal)];
    UIImage *buttomImage = [UIImage imageNamed:@"u9_start.png"];
    self.button.tintColor = [UIColor darkGrayColor];
    [self.button setImage:buttomImage forState:(UIControlStateNormal)];
    
    self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 128)];
    [self.view addSubview:_theScrollView];
    self.theScrollView.contentSize = CGSizeMake(2 * kScreenWidth, kScreenHeight - 64 - kPlayControllerHeight);
    _theScrollView.bounces = NO;
    _theScrollView.pagingEnabled = YES;
    _theScrollView.scrollEnabled = NO;
    
    // 添加主播放图
    self.playMainVC = [[PlayMainViewController alloc] init];
    self.playMainVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - kPlayControllerHeight);
    [_theScrollView addSubview:_playMainVC.view];
    [self addChildViewController:_playMainVC];
   
    [self.playMainVC.commmentButton addTarget:self action:@selector(comment) forControlEvents:(UIControlEventTouchUpInside)];
    
    // 添加播放列表
    self.radioListVC = [[RadioListTableViewController alloc] init];
    self.radioListVC.view.frame = CGRectMake(0, kScreenHeight - 64 - kPlayControllerHeight, kScreenWidth, 0);
    [_theScrollView addSubview: self.radioListVC.view];
    [self addChildViewController: _radioListVC];
    _radioListVC.musicList = self.musicList;
    _radioListVC.name = self.name;
    
    // 添加上面的循环, 收藏, 分享, 播放列表等
    self.playTitleView = [[[NSBundle mainBundle] loadNibNamed:@"PlayTitleView" owner:nil options:nil] firstObject];
    self.playTitleView.frame = CGRectMake(61, 20, kScreenWidth - 81, 40);
    [self.playTitleView changeAccrodingPlaytype];
    [self.playTitleView.listButton addTarget:self action:@selector(showRadioList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playTitleView];

    
    // 添加playControllerView
    _playControllerView  = [[PlayControllerView alloc] init];
    _playControllerView.frame = CGRectMake(0, kScreenHeight - kPlayControllerHeight, kScreenWidth, kPlayControllerHeight);
    [self.view addSubview:_playControllerView];
    _playControllerView.delegate = self;
    
    // 加载音乐播放器
    _myPlayer = [MyPlayerManager defaultManager];
    NSArray *urlString = [_musicList valueForKeyPath:@"musicUrl"];
    NSMutableArray *musicList = [NSMutableArray array];
    for (NSString *item in urlString) {
        NSURL *url = nil;
        if (_isLocation){
            url = [NSURL fileURLWithPath:item];
            
        }else{
            url = [NSURL URLWithString:item];
        }
       
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
    [self configureShare];
}

- (void)playMusic{

    [_myPlayer play];

    _playMainVC.musicInfo = _musicList[_index];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
    
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
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
    [self configureShare];
    
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

#pragma mark ---配置分享按钮---
- (void)configureShare{
    // 配置 分享按钮
    // 获取分享信息
    NSDictionary *shareInfo = [self.musicList[_index] valueForKeyPath:@"playInfo.shareinfo"];
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:shareInfo[@"pic"]]];
    UIImage *image = [UIImage imageWithData:imageData];
    [self.playTitleView.shareButton configureWithShareTitle:shareInfo[@"title"] shareContent:shareInfo[@"text"] shareUrl:shareInfo[@"url"] shareImage:image];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --- 弹出播放列表----
- (void)showRadioList{

    if (_isShowList) {
        [UIView animateWithDuration:0.5 animations:^{
            self.radioListVC.view.frame = CGRectMake(0, kScreenHeight - 64 - kPlayControllerHeight, kScreenWidth, 0);
        }];
        _isShowList = NO;
    }else{

        [UIView animateWithDuration:0.5 animations:^{
            self.radioListVC.view.frame = self.playMainVC.view.frame;
        }];
        _isShowList = YES;
    }

}

#pragma mark ---弹出评论----

- (void)comment{
    
    CommentContainerViewController *commentVC = [[CommentContainerViewController alloc] init];
//     [parDic setValue:self.articleInfoModel.data[@"contentid"]
    
    NSDictionary *playInfo = [_musicList[_index] valueForKeyPath:@"playInfo"];
    
      
    NSDictionary *data = @{@"contentid": playInfo[@"ting_contentid"]};
    ArticleInfoModel *model = [[ArticleInfoModel alloc] init];
    model.data = data;
    
    commentVC.articleInfoModel = model;
    [self.navigationController pushViewController:commentVC animated:YES];
    
    
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
