//
//  DownLoadManager.m
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import "DownLoadManager.h"

static DownLoadManager *manager = nil;

@interface DownLoadManager()<DownloadDelegate>

@end

@implementation DownLoadManager

+ (DownLoadManager *)defaultManager{
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadManager alloc] init];
        manager.downLoadTaskInfoDict = [NSMutableDictionary dictionary];
        
    });
    return  manager;
}


- (DownLoad *)creatDownloadWithMusicInfo:(NSDictionary *)musicInfo{
    NSString *url = musicInfo[@"musicUrl"];
    DownLoad *task = self.downLoadTaskInfoDict[url];
    if (!task) {
        DownLoadTaskInfo *downLoadTaskInfo = [[DownLoadTaskInfo alloc] init];
        task = [[DownLoad alloc] initWith:url];
        [task monitorDownload:^(long long bytesWritten, NSInteger progress) {
            downLoadTaskInfo.progress = progress;
        } didDownLoad:^(NSString *savePath, NSString *url) {
            downLoadTaskInfo.path = savePath;
            // 下载完成之后, 创建表
            RadioDownloadTable *radioDownTable = [[RadioDownloadTable alloc] init];
            [radioDownTable creatTable];

             //插入数据 title, musicUrl, musicImg, musicPath
            NSArray *array = @[musicInfo[@"title"], musicInfo[@"musicUrl"], musicInfo[@"coverimg"], savePath];
            [radioDownTable insertIntoTabel:array];
        }];
        downLoadTaskInfo.task = task;
        downLoadTaskInfo.musicInfo = musicInfo;
        [self.downLoadTaskInfoDict setValue:downLoadTaskInfo forKey:url];
        //
        task.cancelResumeBlock = ^(DownLoad *theTask, NSData *theResumeData){
            NSData *downLoadTaskInfoData = [NSKeyedArchiver archivedDataWithRootObject:[DownLoadManager defaultManager].downLoadTaskInfoDict];
            
            [[NSUserDefaults standardUserDefaults] setObject: downLoadTaskInfoData forKey:@"downLoad"];
            NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(9, 1, 1) firstObject]);
 
        };
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"COMPLETEDOWNLOAD" object:nil userInfo:nil];
    }
    task.delegate = self;
    return task;
}







- (DownLoad *)resumeDownloadWithDownloadTaskInfo:(DownLoadTaskInfo *)downloadTaskInfo{
    // 获取存在任务里面的musicInfo信息
    NSDictionary *musicInfo = downloadTaskInfo.musicInfo;
    NSString *url = musicInfo[@"musicUrl"];
    DownLoad *task = self.downLoadTaskInfoDict[url];
    
    if (!task) {
        // 获取以前的下载任务
        task = downloadTaskInfo.task;
        // 赋值新的下载任务
        task = [[DownLoad alloc] initWithResumeData:task.resumeData url:url];
        [task monitorDownload:^(long long bytesWritten, NSInteger progress) {
            downloadTaskInfo.progress = progress;
        } didDownLoad:^(NSString *savePath, NSString *url) {
            downloadTaskInfo.path = savePath;
            // 下载完成之后, 创建表
            RadioDownloadTable *radioDownTable = [[RadioDownloadTable alloc] init];
            [radioDownTable creatTable];
            
            //插入数据 title, musicUrl, musicImg, musicPath
            NSArray *array = @[musicInfo[@"title"], musicInfo[@"musicUrl"], musicInfo[@"coverimg"], savePath];
            [radioDownTable insertIntoTabel:array];
        }];
        downloadTaskInfo.task = task;
        downloadTaskInfo.musicInfo = musicInfo;
        [self.downLoadTaskInfoDict setValue:downloadTaskInfo forKey:url];
        //
        
        task.cancelResumeBlock = ^(DownLoad *theTask, NSData *theResumeData){
            NSData *downLoadTaskInfoData = [NSKeyedArchiver archivedDataWithRootObject:[DownLoadManager defaultManager].downLoadTaskInfoDict];
            
            [[NSUserDefaults standardUserDefaults] setObject: downLoadTaskInfoData forKey:@"downLoad"];
            
            
            NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(9, 1, 1) firstObject]);
        };

        [[NSNotificationCenter defaultCenter] postNotificationName:@"COMPLETEDOWNLOAD" object:nil userInfo:nil];
    }
    task.delegate = self;
    return task;
}





//- (DownLoad *)creatDownloadWithUrl:(NSString *)url{
//    DownLoad *task = self.downLoadTaskInfoDict[url];
//    if (!task) {
//        DownLoadTaskInfo *downLoadTaskInfo = [[DownLoadTaskInfo alloc] init];
//        task = [[DownLoad alloc] initWith:url];
//        [task monitorDownload:^(long long bytesWritten, NSInteger progress) {
//            downLoadTaskInfo.progress = progress;
//        } didDownLoad:^(NSString *savePath, NSString *url) {
//            downLoadTaskInfo.path = savePath;
//            if(_completedHandle){
//                _completedHandle(downLoadTaskInfo.path);
//            }
//        }];
//        downLoadTaskInfo.task = task;
//        [self.downLoadTaskInfoDict setValue:downLoadTaskInfo forKey:url];
//    }
//    task.delegate = self;
//    return task;
//}

- (void)removeDownloadTask:(NSString *)url{
    [self.downLoadTaskInfoDict removeObjectForKey:url];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"COMPLETEDOWNLOAD" object:nil userInfo:nil];
 
    NSDictionary *downLoadTaskInfoDict = [DownLoadManager defaultManager].downLoadTaskInfoDict;
    // 遍历字典, 对每一个任务执行cancelTask方法
    for (NSString *url in downLoadTaskInfoDict) {
        // 获取每一个任务信息
        DownLoadTaskInfo *taskInfo = downLoadTaskInfoDict[url];
        // 获取每一个任务
        DownLoad *task = taskInfo.task;
        // 每一个task执行cancelTask的方法
        [task cancelTask];
    }
    if (downLoadTaskInfoDict.count == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"downLoad"];
    }
    


}

@end
