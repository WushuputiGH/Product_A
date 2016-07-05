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

@property(nonatomic, strong)NSTimer *timer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 当初始化的时候后, 首先初始化下载任务
    [self initDownloadManager];
    
    
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

    // 当程序退出活跃状态的时候, 开启定时器
    [self saveDownloadCache];
    
   NSLog(@"1");
}




- (void)applicationDidEnterBackground:(UIApplication *)application {
  NSLog(@"2");
}



- (void)applicationWillEnterForeground:(UIApplication *)application {
 
      NSLog(@"3");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
      NSLog(@"4");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"5");

}

- (void)initDownloadManager{
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
        if (task.resumeData ) {
            [[DownLoadManager defaultManager] resumeDownloadWithDownloadTaskInfo:downloadTaskInfo];
        }
        
    }
}

- (void)saveDownloadCache{
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

@end
