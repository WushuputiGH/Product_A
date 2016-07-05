//
//  PlayTitleView.m
//  Product_A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 H. All rights reserved.
//

#import "PlayTitleView.h"
#import "MyPlayerManager.h"

@implementation PlayTitleView



- (IBAction)changePlayType:(UIButton *)sender {
    
    //
    MyPlayerManager *manager = [MyPlayerManager defaultManager];
    
    switch (manager.playType) {
        case SignelPlay:
            manager.playType = ListPlay;
            break;
        case ListPlay:
            manager.playType = RandomPlay;
            break;
        case RandomPlay:
            manager.playType = SignelPlay;
            break;
        default:
            break;
    }
    [self changeAccrodingPlaytype];
    
    
}

- (IBAction)colloction:(UIButton *)sender {
}


- (void)changeAccrodingPlaytype{
    switch ([MyPlayerManager defaultManager].playType) {
        case SignelPlay:
            self.theLabel.text = @"1";
            [self.playTypeButton setImage:[UIImage imageNamed:@"rrow_Loop"] forState:(UIControlStateNormal)];
            break;
        case ListPlay:
            self.theLabel.text = @"";
            [self.playTypeButton setImage:[UIImage imageNamed:@"rrow_Loop"] forState:(UIControlStateNormal)];
            break;
        case RandomPlay:
            self.theLabel.text = @"";
            [self.playTypeButton setImage:[UIImage imageNamed:@"music_shuffle"] forState:(UIControlStateNormal)];
            break;
        default:
            break;
    }
}


@end
