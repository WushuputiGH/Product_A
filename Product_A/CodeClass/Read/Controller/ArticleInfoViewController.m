//
//  ArticleInfoViewController.m
//  Product_A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ArticleInfoViewController.h"
#import "ArticleInfoModel.h"
#import "NSString+Html.h"

@interface ArticleInfoViewController ()

@property (nonatomic, strong)UIButton *commentButton;
@property (nonatomic, strong)UIButton *likeButton;
@property (nonatomic, strong)UIWebView *theWebView;
@property (nonatomic, strong)ArticleInfoModel *model;

@end

@implementation ArticleInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.model = [[ArticleInfoModel alloc] init];
    self.theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview: self.theWebView];
    [self netRequest];
    
    
    // 设置评论数, 以及喜欢的人数按钮
    // 获取图片路径
    self.commentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.commentButton.frame = CGRectMake(100, 30, 100, 30);
    NSString *commentButtonImagePath = [[NSBundle mainBundle] pathForResource:@"u40.png" ofType:nil];
    UIImage *image = [[UIImage imageWithContentsOfFile:commentButtonImagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.commentButton setImage:image forState:(UIControlStateNormal)];
    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.commentButton.tintColor = [UIColor darkGrayColor];
    [self.commentButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:self.commentButton];
    
   
    self.likeButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.likeButton.frame = CGRectMake(210, 30, 100, 30);
    NSString *likeButtonImagePath = [[NSBundle mainBundle] pathForResource:@"u72.png" ofType:nil];
    UIImage *image2 = [[UIImage imageWithContentsOfFile:likeButtonImagePath] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.likeButton setImage:image2 forState:(UIControlStateNormal)];
    self.likeButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    self.likeButton.tintColor = [UIColor darkGrayColor];
    [self.likeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.view addSubview:self.likeButton];
    
    
    // 重新定义button按钮(即返回按钮)
    [self.button setTitle:@"" forState:(UIControlStateNormal)];
    UIImage *buttomImage = [UIImage imageNamed:@"u9_start.png"];
    self.button.tintColor = [UIColor darkGrayColor];
    [self.button setImage:buttomImage forState:(UIControlStateNormal)];
    
    
}

// 重写button的点击方法
- (void)buttonAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)netRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableDictionary *parDic = [kArticleInfoDic mutableCopy];
    [parDic setValue:self.contentId forKey:@"contentid"];
    
    [manager POST:kArticleInfoURL parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        [self.model setValuesForKeysWithDictionary:dic];
    
        // 获取文章信息
        NSString *htmlString = [[self.model valueForKey:@"data"] valueForKey:@"html"];
        NSString *html = [NSString importStyleWithHtmlString:htmlString];
        [self.theWebView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[NSBundle mainBundle].bundlePath]];
        
        // 获取喜欢与评论数
        NSDictionary *counterList = [[self.model valueForKey:@"data"] valueForKey:@"counterList"];
        NSNumber *commentNum = counterList[@"comment"];
        NSNumber *likeNum = counterList[@"like"];
        [self.commentButton setTitle:[NSString stringWithFormat:@"%@", commentNum] forState:UIControlStateNormal];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%@", likeNum] forState:UIControlStateNormal];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
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
