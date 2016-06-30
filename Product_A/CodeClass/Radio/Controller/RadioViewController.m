//
//  RadioViewController.m
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RadioViewController.h"
#import "CarouselView.h"
#import "HotListCollectionViewCell.h"
#import "AllListTableViewCell.h"
#import "RadioDetailViewController.h"

@interface RadioViewController () <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, strong)NSMutableDictionary *radioListModel;
@property(nonatomic, strong)NSMutableArray *carouselArray;
@property(nonatomic, strong)NSMutableArray *collectionViewModel;

// 整体的scrollerView
@property(nonatomic, strong)UIScrollView *scrollerView;
// 轮播图
@property(nonatomic, strong)CarouselView *carouselView;
// collectionView视图
@property (nonatomic, strong)UICollectionView *hotListView;
// tabelview视图
@property (nonatomic, strong)UITableView *allListTableView;

// 假装是分割线以及头标题的视图
@property (nonatomic, strong)UILabel *allListLabel;
@property (nonatomic, strong)UIView *allListView;

//
@property (nonatomic, strong)AFHTTPSessionManager *manager;
@end

@implementation RadioViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initializationSubViews];
    [self configureSubViews];
    
    // 初始设置tabelView不可以滚动
    _allListTableView.scrollEnabled = NO;
    _allListTableView.showsHorizontalScrollIndicator = NO;
    _allListTableView.showsVerticalScrollIndicator = NO;
    
 

    
    _scrollerView.bounces = NO;
    _scrollerView.showsVerticalScrollIndicator = NO;
    _scrollerView.showsHorizontalScrollIndicator = NO;
    

    // 在tableview上面添加上拉刷新
    _allListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self netNewRequest];
    }];
    
    _manager = [AFHTTPSessionManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self netRequest];
    
}

#pragma mark ----初始化以及定义subviews尺寸----
- (void)initializationSubViews{
    
    _scrollerView = [[UIScrollView alloc] init];
//    _scrollerView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_scrollerView];
    
#pragma 设置scrollerView的代理
    _scrollerView.delegate = self;
    
    _carouselView = [[CarouselView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, (300.0 / 640) * kScreenWidth) imageURLs:@[@"http://pkicdn.image.alimmdn.com/timeline/tagimgs/86602e8ed99158a87434f61aab2c8b47.jpg"]];
    [self.scrollerView addSubview:_carouselView];
    
    UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
    flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowlayout.minimumInteritemSpacing = 5;
    flowlayout.minimumLineSpacing = 5;
    flowlayout.sectionInset = UIEdgeInsetsMake(5, 0, 0, 0);
    flowlayout.itemSize = CGSizeMake((kScreenWidth - 30) / 3, (kScreenWidth - 30) / 3);
    _hotListView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
    //_hotListView.backgroundColor = [UIColor cyanColor];
    [self.scrollerView addSubview:_hotListView];
    _hotListView.dataSource = self;
    _hotListView.delegate = self;
    _hotListView.backgroundColor = [UIColor whiteColor];
    [_hotListView registerClass:[HotListCollectionViewCell class] forCellWithReuseIdentifier:@"hotListCell"];
    
    _allListTableView = [[UITableView alloc] init];
    //_allListTableView.backgroundColor = [UIColor orangeColor];
    [self.scrollerView addSubview:_allListTableView];
    _allListTableView.dataSource = self;
    _allListTableView.delegate = self;
    [_allListTableView registerClass:[AllListTableViewCell class] forCellReuseIdentifier:@"allListCell"];

    
    _allListLabel = [[UILabel alloc] init];
    _allListLabel.text = @"全部电台 ∙ All Radio";
    _allListLabel.font = [UIFont systemFontOfSize:kRadioAllListFontSize];
    [_scrollerView addSubview:_allListLabel];
    
    _allListView = [[UIView alloc] init];
    _allListView.backgroundColor = [UIColor grayColor];
    [_scrollerView addSubview:_allListView];
    
}

- (void)configureSubViews{
    
    [_scrollerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(64);
    }];
    
    [_hotListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollerView.mas_left).offset(10);
#pragma 不知道问什么, 就是不可以用make.right.equalTo(_scrollerView.mas_right).offset(-10);
        make.right.equalTo(_carouselView.mas_right).offset(-10);
        make.top.equalTo(_carouselView.mas_bottom);
        make.height.equalTo(@((kScreenWidth - 30) / 3.0 + 10));
        
    }];
    
    // 获取label的高度以及宽度
    CGRect rect = [_allListLabel.text boundingRectWithSize:CGSizeMake(999, 0) options:(NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName: _allListLabel.font} context:nil];
    [_allListLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_hotListView.mas_bottom).offset(20);
        make.left.equalTo(_scrollerView.mas_left).offset(10);
        make.height.equalTo(@(rect.size.height));
    }];
    
    // 定义假装分割线的约束
    [_allListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_allListLabel.mas_centerY);
        make.left.equalTo(_allListLabel.mas_right).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@1);
    }];
    
    // 定义tabelView的约束
    [_allListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_scrollerView.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.top.equalTo(_allListLabel.mas_bottom).offset(10);
    }];
    
    // 获取_allListLabel的frame
    [_scrollerView setNeedsLayout];
    [_scrollerView layoutIfNeeded];
    CGRect allListLabelFrame = _allListLabel.frame;
    CGRect allListTableViewFrame = _allListTableView.frame;
    
    [_allListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(kScreenHeight - 64 - (allListTableViewFrame.origin.y - allListLabelFrame.origin.y) - 20));
    }];
    
    // 设置scrollerView的content的尺寸
    _scrollerView.contentSize = CGSizeMake(kScreenWidth, kScreenHeight + allListLabelFrame.origin.y - 64 - 20);
    
}

#pragma mark ---网络请求-----

- (void)netRequest{

    [_manager GET:kRadio parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           self.radioListModel = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            [_carouselView carouselCongigureWithImageURLs:_carouselArray];
            [_hotListView reloadData];
            [_allListTableView reloadData];
            [_allListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:NO
             ];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

- (void)netNewRequest {
    [_manager POST:kRadioRefresh parameters:kRadioRefreshDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *newDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            // 获取已经存在的数据中的所有id
            NSArray *theIdArray = [_radioListModel valueForKeyPath:@"data.alllist.radioid"];
            // 判断在新获取的数据是否存在与已有的数据中, 如果不存在, 保存在新数组newList中
            NSMutableArray *newList = [NSMutableArray array];
            if ([newDic[@"result"] isEqualToNumber:@1]) {
                NSArray *listArray = [newDic valueForKeyPath:@"data.list"];
                for (NSDictionary *dict in listArray) {
                    if (![theIdArray containsObject: dict[@"radioid"]]) {
                        [newList addObject:dict];
                    }
                }
                // 将新获取的数据, 与原有数据合并
                [newList addObjectsFromArray:[_radioListModel valueForKeyPath:@"data.alllist"]];
                // 将合并后的数据, 赋值个self.radioListModel
                [_radioListModel setValue:newList forKeyPath:@"data.alllist"];
            }
            [_allListTableView reloadData];
            [_allListTableView.mj_header endRefreshing];
            [_allListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:NO
             ];
           
            
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

- (void)setRadioListModel:(NSMutableDictionary *)radioListModel{
    if (!_carouselArray) {
        _carouselArray = [NSMutableArray array];
    }
    if (!_collectionViewModel) {
        _collectionViewModel = [NSMutableArray array];
    }
    
    
    
    
    // 解析数据的时候,赋值轮播图的数组
    NSArray *carouselArray = [[radioListModel valueForKey:@"data"] valueForKey:@"carousel"];
    for (NSDictionary *dic in carouselArray) {
        [_carouselArray addObject:dic[@"img"]];
    }
    
    NSArray *collectionViewModel = [radioListModel valueForKeyPath:@"data.hotlist"];
    _collectionViewModel = [collectionViewModel mutableCopy];
    
    _radioListModel = [radioListModel mutableCopy];
}



#pragma mark ----实现uitableView以及collectionview协议中的方法-----

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return ((NSArray *)[self.radioListModel valueForKeyPath:@"data.hotlist"]).count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hotListCell" forIndexPath:indexPath];
    
    [cell cellConfigureWithImageURLString:[_collectionViewModel[indexPath.item] valueForKey:@"coverimg"]];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 0.5;
    }
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray *)[self.radioListModel valueForKeyPath:@"data.alllist"]).count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
     if (indexPath.row != 0) {
        AllListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"allListCell" forIndexPath:indexPath];
        NSArray *allListArray = [self.radioListModel valueForKeyPath:@"data.alllist"];
        [cell CellConfigureWith:allListArray[indexPath.row - 1]];
         return cell;
     }else{
         return [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"zhanwei"];
         
     }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    // 获取radioId
    NSArray *theArray = [_radioListModel valueForKeyPath:@"data.alllist"];
    NSDictionary *radioDic = theArray[indexPath.row - 1];
    [self pushToRadioDetailWith:radioDic];

}


- (void)pushToRadioDetailWith:(NSDictionary *)radioDic {
    
    RadioDetailViewController *radioDetailVC = [[RadioDetailViewController alloc] init];
    radioDetailVC.radioId = radioDic[@"radioid"];
    radioDetailVC.titleLabel.text = radioDic[@"title"];
    [self.navigationController pushViewController:radioDetailVC animated:YES];
 
}

#pragma mark ---设置scroller的代理-----
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == _scrollerView) {
        if (scrollView.contentOffset.y + kScreenHeight - 64 == scrollView.contentSize.height) {
            _allListTableView.scrollEnabled = YES;
        }
        else{
            _allListTableView.scrollEnabled = NO;
        }
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    if (scrollView == _allListTableView) {
        [self scrollerToSecondCell];
    }


}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    if (scrollView == _allListTableView) {
        [self scrollerToSecondCell];
    }

    
}

// 指定的假数据, 用于判断如果在结束的时候出现了第一个假装的cell, 那么就跳转到第二个
- (void)scrollerToSecondCell {
    
    UITableViewCell *cell = [_allListTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if ([_allListTableView.visibleCells containsObject:cell]) {
        [_allListTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
    }


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
