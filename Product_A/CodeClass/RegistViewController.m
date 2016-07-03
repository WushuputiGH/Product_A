//
//  RegistViewController.m
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RegistViewController.h"
#import "UserInfoManager.h"

@interface RegistViewController ()

@property (nonatomic, assign)NSInteger gender;

@end

@implementation RegistViewController



- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)userimg:(UIButton *)sender {
}

- (IBAction)man:(UIButton *)sender {
    _gender = 0;
    sender.backgroundColor = [UIColor grayColor];
    self.femaleButton.backgroundColor = [UIColor whiteColor];
}

- (IBAction)female:(UIButton *)sender {
    _gender = 1;
    sender.backgroundColor = [UIColor grayColor];
    self.manBurron.backgroundColor = [UIColor whiteColor];
}
- (IBAction)regist:(UIButton *)sender {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    
    NSDictionary *parDic = @{@"email": self.emailTF.text, @"gender": @(_gender), @"passwd": self.passwordTF.text, @"uname": [self.nameTF.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]};
    
    
    [manager POST:kRegistUrl parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        // NSLog(@"%@", dic);
        if ([dic[@"result"] integerValue] == 0) {
            NSLog(@"%@", dic[@"data"][@"msg"]);
        }else{
            [UserInfoManager conserveUserAuth:dic[@"data"][@"auth"]];
            [UserInfoManager conserveUserIcon:dic[@"data"][@"icon"]];
            [UserInfoManager conserveUserName:dic[@"data"][@"uname"]];
            [UserInfoManager conserveUserID:dic[@"data"][@"uid"]];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"参数错误");
    }];
    
}
@end











