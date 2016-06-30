//
//  RightViewController.h
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, MOVETYPE) {
    MOVETYPELEFT,
    MOVETYPERIGHT
};

@interface RightViewController : UIViewController
@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong, readwrite) UILabel *titleLabel;


- (void)changeFrameWithType:(MOVETYPE)moveType;

- (void)buttonAction:(UIButton *)button;

@end
