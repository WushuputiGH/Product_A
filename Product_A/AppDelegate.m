//
//  AppDelegate.m
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     NSLog(@"%@", [NSSearchPathForDirectoriesInDomains(9, 1, 1) firstObject]);
    // 首先获取未完成的下载任务
    NSData *data = [[NSUserDefaults standardUserDefaults]valueForKey:@"downLoad"];
    NSDictionary *downLoadTaskInfoDict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    // 历遍这个字典, 进行重新布置下载任务
    for (NSString *url in downLoadTaskInfoDict) {
        // 首先获取保存的任务信息
        DownLoadTaskInfo *downloadTaskInfo = downLoadTaskInfoDict[url];
        // 使用musicInfo信息, 恢复下载任务
        DownLoad *task = downloadTaskInfo.task;
        if (task.resumeData) {
             [[DownLoadManager defaultManager] resumeDownloadWithDownloadTaskInfo:downloadTaskInfo];
        }
       
    }
//
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor whiteColor];
    
    RootViewController *rootVC = [[RootViewController  alloc] init];
    self.window.rootViewController = rootVC;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    
    view.backgroundColor = [UIColor blackColor];
    [self.window addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.window);
        make.height.equalTo(@20);
    }];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // 当程序将要退出的时候, 保存未完成的下载任务
    // 首先需要获取未完成的任务
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



}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {


    
    
}

@end
