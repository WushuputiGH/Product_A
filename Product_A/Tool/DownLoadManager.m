//
//  DownLoadManager.m
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import "DownLoadManager.h"
@interface DownLoadManager()<DownloadDelegate>
@property (nonatomic, strong)NSMutableDictionary *dic; //存放下载任务

@end



@implementation DownLoadManager

+ (DownLoadManager *)defaultManager{
    static DownLoadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DownLoadManager alloc] init];
        
    });
    return  manager;
}


- (DownLoad *)creatDownloadWithUrl:(NSString *)url{
    DownLoad *task = self.dic[url];
    if (!task) {
        task = [[DownLoad alloc] initWith:url];
        [self.dic setValue:task forKey:url];
    }
    task.delegate = self;
    return task;
}

- (void)removeDownloadTask:(NSString *)url{
    [self.dic removeObjectForKey:url];
}

@end
