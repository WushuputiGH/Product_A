//
//  CommentContainerViewController.m
//  Product_A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import "CommentContainerViewController.h"
#import "CommentSendView.h"
#import "CommentTableViewController.h"


#pragma mark ---scrowview的延展 ---

@implementation UIScrollView (UITouchEvent)
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.nextResponder touchesBegan:touches withEvent:event];
}
@end


@interface CommentContainerViewController ()<UITextViewDelegate>


@property (nonatomic, strong)CommentSendView *commentSendView;

// 添加一个用于毛玻璃的视图
@property (nonatomic, strong)UIView *areoView;

@property (nonatomic, strong)CommentTableViewController *commentTableVC;

@end
@implementation CommentContainerViewController


-(UIView *)areoView{
    if (!_areoView) {
        
        _areoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _areoView.backgroundColor = [UIColor darkGrayColor];
        _areoView.alpha = 0.0;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        label.textColor = [UIColor darkTextColor];
        label.text = @"评论为空, 不能发送!";
        label.backgroundColor = [UIColor grayColor];
        label.center = _areoView.center;
        label.textAlignment = NSTextAlignmentCenter;
        label.layer.cornerRadius = 10;
        label.clipsToBounds = YES;
        
        [_areoView addSubview:label];
    }
    return _areoView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.translucent = YES;
    
    self.commentTableVC = [[CommentTableViewController alloc] init];
    self.commentTableVC.articleInfoModel = self.articleInfoModel;
    self.commentTableVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 44);
    [self.view addSubview:self.commentTableVC.view];
    [self addChildViewController:self.commentTableVC];
    
    self.commentSendView = [[[NSBundle mainBundle] loadNibNamed:@"CommentSendView" owner:nil options:nil]firstObject];
    self.commentSendView.frame = CGRectMake(0, kScreenHeight - 44, kScreenWidth, 44);
    [self.view addSubview:self.commentSendView];
    [self.commentSendView.sendButton addTarget:self action:@selector(sendComment:) forControlEvents:(UIControlEventTouchUpInside)];
    self.commentSendView.commentTextView.delegate = self;

    // 监听键盘弹出, 消失信息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kayBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kayBoardHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

#pragma mark  ---发送按钮-----
- (void)sendComment:(UIButton *)button{
    
    // 首先判断是否评论为空
    if (self.commentSendView.commentTextView.text == nil || self.commentSendView.commentTextView.text.length == 0) {
        // 首先取消第一响应者
        [self.view endEditing:YES];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"评论不能为空" message:@"请重新输入" preferredStyle: 1];
        [self presentViewController:alertController animated:YES completion:^{
            [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(alertDismiss:) userInfo:@{@"alert": alertController} repeats:NO];
        }];
  
 
    }
    else{
        // 评论不为空的时候, 上传评论
        [self upLoadComment];
    }
}


#pragma mark ---上传评论---

- (void)upLoadComment{
    // 首先获取用户信息, 如果没有用户信息,那么就弹出需要登录
    NSString *auth = [UserInfoManager getUserAuth];
    if (auth == nil ) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"用户未登录" message:@"请首先登录" preferredStyle: 1];
        [self presentViewController:alertController animated:YES completion:^{
            [NSTimer scheduledTimerWithTimeInterval:0.8f target:self selector:@selector(alertDismiss:) userInfo:@{@"alert": alertController} repeats:NO];
        }];
    }else {
        AFHTTPSessionManager *netManager = [AFHTTPSessionManager manager];
        netManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 定义post请求参数
        NSDictionary *parDic = @{@"auth":auth, @"client": @1, @"content": self.commentSendView.commentTextView.text, @"contentid": self.articleInfoModel.data[@"contentid"], @"deviceid": @"6D4DD967-5EB2-40E2-A202-37E64F3BEA31"};
        [netManager POST:kCommentUploadUrl parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([dic[@"result"] integerValue] == 1) {
                
                // 将textView中数据置为默认, 同时设置为占位
                self.commentSendView.commentTextView.text = @"你的评论会让作者更有动力!";
                self.commentSendView.isPlaceHorld = 1;
                // 当上传成功的时候, 取消第一响应者
                [self.commentSendView.commentTextView resignFirstResponder];
                // 刷新数据
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.commentTableVC netRequst];
                    
                });
            }
            
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        }];
    }
   
    
    
}



#pragma mark --- 弹出框消失 ----
- (void)alertDismiss:(NSTimer *)timer{
    [timer.userInfo[@"alert"] dismissViewControllerAnimated:NO completion:nil];
}


- (void)removeAreoView:(NSTimer *)timer{
    self.areoView.alpha = 0.0;
    [self.areoView removeFromSuperview];
}

#pragma mark --- 键盘弹出, 消失执行的方法 ----

- (void)kayBoardShow:(NSNotification *)notice{
    //UIKeyboardAnimationDurationUserInfoKey = "0.25"; 动画时间
    // UIKeyboardFrameEndUserInfoKey = "NSRect: {{0, 409}, {375, 258}}键盘出现后的位置
    
    CGRect newRect = [notice.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[notice.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        // 只会走一次
        self.commentSendView.transform = CGAffineTransformMakeTranslation(0, - newRect.size.height);
    }];
}


- (void)kayBoardHide:(NSNotification *)notice{
    [UIView animateWithDuration:[notice.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.commentSendView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
//        self.commentSendView.commentTextView.text = @"";
    }];
}

#pragma mark ---textView的代理---
/**
 *  类似于textfield点解return按钮时候执行的方法
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"%@", text);
    if ([text isEqualToString:@"\n"]) {
        // 上传
        [self sendComment:nil];
        return NO;
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.commentSendView.isPlaceHorld) {
        self.commentSendView.commentTextView.text = @"";
        self.commentSendView.isPlaceHorld = 0;
    }
    return YES;
}





-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    //用法: 消除该视图, 以及任意子视图的第一响应者
    [self.view endEditing:YES];
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

@end
