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
#import "MyFileTableViewController.h"


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
//        NSLog(@"dddd");
        // 获取名称
        [_loginOrRigister setTitle:[UserInfoManager getUserName] forState:(UIControlStateNormal)];
        // 获取图片
        NSString *imageString = [UserInfoManager getUserIcon];
        [_userimg setTitle:nil forState:(UIControlStateNormal)];
        [_userimg setImage:nil forState:(UIControlStateNormal)];
        [_userimg sd_setBackgroundImageWithURL:[NSURL URLWithString:imageString]  forState:(UIControlStateNormal)];
        
    
    };
    [self.rootView presentViewController:navigationVC animated:YES completion:nil];
    
}
- (IBAction)downloadButton:(UIButton *)sender {
    if (_isAppear == NO) {
        _isAppear = YES;
        if (_isAppearMyFile) {
            _isAppearMyFile = NO;
            [self hideMyfileNOAnimation];
        }
        
        [self showDownload];
    }else{
        _isAppear = NO;
        [self hideDownLoad];
    }

}

- (IBAction)myFile:(UIButton *)sender {
    
    if (_isAppearMyFile == NO) {
        _isAppearMyFile = YES;
        if (_isAppear) {
            _isAppear = NO;
            [self hideDownLoadNoAnimation];
        }
        [self showMyFile];
        
    }else{
        _isAppearMyFile = NO;
        [self hideMyfile];
    }
        
}

- (void)showMyFile{
    self.myFileTableVC = [[MyFileTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    // 设置tabelView的约束
    [self.rootView.view insertSubview:_myFileTableVC.view aboveSubview:self];
    [self.rootView addChildViewController:_myFileTableVC];
    [_myFileTableVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chooseStackView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(self.mas_width);
        make.bottom.equalTo(self.chooseStackView.mas_bottom);
        
    }];
    [self.rootView.view  layoutIfNeeded];
    
    // 获取stackView的frame
    [UIView animateWithDuration:0.5 animations:^{
        [_myFileTableVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chooseStackView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.bottom.equalTo(self.rootView.view.mas_bottom).offset(-64);
        }];
        [self.rootView.view  layoutIfNeeded];
    }];

    
}

- (void)hideMyfile{
    [UIView animateWithDuration:0.5 animations:^{
        [_myFileTableVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chooseStackView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.bottom.equalTo(self.chooseStackView.mas_bottom);
        }];
        [self.rootView.view  layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.myFileTableVC.view removeFromSuperview];
        [self.myFileTableVC removeFromParentViewController];
    }];
}


- (void)hideMyfileNOAnimation{
   
        [_myFileTableVC.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chooseStackView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.bottom.equalTo(self.chooseStackView.mas_bottom);
        }];
        [self.rootView.view  layoutIfNeeded];
   
        [self.myFileTableVC.view removeFromSuperview];
        [self.myFileTableVC removeFromParentViewController];
   
}


- (void)showDownload{
    self.radioDownloadTabelView = [[RadioDownloadTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    // 设置tabelView的约束
    
    // root的rightview的tag值是800;
    //        UIView *rightView = [self.rootView.view viewWithTag:800];
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

    
}

-(void)hideDownLoad{
    
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



-(void)hideDownLoadNoAnimation{
    
    
        [_radioDownloadTabelView.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.chooseStackView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.width.equalTo(self.mas_width);
            make.bottom.equalTo(self.chooseStackView.mas_bottom);
        }];
        [self.rootView.view  layoutIfNeeded];
  
        [self.radioDownloadTabelView.view removeFromSuperview];
        [self.radioDownloadTabelView removeFromParentViewController];

    
}

@end
