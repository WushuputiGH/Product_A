//
//  RegistView.h
//  Product_A
//
//  Created by lanou on 16/7/7.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kRegistUrl @"http://api2.pianke.me/user/reg"   //注册接口的地址
@interface RegistView : UIView <UINavigationControllerDelegate, UIImagePickerControllerDelegate>



@property (strong, nonatomic) IBOutlet UIButton *userimgButton;


@property (strong, nonatomic) IBOutlet UIButton *manBurron;


@property (strong, nonatomic) IBOutlet UITextField *nameTF;
@property (strong, nonatomic) IBOutlet UITextField *emailTF;
@property (strong, nonatomic) IBOutlet UIButton *femaleButton;

@property (strong, nonatomic) IBOutlet UITextField *passwordTF;
@property (strong, nonatomic) IBOutlet UIButton *regist;




@end
