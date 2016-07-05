//
//  ShareButton.m
//  Product_A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ShareButton.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@implementation ShareButton


- (void)configureWithShareTitle:(NSString *)shareTitle shareContent: (NSString *)shareContent shareUrl:(NSString *)shareUrl shareImage:(UIImage *)shareImage{
    [self addTarget:self action:@selector(createShareSDK) forControlEvents:(UIControlEventTouchUpInside)];
    self.shareTitle = shareTitle;
    self.shareContent = shareContent;
    self.shareImage = shareImage;
    self.shareUrl = shareUrl;
}

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

@end
