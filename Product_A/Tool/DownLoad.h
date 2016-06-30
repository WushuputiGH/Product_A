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

@protocol DownloadDelegate <NSObject>

- (void)removeDownloadTask:(NSString *)url;

@end

@interface DownLoad : NSObject

@property (nonatomic, strong, readwrite) NSString *url; // 下载地址
@property (nonatomic, assign, readwrite) NSInteger progress; // 下载进度
@property (nonatomic, assign) id <DownloadDelegate> delegate;

// 给一个下载地址, 初始化
- (instancetype)initWith:(NSString *)url;

// 开始下载
- (void)start;

// 监听下载的方法
- (void)monitorDownload: (Downloading)downloading didDownLoad:(DidDownload)didDownload;






@end
