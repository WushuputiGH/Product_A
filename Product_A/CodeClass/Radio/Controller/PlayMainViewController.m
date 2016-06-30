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
@property (nonatomic, strong, readwrite)UIImageView *imageView;
@property (nonatomic, strong, readwrite)UILabel *titleLabel;
@property (nonatomic, strong, readwrite)UIButton *likeButton;
@property (nonatomic, strong, readwrite)UIButton *commmentButton;
@property (nonatomic, strong, readwrite)UIButton *downLoadButton;
@property (nonatomic ,strong)CABasicAnimation *animation;

@end

@implementation PlayMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializeSubview];
    [self constaintSubview];
   
    
    // 设置播放器的状态回调
    [MyPlayerManager defaultManager].changeState = ^(PlayState state){
        [self changeState:state];
    };

     [self addAnimation];
    
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
    
    _theView = [[UIView alloc] init];
    [self.view addSubview:_theView];
    
    _imageView = [[UIImageView alloc] init];
//    _imageView.backgroundColor = [UIColor orangeColor];
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:_musicInfo[@"coverimg"]]];
    [_theView addSubview:_imageView];
    _imageView.clipsToBounds = YES;
    
    
    _titleLabel = [[UILabel alloc] init];
  
    [_theView addSubview:_titleLabel];
    
    _likeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [_likeButton setImage:[UIImage imageNamed:@"u35.png"] forState:(UIControlStateNormal)];
    [_theView addSubview:_likeButton];
    
    _commmentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_commmentButton setImage:[UIImage imageNamed:@"u40.png"] forState:UIControlStateNormal];
    [_theView addSubview:_commmentButton];
    
    _downLoadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_downLoadButton setImage:[UIImage imageNamed:@"u148_end.png"] forState:UIControlStateNormal];
    [_downLoadButton addTarget:self action:@selector(downloadAction:) forControlEvents:(UIControlEventTouchDown)];
    
    [_theView addSubview:_downLoadButton];
    
    _progressView = [[UISlider alloc] init];
    [_progressView addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [_theView addSubview:_progressView];
    
    _totalTimeLabel = [[UILabel alloc] init];
    [_theView addSubview:_totalTimeLabel];
    
 
}



- (void)constaintSubview{
    
    [_theView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(0);
        make.left.width.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(0);
    }];
    
   
    
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_theView).offset(45);
        make.right.equalTo(_theView).offset(-45);
        make.height.equalTo(_imageView.mas_width);
    }];
//
    _imageView.layer.cornerRadius = (self.view.frame.size.width - 90) / 2;
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageView.mas_bottom).offset(62);
        make.centerX.equalTo(_theView.mas_centerX);
    }];

    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_theView).offset(100);
        make.top.equalTo(_titleLabel).offset(30);
        make.height.width.equalTo(@20);
    }];
    
    [_commmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_theView).offset(-100);
        make.top.equalTo(_titleLabel).offset(30);
        make.height.width.equalTo(@20);
    }];
    
    [_downLoadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_theView).offset(50);
        make.centerY.equalTo(_titleLabel.mas_bottom).offset(50);
        make.height.width.equalTo(@30);
    }];
    
    [_progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_likeButton.mas_left);
        make.centerY.equalTo(_titleLabel.mas_bottom).offset(50);
        make.right.equalTo(_commmentButton.mas_right);
    }];
    
  
    
    [_totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel.mas_bottom).offset(50);
        make.right.equalTo(_theView).offset(-50);
    }];
}

-(void)setMusicInfo:(NSMutableDictionary *)musicInfo{
    
    _musicInfo = [musicInfo mutableCopy];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_musicInfo[@"coverimg"]]];
    _titleLabel.text = _musicInfo[@"title"];

}


//

- (void)sliderAction:(UISlider *)sender{
    
    [[MyPlayerManager defaultManager] pause];
    [[MyPlayerManager defaultManager] seekToSecondsWith:sender.value];
    [[MyPlayerManager defaultManager] play];
    
    
}

#pragma mark ---下载----
- (void)downloadAction:(UIButton *)button{
    [button setImage:nil forState:(UIControlStateNormal)];
    
    DownLoadManager *dManager = [DownLoadManager defaultManager];

    DownLoad *task = [dManager creatDownloadWithUrl:_musicInfo[@"musicUrl"]];
    [task start];
    
    // 监听
    [task monitorDownload:^(long long bytesWritten, NSInteger progress) {
        NSLog(@"%lld, %ld", bytesWritten, progress);
        [_downLoadButton setTitle:[NSString stringWithFormat:@"%ld", (long)progress] forState:(UIControlStateNormal)];
    } didDownLoad:^(NSString *savePath, NSString *url) {
        NSLog(@"%@", savePath);
        
        // NSLog(@"%@", _musicInfo);
        // 保存数据
        RadioDownloadTable *table = [[RadioDownloadTable alloc] init];
        [table creatTable];
        //title, musicUrl, musicImg, musicPath
        NSArray *music = @[_musicInfo[@"title"], _musicInfo[@"musicUrl"], _musicInfo[@"coverimg"], savePath];
        [table insertIntoTabel:music];
        
    }];
    
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
