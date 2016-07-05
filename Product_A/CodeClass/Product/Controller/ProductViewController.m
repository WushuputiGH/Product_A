//
//  ProductViewController.m
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ProductViewController.h"
#import "ProductModel.h"
#import "ProductTableViewCell.h"
@interface ProductViewController () <UITableViewDataSource , UITableViewDelegate>

@property (nonatomic, strong)UITableView *theProductTableView;
@property (nonatomic, strong)ProductModel *productModel;


@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.theProductTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:(UITableViewStylePlain)];
    self.theProductTableView.dataSource = self;
    self.theProductTableView.delegate =self;
    self.theProductTableView.estimatedRowHeight = 44;
    [self.view addSubview:self.theProductTableView];
    self.theProductTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(netRequestMore)];
    
    // 注册cell
    [_theProductTableView registerNib:[UINib nibWithNibName:@"ProductTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"productTableViewCell"];
    self.productModel = [ProductModel productShare];
    
    [self netRequest];
    
    
    
}


#pragma mark ---- 网络请求 -----

- (void)netRequest{
    
    AFHTTPSessionManager *netManager = [AFHTTPSessionManager manager];
    netManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 参数列表
    NSDictionary *parDic = [kProductParDic mutableCopy];
    [parDic setValue:[UserInfoManager getUserAuth] forKey:@"auth"];
    
    [netManager POST:kProductUrl parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *newData = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        self.productModel.productInfo = newData;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.theProductTableView reloadData];
        });
        
    } failure:nil];
}



#pragma mark ---请求更多数据---
- (void)netRequestMore{
    AFHTTPSessionManager *netManager = [AFHTTPSessionManager manager];
    netManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSArray *listArray =  [self.productModel.productInfo valueForKeyPath:@"data.list"];
    // 参数列表
    NSDictionary *parDic = [kProductParDic mutableCopy];
    [parDic setValue:[UserInfoManager getUserAuth] forKey:@"auth"];
    [parDic setValue:@(listArray.count) forKey:@"start"];
    
    [netManager POST:kProductUrl parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *newData = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        
        NSArray *newListArray = [listArray arrayByAddingObjectsFromArray:[newData valueForKeyPath:@"data.list"]];
        
        [self.productModel.productInfo setValue:newListArray forKeyPath:@"data.list"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.theProductTableView reloadData];
            [self.theProductTableView.mj_footer endRefreshing];
        });
        
    } failure:nil];

    
}


#pragma mark ---tableview的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *listArray =  [self.productModel.productInfo valueForKeyPath:@"data.list"];
    return listArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ProductTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"productTableViewCell" forIndexPath:indexPath];
    // 获取对应的产品信息
    NSArray *listArray =  [self.productModel.productInfo valueForKeyPath:@"data.list"];
    NSDictionary *productInfo = listArray[indexPath.row];
    [cell cellConfigure:productInfo];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 点击时候, 跳转到购买界面
    // 获取对应的产品信息
    NSArray *listArray =  [self.productModel.productInfo valueForKeyPath:@"data.list"];
    NSDictionary *productInfo = listArray[indexPath.row];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:productInfo[@"buyurl"]]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
