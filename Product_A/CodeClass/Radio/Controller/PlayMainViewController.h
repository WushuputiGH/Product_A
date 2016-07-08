//
//  PlayMainViewController.h
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyPlayerManager.h"
#import "DownLoadManager.h"

@interface PlayMainViewController : UIViewController


@property (nonatomic, strong, readwrite) NSMutableDictionary *musicInfo;

@property (nonatomic, strong, readwrite)UISlider *progressView;
@property (nonatomic, strong, readwrite)UILabel *totalTimeLabel;
@property (nonatomic, strong, readwrite)UIButton *commmentButton;


@end


