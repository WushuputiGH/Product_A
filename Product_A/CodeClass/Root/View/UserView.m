//
//  UserView.m
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import "UserView.h"
#import "LoginViewController.h"
#import "UserInfoManager.h"
#import "UIButton+WebCache.h"


@implementation UserView



- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (IBAction)userimg:(UIButton *)sender {
}

- (IBAction)loginOrRigister:(UIButton *)sender {
    
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:loginViewController];
    loginViewController.loginSucess = ^(){
        NSLog(@"dddd");
        // 获取名称
        [_loginOrRigister setTitle:[UserInfoManager getUserName] forState:(UIControlStateNormal)];
        // 获取图片
        NSString *imageString = [UserInfoManager getUserIcon];
        [_userimg setTitle:nil forState:(UIControlStateNormal)];
        [_userimg sd_setBackgroundImageWithURL:[NSURL URLWithString:imageString]  forState:(UIControlStateNormal)];
        
    
    };
    [self.rootView presentViewController:navigationVC animated:YES completion:nil];
    
}
- (IBAction)downloadButton:(UIButton *)sender {
    if (_isAppear == NO) {
        _isAppear = YES;
        
        self.radioDownloadTabelView = [[RadioDownloadTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
        // 设置tabelView的约束
        [self.rootView.view insertSubview:_radioDownloadTabelView.view aboveSubview:self];
        [self.rootView addChildViewController:_radioDownloadTabelView];
        [_radioDownloadTabelView.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chooseStackView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.bottom.equalTo(self.chooseStackView.mas_bottom);
            
        }];
        [self.rootView.view  layoutIfNeeded];
        
        // 获取stackView的frame
        [UIView animateWithDuration:0.5 animations:^{
            [_radioDownloadTabelView.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.chooseStackView.mas_bottom);
                make.left.equalTo(self.mas_left);
                make.width.equalTo(self.mas_width);
                make.bottom.equalTo(self.rootView.view.mas_bottom).offset(-64);
            }];
            [self.rootView.view  layoutIfNeeded];
        }];

    }else{
        _isAppear = NO;
        [UIView animateWithDuration:0.5 animations:^{
            [_radioDownloadTabelView.view mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.chooseStackView.mas_bottom);
                make.left.equalTo(self.mas_left);
                make.width.equalTo(self.mas_width);
                make.bottom.equalTo(self.chooseStackView.mas_bottom);
            }];
            [self.rootView.view  layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self.radioDownloadTabelView.view removeFromSuperview];
            [self.radioDownloadTabelView removeFromParentViewController];
        }];
    }


}


@end
