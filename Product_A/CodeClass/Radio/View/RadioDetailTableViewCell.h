//
//  RadioDetailTableViewCell.h
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface RadioDetailTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) UIImageView *theImageView;
@property (nonatomic, strong, readwrite) UILabel *theTitleLabel;
@property (nonatomic, strong, readwrite)UIImageView *voiceImageView;
@property (nonatomic, strong, readwrite)UILabel *musicVisitLabel;
@property (nonatomic, strong, readwrite) UIButton *playButton;

- (void)configureWithDic:(NSDictionary *)dic;

@end
