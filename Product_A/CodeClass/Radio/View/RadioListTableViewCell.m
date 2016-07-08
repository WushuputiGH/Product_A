//
//  RadioListTableViewCell.m
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RadioListTableViewCell.h"

@implementation RadioListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.downLoadload = [UIButton buttonWithType:(UIButtonTypeSystem)];
       
        _downLoadload = [UIButton buttonWithType:UIButtonTypeSystem];
        
        UIImage *image = [[UIImage imageNamed:@"download2"] imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        
        [self.downLoadload setImage:image forState:UIControlStateNormal];
        [_downLoadload.imageView setContentMode:1];
        [self.contentView addSubview:self.downLoadload];
        [self.downLoadload addTarget:self action:@selector(downloadAction:) forControlEvents:(UIControlEventTouchUpInside)];
        self.textLabel.numberOfLines = 0;
       
        
    
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [_downLoadload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@30);
        make.width.equalTo(@70);
    }];

    
}

- (void)configureWithMusicInfoDic:(NSDictionary *)musicInfo{
    _musicInfo = musicInfo;
    self.textLabel.text = [_musicInfo valueForKeyPath:@"playInfo.title"];
    // 获取默认下载列队
    DownLoadManager *dManager = [DownLoadManager defaultManager];

    // 1. 获取音乐的usrl
    NSString *musicUrlString = musicInfo[@"musicUrl"];
    
  
   

    
    
    // 2.添加在下载列队的所有url
    NSArray *downLoadlist = [DownLoadManager defaultManager].downLoadTaskInfoDict.allKeys;
    [self.downLoadload setImage:nil forState:(UIControlStateNormal)];

    if ([downLoadlist containsObject:musicUrlString]) {
        // 如果存在
        DownLoadTaskInfo *downLoadInfo = [dManager.downLoadTaskInfoDict valueForKey:musicUrlString];
        // 判断目前的下载状态
        self.downloadState = downLoadInfo.task.downState;
      
    }else{
        self.downloadState = DownloadStateNone;
        
    }

}

- (void)changeDownloadButton:(NSDictionary *)musicInfo{
    
    // 获取默认下载列队
    DownLoadManager *dManager = [DownLoadManager defaultManager];
    
    // 1. 获取音乐的usrl
    NSString *musicUrlString = musicInfo[@"musicUrl"];
    DownLoadTaskInfo *downLoadInfo = [dManager.downLoadTaskInfoDict valueForKey:musicUrlString];
    
    switch (self.downloadState) {
        case DownloadStateNone:
            self.downLoadload.titleLabel.text = nil;
            [self.downLoadload setTitle:nil forState:(UIControlStateNormal)];
            
            [self.downLoadload setImage:[UIImage imageNamed:@"download2"] forState:UIControlStateNormal];
            break;
        case DownloadStateRunning:
            NSLog(@"%ld" ,(long)downLoadInfo.task.task.state);
            self.downLoadload.titleLabel.text = [NSString stringWithFormat:@"%2ld%%", downLoadInfo.progress];
            [self.downLoadload setTitle:[NSString stringWithFormat:@"%2ld%%", downLoadInfo.progress] forState:(UIControlStateNormal)];
            break;
        case DownloadStateSuspend:
            self.downLoadload.titleLabel.text = [NSString stringWithFormat:@"%2ld%% 继续", downLoadInfo.progress];
            [self.downLoadload setTitle:[NSString stringWithFormat:@"%2ld%% 继续", downLoadInfo.progress] forState:(UIControlStateNormal)];
            break;
        default:
            break;
    }
}


- (void)downloadAction:(UIButton *)button{
    
    // 获取默认下载列队
    DownLoadManager *dManager = [DownLoadManager defaultManager];
    
    // 1. 首先获取音乐的usrl
    NSString *musicUrlString = _musicInfo[@"musicUrl"];
    // 2.添加在下载列队的所有url
    NSArray *downLoadlist = [DownLoadManager defaultManager].downLoadTaskInfoDict.allKeys;
    [_downLoadload setImage:nil forState:(UIControlStateNormal)];
    
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
//        dManager.completedHandle = ^(NSString *savePath){
//            // 下载完成之后, 创建表
//            RadioDownloadTable *radioDownTable = [[RadioDownloadTable alloc] init];
//            [radioDownTable creatTable];
//            // 插入数据 title, musicUrl, musicImg, musicPath
//            NSArray *array = @[_musicInfo[@"title"], _musicInfo[@"musicUrl"], _musicInfo[@"coverimg"], savePath];
//            [radioDownTable insertIntoTabel:array];
//        };
        [task start];
    }
    
}


@end
