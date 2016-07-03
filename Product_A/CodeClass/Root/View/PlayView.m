//
//  PlayView.m
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import "PlayView.h"
#import "MyPlayerManager.h"
#import "PlayContainerViewController.h"

@interface PlayView ()
@property (nonatomic, strong)PlayContainerViewController *playContainerVC;

@end

@implementation PlayView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)playButton:(UIButton *)sender {
    
    
    if (self.radioData) {
        // 获取当前播放器的播放状态, 如果是停止, 那么就播放, 否则就暂停
        if ([MyPlayerManager defaultManager].playState == Play) {
            [[MyPlayerManager defaultManager] pause];
        }else{
            [[MyPlayerManager defaultManager] play];
        }
    }else{
        // 如果没有歌曲, 那么就弹出提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有歌曲" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        if (_rootVC) {
            [self.rootVC presentViewController:alertController animated:NO completion:^{
                // 弹出之后, 自动消失
                [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(alertDismiss:) userInfo:@{@"alert": alertController}repeats:NO];
            }];
        }
    }
}

- (IBAction)tapAction:(UITapGestureRecognizer *)sender {
    
    
    if (!_playContainerVC) {
        _playContainerVC = [[PlayContainerViewController alloc] init];
    }
    
    if (self.radioData) {
        // 如果有歌曲, 就弹出播放列表
        // 获取当前的index
        NSInteger index = [MyPlayerManager defaultManager].index;
        _playContainerVC.index = index;
        _playContainerVC.musicList = [[self.radioData valueForKeyPath:@"list"] mutableCopy];
        _playContainerVC.name = [self.radioData valueForKeyPath:@"radioInfo.userinfo.uname"];
        
        if (_rootVC) {
            [_rootVC presentViewController:_playContainerVC animated:YES completion:nil];
           
        }
    }else{
        // 如果没有歌曲, 那么就弹出提示
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"没有歌曲" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        if (_rootVC) {
            [self.rootVC presentViewController:alertController animated:NO completion:^{
                // 弹出之后, 自动消失
                [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(alertDismiss:) userInfo:@{@"alert": alertController}repeats:NO];
            }];
        }
    }
}


- (void)alertDismiss:(NSTimer *)timer{
    [timer.userInfo[@"alert"] dismissViewControllerAnimated:NO completion:nil];
    
}
@end







