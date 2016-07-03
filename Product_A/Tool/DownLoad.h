//
//  DownLoad.h
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>

// 下载中, 返回瞬时速度与进程
typedef void (^Downloading)(long long bytesWritten, NSInteger progress);

// 下载完后, 返回保存路径和下载地址
typedef void (^DidDownload)(NSString *savePath, NSString *url);

typedef NS_ENUM(NSInteger, DownloadState) {
    DownloadStateNone,
    DownloadStateRunning,
    DownloadStateSuspend,
    DownloadStateCompleted,
};

@protocol DownloadDelegate <NSObject>

- (void)removeDownloadTask:(NSString *)url;

@end

@interface DownLoad : NSObject <NSCoding>
@property (nonatomic, strong)NSURLSession *session;
@property (nonatomic, strong)NSURLSessionDownloadTask *task;
@property (nonatomic, strong, readwrite) NSString *url; // 下载地址
@property (nonatomic, assign, readwrite) NSInteger progress; // 下载进度
@property (nonatomic, assign) id <DownloadDelegate> delegate;

@property (nonatomic, strong)NSData *resumeData;
// 存放状态
@property (nonatomic, assign, readwrite) DownloadState downState;

// 调用可恢复取消时候执行的block
@property (nonatomic, copy, readwrite) void (^cancelResumeBlock) ();

// 给一个下载地址, 初始化
- (instancetype)initWith:(NSString *)url;
-(instancetype)initWithResumeData:(NSData *)resumeData url:(NSString *)ur;

// 开始下载
- (void)start;
// 暂停任务
- (void)suspend;
// 取消下载任务
- (void)cancelTask;
// 恢复
- (void)resumeTask;


// 监听下载的方法
- (void)monitorDownload: (Downloading)downloading didDownLoad:(DidDownload)didDownload;


@end
