//
//  ShareViewController.m
//  Product_A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ShareViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.shareButton setImage:[UIImage imageNamed:@"wizard_48px"] forState:(UIControlStateNormal)];
     [self.view addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.shareButton addTarget:self action:@selector(createShareSDK) forControlEvents:(UIControlEventTouchUpInside)];
    
}

- (instancetype)initWithShareTitle:(NSString *)shareTitle shareContent: (NSString *)shareContent shareUrl:(NSString *)shareUrl shareImage:(UIImage *)shareImage{
    self = [super init];
    if (self) {
        [self configureWithShareTitle:shareTitle shareContent:shareContent shareUrl:shareUrl shareImage:shareImage];
    }
    return self;
}



- (void)configureWithShareTitle:(NSString *)shareTitle shareContent: (NSString *)shareContent shareUrl:(NSString *)shareUrl shareImage:(UIImage *)shareImage{
    
    self.shareTitle = shareTitle;
    self.shareContent = shareContent;
    self.shareImage = shareImage;
    self.shareUrl = shareUrl;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark ---- 创建分享 ------

- (void)createShareSDK{
    
 
    
    if (self.shareImage == nil) {
        return;
    }
    //1、创建分享参数
    NSArray* imageArray = @[self.shareImage];
    if (imageArray) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:self.shareContent
                                         images:imageArray
                                            url:[NSURL URLWithString:self.shareUrl]
                                          title:self.shareTitle
                                           type:SSDKContentTypeAuto];
        
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
