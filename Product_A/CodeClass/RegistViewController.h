//
//  RegistViewController.h
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRegistUrl @"http://api2.pianke.me/user/reg"   //注册接口的地址
@interface RegistViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *userimgButton;

- (IBAction)back:(UIButton *)sender;
- (IBAction)userimg:(UIButton *)sender;
- (IBAction)man:(UIButton *)sender;

- (IBAction)female:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIButton *manBurron;

@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UIButton *femaleButton;

@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
- (IBAction)regist:(UIButton *)sender;

@end
