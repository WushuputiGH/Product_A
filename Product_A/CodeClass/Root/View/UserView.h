//
//  UserView.h
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "RadioDownloadTableViewController.h"
#import "MyFileTableViewController.h"

@interface UserView : UIView
@property (strong, nonatomic) IBOutlet UIStackView *chooseStackView;

@property (strong, nonatomic) IBOutlet UIButton *userimg;
@property (strong, nonatomic) IBOutlet UIButton *loginOrRigister;
- (IBAction)userimg:(UIButton *)sender;
- (IBAction)loginOrRigister:(UIButton *)sender;

// 定义属性, 用于判断下载列表是否显示
@property (nonatomic, strong, readwrite) RadioDownloadTableViewController *radioDownloadTabelView;
@property (nonatomic, assign, readwrite) BOOL isAppear;

@property (nonatomic, strong, readwrite)UIViewController  *rootView;

// 定于属性, 用户本地文件是否显示
@property (nonatomic, strong, readwrite)MyFileTableViewController *myFileTableVC;
@property (nonatomic, assign, readwrite) BOOL isAppearMyFile;

@end
