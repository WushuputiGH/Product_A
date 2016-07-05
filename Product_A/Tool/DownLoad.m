//
//  DownLoad.m
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import "DownLoad.h"

@interface DownLoad()<NSURLSessionDownloadDelegate>



@property (nonatomic, copy)DidDownload didDownload;
@property (nonatomic, copy)Downloading downloading;



@end

@implementation DownLoad


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.url forKey:@"url"];
    [aCoder encodeObject:@(self.progress) forKey:@"progress"];
    [aCoder encodeObject:@(self.downState) forKey:@"downState"];
    [aCoder encodeObject:self.resumeData forKey:@"resumeData"];
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.url = [aDecoder decodeObjectForKey:@"url"];
        NSNumber *progress = [aDecoder decodeObjectForKey:@"progress"];
        self.progress = progress.integerValue;
        NSNumber *state = [aDecoder decodeObjectForKey:@"downState"];
        self.downState = state.integerValue;
        self.resumeData = [aDecoder decodeObjectForKey:@"resumeData"];
    
    }
    return self;
}


// 使用url创建任务
-(instancetype)initWith:(NSString *)url{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 根据配置, 创建网络会话
        self.session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        self.task = [self.session downloadTaskWithURL:[NSURL URLWithString:url]];
        _url = url;
    }
    return self;
}


// 使用resumedata, 恢复任务
-(instancetype)initWithResumeData:(NSData *)resumeData url:(NSString *)url{
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
        // 根据配置, 创建网络会话
        NSURLSession *session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
        _task = [session downloadTaskWithResumeData:resumeData];
        self.downState = DownloadStateSuspend;
        _url = url;
    }
    return self;
}


// 使用resumedata, 升级任务
-(instancetype)updataWithResumeData:(NSData *)resumeData{
  
    if (resumeData == nil) {
        return self;
    }

    NSURLSessionConfiguration *cfg = [NSURLSessionConfiguration defaultSessionConfiguration];
    // 根据配置, 创建网络会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:cfg delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    _task = [session downloadTaskWithResumeData:resumeData];
   
    return self;
}



- (void)start{
    [_task resume];
    self.downState = DownloadStateRunning;
}


 // 取消下载任务
- (void)cancelTask{
    // 取消任务后, 将任务保存
    [self.task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
        self.cancelResumeBlock(self, resumeData);
        [self updataWithResumeData:resumeData];
        if (self.downState == DownloadStateRunning) {
            [self start];
        }
        
    }];
}


//  暂停任务
-(void)suspend{
    [_task suspend];
    self.downState = DownloadStateSuspend;
}

// 恢复
- (void)resumeTask {

    [_task resume];
    self.downState = DownloadStateRunning;
}



// 监听下载
- (void)monitorDownload:(Downloading)downloading didDownLoad:(DidDownload)didDownload{
    _didDownload = didDownload;
    _downloading = downloading;
}

#pragma mark --- 下载代理----

// 下载完成
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    if (_didDownload) {
        self.downState = DownloadStateCompleted;        
        // 获取cache文件夹的路径
        NSString *cashesPath = [NSSearchPathForDirectoriesInDomains(13, 1, 1) lastObject];
        // 拼接下载的路径
        //downloadTask.response.suggestedFilename //建议文件名字
        NSString *filePath = [cashesPath stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
        NSLog(@"文件路径 --- > %@", filePath);
        //将文件移动
        NSFileManager *fm = [NSFileManager defaultManager];
        NSLog(@"原始保存路径 --->%@", location.path);
        [fm moveItemAtPath:location.path toPath:filePath error:nil];
        
        if (_didDownload) {
              _didDownload(filePath, _url);
        }
        
        if (_delegate && [_delegate respondsToSelector:@selector(removeDownloadTask:)]){
            [_delegate removeDownloadTask:_url];
        }
        
        
        
        
        [session invalidateAndCancel];
    }
    
    
}

// 下载中
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    if (_downloading) {
        // 参数: 速度, 进度
        float progress = (float)totalBytesWritten / totalBytesExpectedToWrite;
        _progress = progress * 100;
        _downloading(bytesWritten, _progress);
    }
}

- (void)dealloc{
    _delegate = nil;
    NSLog(@"%s", __FUNCTION__);
}

@end
