//
//  ColumnsDetailViewController.m
//  Product_A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ColumnsDetailViewController.h"
#import "ColumnsDetailModel.h"
#import "ColumnsDetailTableViewCell.h"
#import "ArticleInfoViewController.h"

typedef NS_ENUM(NSInteger, NETREQUESTTYPE) {
    NETREQUESTTYPENEW,
    NETREQUESTTYPEMORE
};

@interface ColumnsDetailViewController ()<UITableViewDataSource, UITableViewDelegate>



@property(nonatomic, strong)UIButton *theNewButton;
@property(nonatomic, strong)UIButton *theHotButton;
@property(nonatomic, strong)UIView *indicatorView;


@property(nonatomic, assign)NETREQUESTTYPE netRequestType;
@property(nonatomic, assign)BOOL isHot;

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)UITableView *theHotTableView;
@property (nonatomic, strong)ColumnsDetailModel *columnsDetail;
@property (nonatomic, strong)ColumnsDetailModel *columnsHotDetail;


@end

@implementation ColumnsDetailViewController


- (UITableView *)getNewOrHotTableView{
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64) style:(UITableViewStylePlain)];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [tableView registerClass:[ColumnsDetailTableViewCell class] forCellReuseIdentifier:@"cellReuse"];
    [self.view addSubview:tableView];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(64);
    }];
    tableView.rowHeight = 170;
    return tableView;
}

- (void)configureNetOrHotButton:(UIButton *)button{
    button.tintColor = [UIColor whiteColor];
    button.titleLabel.font = [UIFont systemFontOfSize:9 weight:1.5];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    [button addTarget:self action:@selector(newOrHot:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
}


-(void)setIsHot:(BOOL)isHot{
    if (isHot) {
        self.theHotTableView.hidden = NO;
        self.tableView.hidden = YES;
    }else{
        self.theHotTableView.hidden = YES;
        self.tableView.hidden = NO;
    }
    _isHot = isHot;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.columnsDetail = [[ColumnsDetailModel alloc] init];
    self.columnsHotDetail = [[ColumnsDetailModel alloc] init];
        [self netRequest];
    // 初始化两个tableView
    self.tableView = [self getNewOrHotTableView];
    self.theHotTableView = [self getNewOrHotTableView];
    self.theHotTableView.hidden = YES;
    
    
 
    // 重新定义button按钮(即返回按钮)
    [self.button setTitle:@"" forState:(UIControlStateNormal)];
    UIImage *buttomImage = [UIImage imageNamed:@"u9_start.png"];
    self.button.tintColor = [UIColor darkGrayColor];
    [self.button setImage:buttomImage forState:(UIControlStateNormal)];
    
    // 定义newButton, 与hotButton
    self.theNewButton = [[UIButton alloc] initWithFrame:CGRectMake(200, 30, 24, 24)];
    [self.theNewButton setTitle:@"NEW" forState:(UIControlStateNormal)];
    self.theNewButton.backgroundColor = [UIColor darkGrayColor];
    [self configureNetOrHotButton:_theNewButton];


    self.theHotButton = [[UIButton alloc] initWithFrame:CGRectMake(300, 30, 24, 24)];
    [self.theHotButton setTitle:@"Hot" forState:(UIControlStateNormal)];
    self.theHotButton.backgroundColor = [UIColor lightGrayColor];
    [self configureNetOrHotButton:_theHotButton];
    
    // 添加new或者hot下标指示器
    self.indicatorView = [[UIView alloc] initWithFrame:CGRectMake(200, 62, 24, 1)];
    self.indicatorView.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.indicatorView];
    
    
    // 添加下来刷新,以及上拉更多加载数据
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.netRequestType = NETREQUESTTYPENEW;
        [self netRequest];
    }];

    
     self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
         self.netRequestType = NETREQUESTTYPEMORE;
         [self netRequest];
     }];
    self.theHotTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.netRequestType = NETREQUESTTYPENEW;
        [self netRequest];
    }];
    
    
    self.theHotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.netRequestType = NETREQUESTTYPEMORE;
        [self netRequest];
    }];
}


#pragma mark ---更改new或者hot选项---
- (void)newOrHot:(UIButton*)button{
    self.netRequestType = NETREQUESTTYPENEW;
    if (button == self.theNewButton) {
        
        button.backgroundColor = [UIColor darkGrayColor];
        [UIView animateWithDuration:0.5 animations:^{
            self.indicatorView.frame = CGRectMake(200, 62, 24, 1);
        }];
        self.theHotButton.backgroundColor = [UIColor lightGrayColor];
        
        // 设置isHot为0, 重新请求数据
        self.isHot = 0;
        [self netRequest];
    }
    if (button == self.theHotButton) {
        button.backgroundColor = [UIColor darkGrayColor];
        [UIView animateWithDuration:0.3 animations:^{
            self.indicatorView.frame = CGRectMake(300, 62, 24, 1);
        }];
        self.theNewButton.backgroundColor = [UIColor lightGrayColor];
        
        // 设置isHot为1, 重新请求数据
        self.isHot = 1;
        [self netRequest];
        
    }

    
}



#pragma mark---数据请求-----
// 数据请求
- (void)netRequest{
    AFHTTPSessionManager *afHttpSessionManager = [AFHTTPSessionManager manager];
    afHttpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSMutableArray *parDic = [kColumnsDetailDic mutableCopy];
    [parDic setValue:self.typeId forKey:@"typeid"];
    
    if (self.isHot == 1) {
        [parDic setValue:@"hot" forKey:@"sort"];
        if (self.netRequestType == NETREQUESTTYPEMORE){
            NSString *start = [NSString stringWithFormat:@"%ld", self.columnsHotDetail.columnsDetailItemArray.count];
              [parDic setValue:start forKey:@"start"];
        }
    }else{
        [parDic setValue:@"addtime" forKey:@"sort"];
        if (self.netRequestType == NETREQUESTTYPEMORE){
            NSString *start = [NSString stringWithFormat:@"%ld", self.columnsDetail.columnsDetailItemArray.count];
            [parDic setValue:start forKey:@"start"];
        }
    }
    
    
    [afHttpSessionManager POST:kColumnsDetailURL parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            ColumnsDetailModel *newColumnsDetail = [[ColumnsDetailModel alloc] init];
            [newColumnsDetail columnsDetailModelConfigureWithJsonDic:dic];
            
            // 首先获取所有的已经存在的ID
            NSMutableArray *theIdArray = [NSMutableArray array];
            if (self.isHot) {
                for (ColumnsDetailItem *item in self.columnsHotDetail.columnsDetailItemArray) {
                    [theIdArray addObject:item.theId];
                }
            }else{
               
                for (ColumnsDetailItem *item in self.columnsDetail.columnsDetailItemArray) {
                    [theIdArray addObject:item.theId];
                }
            }
            
            // 判断是否已经存在, 如果存在, 就删除
            for (int i = 0; i < newColumnsDetail.columnsDetailItemArray.count;) {
                if ([theIdArray containsObject:newColumnsDetail.columnsDetailItemArray[i].theId]) {
                    [newColumnsDetail.columnsDetailItemArray removeObjectAtIndex:i];
                }else{
                    i ++;
                }
            }

            
            if (self.netRequestType == NETREQUESTTYPENEW && (newColumnsDetail.result.integerValue == 1)) {
                
                if (self.isHot == 1) {
                    [newColumnsDetail.columnsDetailItemArray addObjectsFromArray:self.columnsHotDetail.columnsDetailItemArray];
                   self.columnsHotDetail = newColumnsDetail;
                    [self.theHotTableView.mj_header endRefreshing];
                }
                else{
                    
                    [newColumnsDetail.columnsDetailItemArray addObjectsFromArray:self.columnsDetail.columnsDetailItemArray];
                    self.columnsDetail = newColumnsDetail;
                    [self.tableView.mj_header endRefreshing];
                }
    
                
            }
            
            if (self.netRequestType == NETREQUESTTYPEMORE && (newColumnsDetail.result.integerValue == 1)) {
                if (self.isHot == 1) {
                    [self.columnsHotDetail.columnsDetailItemArray addObjectsFromArray:newColumnsDetail.columnsDetailItemArray];
                    [self.theHotTableView.mj_footer endRefreshing];
                }
                else{
                    [self.columnsDetail.columnsDetailItemArray addObjectsFromArray:newColumnsDetail.columnsDetailItemArray];
                    [self.tableView.mj_footer endRefreshing];
                }
                
            }
            
            [self.tableView reloadData];
            [self.theHotTableView reloadData];
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}


#pragma mark --- 配置tabelView----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.theHotTableView) {
        return self.columnsHotDetail.columnsDetailItemArray.count;
    }
    return self.columnsDetail.columnsDetailItemArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ColumnsDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellReuse" forIndexPath:indexPath];
    ColumnsDetailItem *item = nil;
    if (tableView == self.theHotTableView) {
        item = self.columnsHotDetail.columnsDetailItemArray[indexPath.row];
    }else{
       item = self.columnsDetail.columnsDetailItemArray[indexPath.row];
    }
    
    [cell cellConfigureWith:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ArticleInfoViewController *articleInfoVC = [[ArticleInfoViewController alloc] init];
    
    if (tableView == self.theHotTableView) {
        articleInfoVC.contentId = self.columnsHotDetail.columnsDetailItemArray[indexPath.row].theId;
    }else{
        articleInfoVC.contentId = self.columnsDetail.columnsDetailItemArray[indexPath.row].theId;
    }
    [self.navigationController pushViewController:articleInfoVC animated:YES];
    
    
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
