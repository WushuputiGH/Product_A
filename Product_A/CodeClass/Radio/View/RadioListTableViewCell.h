//
//  RadioListTableViewCell.h
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RadioListTableViewCell : UITableViewCell
@property (nonatomic, strong, readwrite) UIButton *downLoadload;
@property (nonatomic, assign) DownloadState downloadState;
@property (nonatomic, strong, readwrite) NSDictionary *musicInfo;


- (void)configureWithMusicInfoDic:(NSDictionary *)musicInfo;
- (void)changeDownloadButton:(NSDictionary *)musicInfo;

@end
