//
//  RadioDetailViewController.m
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RadioDetailViewController.h"
#import "UserInfonView.h"
#import "RadioDetailTableViewCell.h"
#import "PlayContainerViewController.h"

@interface RadioDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIScrollView *theScrollView;
@property (nonatomic, strong)UIImageView *theImageView;
@property (nonatomic, strong)UserInfonView *userInfoView;
@property (nonatomic, strong)UITableView *radioDetailTableView;

@property (nonatomic, strong)AFHTTPSessionManager *netManager;

@property (nonatomic, strong)NSMutableDictionary *radioDetailModel;

@property(nonatomic, strong)PlayContainerViewController *playContainerVC;

@end

@implementation RadioDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _netManager = [AFHTTPSessionManager manager];
    _netManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self initializeSubviews];
    [self netRequest];
    
    // 重新定义button按钮(即返回按钮)
    [self.button setTitle:@"" forState:(UIControlStateNormal)];
    UIImage *buttomImage = [UIImage imageNamed:@"u9_start.png"];
    self.button.tintColor = [UIColor darkGrayColor];
    [self.button setImage:buttomImage forState:(UIControlStateNormal)];
    
    
}

- (void)initializeSubviews{
    _theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64)];
    [self.view addSubview: _theScrollView];
    
    _theImageView = [[UIImageView alloc] init];
    _theImageView.backgroundColor = [UIColor orangeColor];
    [_theScrollView addSubview:_theImageView];
    
    _userInfoView = [[UserInfonView alloc] init];
    [_theScrollView addSubview:_userInfoView];
    
    _radioDetailTableView = [[UITableView alloc] init];
    _radioDetailTableView.dataSource = self;
    _radioDetailTableView.delegate = self;
    [_radioDetailTableView registerClass:[RadioDetailTableViewCell class] forCellReuseIdentifier:@"radioDetailCell"];
    [_theScrollView addSubview:_radioDetailTableView];

}


- (void)constraintSubViews{
    
    // 获取theImageView中Image的大小
    CGSize imageSize = _theImageView.image.size;
    [_theImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(_theScrollView);
        make.width.equalTo(_theScrollView.mas_width);
        make.height.equalTo(_theImageView.mas_width).multipliedBy(imageSize.height / imageSize.width);
    }];
    
    // 获取userInfoView的高度
    [_userInfoView setNeedsLayout];
    [_userInfoView layoutIfNeeded];
    CGFloat height = _userInfoView.descLabel.frame.origin.y + _userInfoView.descLabel.frame.size.height + 20;
    
    [_userInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_theImageView.mas_bottom);
        make.left.equalTo(_theScrollView);
        make.width.equalTo(_theScrollView);
        make.height.equalTo(@(height));
    }];
 
    // 获取userInfo的frame
    [_userInfoView setNeedsLayout];
    [_userInfoView layoutIfNeeded];
    CGRect userInfoViewRect = _userInfoView.frame;
    
    [_radioDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_userInfoView.mas_bottom);
        make.left.equalTo(_theScrollView.mas_left).offset(0);
        make.width.equalTo(_theScrollView.mas_width).offset(0);
        make.height.equalTo(@(kScreenHeight + userInfoViewRect.origin.y + userInfoViewRect.size.height - 64));
    }];
    
}


- (void)netRequest{
    NSMutableDictionary *parDic = [kRadioDetailDic mutableCopy];
    [parDic setValue:self.radioId forKey:@"radioid"];
    [_netManager POST:kRadioDetail parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *newDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            if (![newDic[@"result"] isEqualToNumber:@1]) {
                return ;
            }
            self.radioDetailModel = [newDic mutableCopy];
            [self constraintSubViews];           
            
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}


-(void)setRadioDetailModel:(NSMutableDictionary *)radioDetailModel{
    if (!_radioDetailModel) {
        _radioDetailModel = [NSMutableDictionary dictionary];
    }
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[radioDetailModel valueForKeyPath:@"data.radioInfo.coverimg"]]];
    UIImage *image = [UIImage imageWithData:imageData];
    _theImageView.image = image;
    
    [_userInfoView configureWithDic:radioDetailModel];
    
    _radioDetailModel = radioDetailModel;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array = [self.radioDetailModel valueForKeyPath:@"data.list"];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RadioDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"radioDetailCell" forIndexPath:indexPath];
    NSArray *array = [self.radioDetailModel valueForKeyPath:@"data.list"];
    [cell configureWithDic:array[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!_playContainerVC) {
        _playContainerVC = [[PlayContainerViewController alloc] init];
    }
    
    _playContainerVC.musicList = [[self.radioDetailModel valueForKeyPath:@"data.list"] mutableCopy];
    _playContainerVC.index = indexPath.row;
    [self.navigationController pushViewController:_playContainerVC animated:YES];

}



// 重写button的点击方法
- (void)buttonAction:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
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
