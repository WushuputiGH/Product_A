//
//  RegistViewController.m
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RegistViewController.h"
#import "UserInfoManager.h"

@interface RegistViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign)NSInteger gender;
@property (nonatomic, strong)UIImage *uploadImage;

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
    
    // 默认只打开相册
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
        imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePick.delegate = self;
        imagePick.allowsEditing = YES;
        [self presentViewController:imagePick animated:YES completion:nil];
    }else{
        
    }
    
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
    
    /**
     *  如果请求出现content-type相关错误, 用一下两种方案解决
        应该使用一切出现content-type相关错误的案例, 但请求成功后返回的值被转换成NSData, 可读性不强
      manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        setWithObject: 接具体出现的content-type类型错误, 返回信息更全面
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/x-javascript"];
     */

    
   /*
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
    
    */
    
    
    [manager POST:kRegistUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImagePNGRepresentation(self.uploadImage) name:@"iconfile" fileName:@"uploadheadimage.png" mimeType:@"image/png"];
//        [formData appendPartWithFileData:UIImagePNGRepresentation([UIImage imageNamed:@"1.jpg"]) name:@"iconfile" fileName:@"uploadheadimage.png" mimeType:@"image/png"];
        [formData appendPartWithFormData:[_emailTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"email"];
        [formData appendPartWithFormData:[_passwordTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"passwd"];
        [formData appendPartWithFormData:[_nameTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"uname"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%ld", _gender] dataUsingEncoding:NSUTF8StringEncoding] name:@"gender"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
//        NSLog(@"%@", dic);
        if ([dic[@"result"] integerValue] == 0) {
            NSLog(@"%@", dic[@"data"][@"msg"]);
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
}

#pragma mark ----图片获取方法----
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // 获取边界后图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.uploadImage = image;
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self.userimgButton setImage:image forState:(UIControlStateNormal)];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end












