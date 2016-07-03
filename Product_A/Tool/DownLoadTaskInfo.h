//
//  DownLoadTaskInfo.h
//  Product_A
//
//  Created by lanou on 16/7/2.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface DownLoadTaskInfo : NSObject <NSCoding>


// 存档下载任务
@property (nonatomic, strong, readwrite) DownLoad *task;
// 存放下载进程
@property (nonatomic, assign, readwrite) NSInteger progress;
// 存放下载地址
@property (nonatomic, strong, readwrite) NSString *path;

@property (nonatomic, strong, readwrite) NSDictionary *musicInfo;



@end
