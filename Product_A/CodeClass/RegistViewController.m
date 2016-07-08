//
//  RegistViewController.m
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RegistViewController.h"
#import "UserInfoManager.h"

@interface RegistViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

@end

@implementation RegistViewController



- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//     Do any additional setup after loading the view from its nib.
//     监听键盘弹出, 消失信息
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kayBoardShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kayBoardHide:) name:UIKeyboardWillHideNotification object:nil];

//    self.theScrollerView.backgroundColor = [UIColor orangeColor];
//    self.theScrollerView.bounces = NO;
    self.theScrollerView.contentSize = CGSizeMake(kScreenWidth, 1.5 * kScreenHeight);
    self.theScrollerView.delegate = self;
    self.theScrollerView.showsHorizontalScrollIndicator = NO;
    self.theScrollerView.showsVerticalScrollIndicator = NO;
    self.registView = [[[NSBundle mainBundle] loadNibNamed:@"Regist" owner:nil options:nil] firstObject];
    self.registView.frame = CGRectMake(0, 0, kScreenWidth, 420);
    [self.theScrollerView addSubview:self.registView];
    [self.registView.userimgButton addTarget:self action:@selector(userimg:) forControlEvents:UIControlEventTouchUpInside];
    [self.registView.manBurron addTarget:self action:@selector(man:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.registView.femaleButton addTarget:self action:@selector(female:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.registView.regist addTarget:self action:@selector(regist:) forControlEvents:(UIControlEventTouchUpInside)];
    self.registView.passwordTF.secureTextEntry = YES;
    self.registView.emailTF.keyboardType = UIKeyboardTypeASCIICapable;
    self.registView.passwordTF.keyboardType = UIKeyboardTypeASCIICapable;
    
//    [self addObserver:self forKeyPath:@"registView.nameTF.text" options:(NSKeyValueObservingOptionNew) context:nil];
    
}


//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
//{
//    NSLog(@"%@", change);
//    
//    
//}

// 正则表达式用于判断是否是邮箱
//邮箱
- (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

// 通用提示框
- (void)alertViewController: (NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Do" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        
        
    }];
    [alert addAction:action];
    [self showDetailViewController:alert sender:nil];
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

- (void)userimg:(UIButton *)sender {
    
    
    UIAlertController *userImage = [UIAlertController alertControllerWithTitle:@"获取头像" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *camera = [UIAlertAction actionWithTitle:@"相机" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        // 默认只打开相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
            imagePick.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePick.delegate = self;
            imagePick.allowsEditing = YES;
            [userImage dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:imagePick animated:YES completion:nil];
        }else{
            
        }
        
    }];
    
    UIAlertAction *photos = [UIAlertAction actionWithTitle:@"相册" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
        // 默认只打开相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIImagePickerController *imagePick = [[UIImagePickerController alloc] init];
            imagePick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePick.delegate = self;
            imagePick.allowsEditing = YES;
            [userImage dismissViewControllerAnimated:YES completion:nil];
            [self presentViewController:imagePick animated:YES completion:nil];
        }else{
            
        }
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
        [userImage dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [userImage addAction:camera];
    [userImage addAction:photos];
    [userImage addAction:cancel];
    [self presentViewController:userImage animated:YES completion:nil];
    
    
    

    
}

- (void)man:(UIButton *)sender {
    _gender = 1;
    sender.titleLabel.font = [UIFont systemFontOfSize:22 weight:0.5];
//    [sender setTitleColor:[UIColor purpleColor]  forState:(UIControlStateNormal)];
//    [self.registView.femaleButton setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.registView.femaleButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:0.5];
}

- (void)female:(UIButton *)sender {
    _gender = 0;
//    sender.backgroundColor = [UIColor grayColor];
   
//    self.registView.manBurron.backgroundColor = [UIColor whiteColor];
//    [sender setTitleColor:[UIColor colorWithRed:255 green:255 blue:255 alpha:1]  forState:(UIControlStateNormal)];
    sender.titleLabel.font = [UIFont systemFontOfSize:22 weight:0.5];
//    [self.registView.manBurron setTitleColor:[UIColor blackColor] forState:(UIControlStateNormal)];
    self.registView.manBurron.titleLabel.font = [UIFont systemFontOfSize:17 weight:0.5];
    
}


// 判断字符串为空


- (BOOL)isAText: (NSString*)string{
    if (string || string.length == 0) {
        return NO;
    }
    return YES;
}


- (void)regist:(UIButton *)sender {
    
    if ( [self isAText:self.registView.emailTF.text] && [self isAText:self.registView.nameTF.text] && [self isAText:self.registView.passwordTF.text] ) {
        [self alertViewController:@"请提供完整信息"];
        return;
    }
    
    
    if(![self validateEmail:self.registView.emailTF.text]){
        
        [self alertViewController:@"邮箱格式不正确"];
        [self.registView.emailTF becomeFirstResponder];
        return;
    }
    
    
    
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
        [formData appendPartWithFileData:UIImagePNGRepresentation(self.uploadImage) name:@"iconfile" fileName:@"house2.png" mimeType:@"image/png"];
//        [formData appendPartWithFileData:UIImagePNGRepresentation([UIImage imageNamed:@"1.jpg"]) name:@"iconfile" fileName:@"uploadheadimage.png" mimeType:@"image/png"];
        [formData appendPartWithFormData:[self.registView.emailTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"email"];
        [formData appendPartWithFormData:[self.registView.passwordTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"passwd"];
        [formData appendPartWithFormData:[self.registView.nameTF.text dataUsingEncoding:NSUTF8StringEncoding] name:@"uname"];
        [formData appendPartWithFormData:[[NSString stringWithFormat:@"%ld", _gender] dataUsingEncoding:NSUTF8StringEncoding] name:@"gender"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%f", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
//        NSLog(@"%@", dic);
        if ([dic[@"result"] integerValue] == 0) {
            NSLog(@"%@", dic[@"data"][@"msg"]);
            [self alertViewController:dic[@"data"][@"msg"]];
        }else{
            if (self.registSuccessed) {
                self.registSuccessed(self.registView.emailTF.text);
            }
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
    [self.registView.userimgButton setImage:image forState:(UIControlStateNormal)];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
    
    if (scrollView.contentOffset.y > self.registView.frame.size.height / 2) {
        
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, self.registView.frame.size.height / 2);
    }
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end












