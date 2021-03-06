//
//  PlayMainViewController.m
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import "PlayMainViewController.h"
#import "MyPlayerManager.h"





@interface PlayMainViewController ()

@property (nonatomic, strong, readwrite)UIView *theView;
@property (nonatomic, strong, readwrite)UIScrollView *theScrollerView;
@property (nonatomic, strong, readwrite)UIImageView *imageView;
@property (nonatomic, strong, readwrite)UILabel *titleLabel;
@property (nonatomic, strong, readwrite)UIButton *likeButton;

@property (nonatomic, strong, readwrite)UIButton *downLoadButton;
@property (nonatomic ,strong)CABasicAnimation *animation;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong)UIView *theCommentView;

@property (nonatomic, strong)UIWebView *theWebView;


@end

@implementation PlayMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initializeSubview];
    [self constaintSubview];
   
    // 设置播放器的状态回调
    [MyPlayerManager defaultManager].changeState = ^(PlayState state){
        [self changeState:state];
    };

     [self addAnimation];
    
    // 创建定时器, 用于监控下载
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(downLoadTimer:) userInfo:nil repeats:1];
    
    
}

- (void)addAnimation{
    _animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    _animation.toValue = [NSNumber numberWithFloat:M_PI * 2];
    _animation.duration = 15;
    _animation.repeatCount = HUGE_VALF;
    [_imageView.layer addAnimation:_animation forKey:@"myAnimation"];
}


- (void)changeState:(PlayState) state{
    if (state == Pause) {
        CFTimeInterval pausedTime = [_imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil];
        _imageView.layer.speed = 0.0;
        _imageView.layer.timeOffset = pausedTime;
    }
    if (state == Play) {
        CFTimeInterval pausedTime = [_imageView.layer timeOffset];
        _imageView.layer.speed = 1.0;
        _imageView.layer.timeOffset = 0.0;
        _imageView.layer.beginTime = 0.0;
        CFTimeInterval timeSincePause = [_imageView.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
        _imageView.layer.beginTime = timeSincePause;
    }
}





- (void)initializeSubview{
    _theScrollerView = [[UIScrollView alloc] init];
    [self.view addSubview:_theScrollerView];
    
    _theView = [[UIView alloc] init];
    [self.view addSubview:_theView];
    
    _theCommentView = [[UIView alloc] init];
    [_theScrollerView addSubview:_theCommentView];
    
    _theWebView = [[UIWebView alloc] init];
    [_theScrollerView addSubview:_theWebView];
    
    _imageView = [[UIImageView alloc] init];
//    _imageView.backgroundColor = [UIColor orangeColor];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:_musicInfo[@"coverimg"]]];
    [_theCommentView addSubview:_imageView];
    _imageView.clipsToBounds = YES;
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.numberOfLines = 0;
  
    [_theCommentView addSubview:_titleLabel];
    
    _likeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_likeButton setImage:[UIImage imageNamed:@"speach"] forState:(UIControlStateNormal)];
    [_theCommentView addSubview:_likeButton];
    
    _commmentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_commmentButton setImage:[UIImage imageNamed:@"speach"] forState:UIControlStateNormal];

    [_theCommentView addSubview:_commmentButton];
    
    _downLoadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_downLoadButton setImage:[UIImage imageNamed:@"download2"] forState:UIControlStateNormal];
    [_downLoadButton addTarget:self action:@selector(downloadAction:) forControlEvents:(UIControlEventTouchUpInside)];
     [_downLoadButton.imageView setContentMode:1];
    
    
    [_theCommentView addSubview:_downLoadButton];
    
    _progressView = [[UISlider alloc] init];
    [_progressView addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [_theView addSubview:_progressView];
    [_progressView setThumbImage:nil forState:(UIControlStateNormal)];
    
    _totalTimeLabel = [[UILabel alloc] init];
    [_theView addSubview:_totalTimeLabel];
    
 
}



- (void)constaintSubview{
    
    [_theScrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
    _theScrollerView.contentSize = CGSizeMake(2 * self.view.frame.size.width, 0);
    _theScrollerView.pagingEnabled = YES;
    
    
    _theCommentView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    
//    [_theCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(0);
//        make.left.width.equalTo(self.view);
//        make.bottom.equalTo(self.view).offset(0);
//    }];
//    
    [_theWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.width.equalTo(self.view);
        make.left.equalTo(_theCommentView.mas_right);
        make.bottom.equalTo(self.view).offset(0);
    }];

    _theWebView.backgroundColor = [UIColor redColor];
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_theCommentView).offset(45);
        make.right.equalTo(_theCommentView).offset(-45);
        make.height.equalTo(_imageView.mas_width);
    }];
    
    _imageView.layer.cornerRadius = (self.view.frame.size.width - 90) / 2;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(30);
        make.centerX.equalTo(_theCommentView.mas_centerX);
        make.width.lessThanOrEqualTo(_theCommentView.mas_width).offset(-30);
    }];

    [_downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_theCommentView.mas_centerX).offset(-50);
        make.top.equalTo(_titleLabel.mas_bottom).offset(30);
        make.height.equalTo(@33);
        make.width.equalTo(@70);
    }];
    
    [_commmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_theCommentView.mas_centerX).offset(50);
        make.top.equalTo(_downLoadButton);
        make.height.width.equalTo(@33);
    }];

    
    
    [_theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.view);
        make.top.equalTo(_commmentButton.mas_bottom).offset(10);
        make.height.equalTo(self.view).multipliedBy(0.2);
    }];
//    _theView.backgroundColor = [UIColor orangeColor];
    
//    [_downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(_theView).offset(30);
//        make.centerY.equalTo(_theView.mas_centerY);
//        make.height.equalTo(@30);
//        make.width.equalTo(@70);
//    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_theView.mas_left);
        make.centerY.equalTo(_theView.mas_centerY);
        make.right.equalTo(_theView.mas_right);
        make.height.equalTo(@30);
    }];
    
  
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_progressView.mas_bottom);
        make.right.equalTo(_theView).offset(-10);
    }];
}

-(void)setMusicInfo:(NSMutableDictionary *)musicInfo{
    
    
    _musicInfo = [musicInfo mutableCopy];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_musicInfo[@"coverimg"]]];
    _titleLabel.text = [_musicInfo valueForKeyPath:@"playInfo.title"];
    
    NSString *html = [musicInfo valueForKeyPath:@"playInfo.webview_url"];
    
//    [self.theWebView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
    
    [self.theWebView setBackgroundColor:[UIColor clearColor]];
    [self.theWebView setOpaque:NO];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString: html]];
    [self.theWebView  loadRequest:request];
    // 移除动画, 重新添加动画
    [_imageView.layer removeAnimationForKey:@"myAnimation"];
    [self addAnimation];

}


//

- (void)sliderAction:(UISlider *)sender{
    
    [[MyPlayerManager defaultManager] pause];
    [[MyPlayerManager defaultManager] seekToSecondsWith:sender.value];
    [[MyPlayerManager defaultManager] play];
}

#pragma mark ---下载----
- (void)downloadAction:(UIButton *)button{
    
    // 获取默认下载列队
    DownLoadManager *dManager = [DownLoadManager defaultManager];
    
    // 1. 首先获取音乐的usrl
    NSString *musicUrlString = _musicInfo[@"musicUrl"];
    // 2.添加在下载列队的所有url
    NSArray *downLoadlist = [DownLoadManager defaultManager].downLoadTaskInfoDict.allKeys;
    [_downLoadButton setImage:nil forState:(UIControlStateNormal)];
    
    if ([downLoadlist containsObject:musicUrlString]) {
         // 如果存在
        DownLoadTaskInfo *downLoadInfo = [dManager.downLoadTaskInfoDict valueForKey:musicUrlString];
        // 判断目前的下载状态
        switch (downLoadInfo.task.downState) {
            case DownloadStateSuspend:
                [downLoadInfo.task resumeTask];
                break;
            case DownloadStateRunning:
                [downLoadInfo.task suspend];
                break;
            default:
                break;
        }
    }else{
        DownLoad *task = [dManager creatDownloadWithMusicInfo:_musicInfo];
        [task start];
    }
}

- (void)downLoadTimer:(NSTimer *)timer{
    
    // 给downButton添加监听
    // 1. 首先获取音乐的usrl
    NSString *musicUrlString = _musicInfo[@"musicUrl"];
    // 2.添加在下载列队的所有url
    DownLoadManager *dManager = [DownLoadManager defaultManager];
    NSArray *downLoadlist = dManager.downLoadTaskInfoDict.allKeys;
    
    // 3. 判断是否存在
    // >1. 如果不存在, 设置button的图片为原本图片, 如果存在, 监听
    if ([downLoadlist containsObject:musicUrlString]) {
        [_downLoadButton setImage:nil forState:(UIControlStateNormal)];
         DownLoadTaskInfo *downLoadInfo = [dManager.downLoadTaskInfoDict valueForKey:musicUrlString];
        switch (downLoadInfo.task.downState) {
            case DownloadStateNone:
                [_downLoadButton setTitle:nil forState:(UIControlStateNormal)];
                [_downLoadButton setImage:[UIImage imageNamed:@"download2"] forState:UIControlStateNormal];
                break;
            case DownloadStateRunning:
                _downLoadButton.titleLabel.text = [NSString stringWithFormat:@"%2ld%%", downLoadInfo.progress];
                [_downLoadButton setTitle:[NSString stringWithFormat:@"%2ld%%", downLoadInfo.progress] forState:(UIControlStateNormal)];
                break;
            case DownloadStateSuspend:
                _downLoadButton.titleLabel.text = [NSString stringWithFormat:@"%2ld%% 继续", downLoadInfo.progress];
                [_downLoadButton setTitle:[NSString stringWithFormat:@"%2ld%% 继续", downLoadInfo.progress] forState:(UIControlStateNormal)];
                break;
            default:
                break;
        }

    }else{
        // 获取所有的观察者信息
        [_downLoadButton setTitle:nil forState:(UIControlStateNormal)];
        [_downLoadButton setImage:[UIImage imageNamed:@"download2"] forState:UIControlStateNormal];
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
