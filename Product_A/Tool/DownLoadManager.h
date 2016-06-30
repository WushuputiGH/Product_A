//
//  DownLoadManager.h
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownLoad.h"

@interface DownLoadManager : NSObject

+ (DownLoadManager *)defaultManager;

// 创建一个下载任务

- (DownLoad *)creatDownloadWithUrl:(NSString *)url;


@end
