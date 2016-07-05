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
    
    [self configureShareSDK];
    

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


- (void)configureShareSDK{
    [ShareSDK registerApp:@"141654a2bbabe"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeMail),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),
                            @(SSDKPlatformTypeRenren),
                            @(SSDKPlatformTypeGooglePlus)]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                           appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                         redirectUri:@"http://www.sharesdk.cn"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx4e6eef44e99652a4"
                                       appSecret:@"2c356a7ded726eb36c94a527844a2a60"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"100371282"
                                      appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                    authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeRenren:
                 [appInfo        SSDKSetupRenRenByAppId:@"226427"
                                                 appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                                              secretKey:@"f29df781abdd4f49beca5a2194676ca4"
                                               authType:SSDKAuthTypeBoth];
                 break;
//             case SSDKPlatformTypeGooglePlus:
//                 [appInfo SSDKSetupGooglePlusByClientID:@"232554794995.apps.googleusercontent.com"
//                                           clientSecret:@"PEdFgtrMw97aCvf0joQj7EMk"
//                                            redirectUri:@"http://localhost"
//                                               authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    
    
    
}

@end
