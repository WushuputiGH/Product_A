//
//  LoginViewController.h
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kLoginUrl  @"http://api2.pianke.me/user/login"
//登录接口的地址




@interface LoginViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (nonatomic, copy) void (^loginSucess)();

- (IBAction)clickBack:(UIButton *)sender;
- (IBAction)regist:(UIButton *)sender;
- (IBAction)login:(UIButton *)sender;

@end
