//
//  PlayView.h
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PlayView : UIView
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userLabel;

@property (strong, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic, strong, readwrite) UIViewController *rootVC;
@property (nonatomic, strong, readwrite) NSMutableArray *radioData;

@property (nonatomic, assign, readwrite) BOOL isLoacation;

- (IBAction)playButton:(UIButton *)sender;


@end
