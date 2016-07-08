//
//  ReadViewController.m
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ReadViewController.h"
#import "ReadModel.h"
#import "ReadCollectionViewCell.h"
#import "ArticleInfoViewController.h"



@interface ReadViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong)CarouselView *carouselView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)ReadModel *readModel;

@end

@implementation ReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.carouselView = [[CarouselView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenWidth * (300.0 / 640))];
    [self.view addSubview:self.carouselView];
    
    // 设置轮播图的点击代理
    __weak ReadViewController *weakSelf = self;
    self.carouselView.imageClick = ^(NSInteger index) {
      // 点击执行跳转方法
        [weakSelf pushArticalInfoWith:index];
    };
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumInteritemSpacing = 5;
    flowLayout.minimumLineSpacing = 5;
    CGFloat itemWidth = (kScreenWidth - 20 - flowLayout.minimumInteritemSpacing * 2) / 3.0;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 + kScreenWidth * (300.0 / 640), kScreenWidth, kScreenHeight - (64 + kScreenWidth * (300.0 / 640))) collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self.collectionView registerClass:[ReadCollectionViewCell class] forCellWithReuseIdentifier:@"readCell"];
    
    [self.view addSubview:self.collectionView];
    
    [self netRequest];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}


#pragma mark ---属性---

- (ReadModel*)readModel {
    if (!_readModel) {
        _readModel = [[ReadModel alloc] init];
    }
    return _readModel;
}

#pragma mark ---网络请求与数据解析----

- (void)netRequest {
   
    AFHTTPSessionManager *afHttpSessionManager = [AFHTTPSessionManager manager];
    afHttpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [afHttpSessionManager GET:KReadURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
             NSDictionary *sourceDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            [self.readModel readModelConfigureWithJsonDict:sourceDic];
            [self.carouselView carouselCongigureWithImageURLs:self.readModel.carouselArray];
            [self.collectionView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark ---collectionView的代理方法----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)sectio{
    return self.readModel.readItemArray.count;
    
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ReadCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"readCell" forIndexPath:indexPath];
    [cell readCollectionViewCellConfigureWith:self.readModel.readItemArray[indexPath.item]];
    return cell;
}
// 点击item进行列表详情的跳转

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    // 首先获取对应的model中对应的type
    ReadItem *item = self.readModel.readItemArray[indexPath.item];
    // 创建一个列表详情页面
    ColumnsDetailViewController *columnsDetailVC = [[ColumnsDetailViewController alloc] init];
    columnsDetailVC.typeId = item.type;
    columnsDetailVC.titleLabel.text = item.name;
    [self.navigationController pushViewController:columnsDetailVC animated:YES];
    

}

# pragma mark ---点击轮播图----

- (void)pushArticalInfoWith:(NSInteger)index{
    ArticleInfoViewController *articleInfoVC = [[ArticleInfoViewController alloc] init];
    articleInfoVC.contentId = self.readModel.carouselIDArray[index];
    [self.navigationController pushViewController:articleInfoVC animated:YES];
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
