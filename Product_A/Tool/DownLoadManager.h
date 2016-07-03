//
//  DownLoadManager.h
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoad.h"
#import "DownLoadTaskInfo.h"


@interface DownLoadManager : NSObject

+ (DownLoadManager *)defaultManager;

//存放下载任务
// key值是下载对应的网址, value一个DownLoadTaskInfo类
@property (nonatomic, strong)NSMutableDictionary *downLoadTaskInfoDict;



// 创建一个下载任务
//- (DownLoad *)creatDownloadWithUrl:(NSString *)url;
- (DownLoad *)creatDownloadWithMusicInfo:(NSDictionary *)musicInfo;
- (DownLoad *)resumeDownloadWithDownloadTaskInfo:(DownLoadTaskInfo *)downloadTaskInfo;
- (DownLoad *)resumeDownloadWithMusicInfo:(NSDictionary *)musicInfo resumeData:(NSData *)resumeData;

@end
