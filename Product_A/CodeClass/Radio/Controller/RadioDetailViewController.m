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
#import "MyPlayerManager.h"



@interface RadioDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)UIScrollView *theScrollView;
@property (nonatomic, strong)UIImageView *theImageView;
@property (nonatomic, strong)UserInfonView *userInfoView;
@property (nonatomic, strong)UITableView *radioDetailTableView;

@property (nonatomic, strong)AFHTTPSessionManager *netManager;

@property (nonatomic, strong)NSMutableDictionary *radioDetailModel;

@property(nonatomic, strong)PlayContainerViewController *playContainerVC;

@property (nonatomic, strong)NSURL *currentPlayingUrl;

@property (nonatomic, strong)MyPlayerManager *myPlayer;
@property (nonatomic, assign)NSInteger count;

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
    
    // 添加切换音乐的通知观察者
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMedia:) name:@"NOTICECHANGEMEDIA" object:nil];

    
}

#pragma mark ---获取播放列表----


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
    _radioDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(netRequestNew)];
//    _radioDetailTableView.estimatedRowHeight = 80;
 
    
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
        make.height.equalTo(@(userInfoViewRect.origin.y + userInfoViewRect.size.height - 44));
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



- (void)netRequestNew{
    
    NSMutableDictionary *parDic = [kRadioDetailNewDic mutableCopy];
    [parDic setValue:self.radioId forKey:@"radioid"];
    [_netManager POST:kRadioDetailNew parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *newDic = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
            if (![newDic[@"result"] isEqualToNumber:@1]) {
                return ;
            }
            // 首先判断数据是否已经存在, 如果没有存在, 就添加到最上面
            // 获取新取得的数据中所有的电台信息
            NSArray *newRadioArray = [newDic valueForKeyPath:@"data.list"];
            // 获取已经存在的所有的电台id信息
            NSArray *theOldRadioIdArray = [self.radioDetailModel valueForKeyPath:@"data.list.tingid"];
            NSMutableArray *array = [NSMutableArray array];
       
            for (int i = 0; i < newRadioArray.count; i++) {
                // 如果不存在, 添加到array中
                NSString *tingid = [newRadioArray[i] valueForKey:@"tingid"];
                if (![theOldRadioIdArray containsObject:tingid]) {
                    [array addObject:newRadioArray[i]];
                    _count ++;
                }
            }
            
            
            [array addObjectsFromArray:[self.radioDetailModel valueForKeyPath:@"data.list"]];

            [self.radioDetailModel setValue:array forKeyPath:@"data.list"];
        

            
            [_radioDetailTableView reloadData];
            [_radioDetailTableView.mj_header endRefreshing];
            
        });
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];

    
}

- (void)updateMainPlayAndPlayer{
    
    if (_count) {
        // 刷新数据时候, 除了要本处的数据重新赋值, 还需要赋值播放管理器的东西
        _playContainerVC.musicList = [[self.radioDetailModel valueForKeyPath:@"data.list"] mutableCopy];
        
        NSMutableArray *urlArray = [NSMutableArray array];
        for (NSString *string in [self.radioDetailModel valueForKeyPath:@"data.list.musicUrl"]) {
            NSURL *url = [NSURL URLWithString:string];
            [urlArray addObject:url];
        }
        
        [[MyPlayerManager defaultManager] upDateMediaLists: urlArray];
        // 设置播放器的下标, 增加count
        [MyPlayerManager defaultManager].index += _count;
        
        // 更改_playContainerVC的下标
        _playContainerVC.index += _count;
        _count = 0;
    }
    
}

-(void)setRadioDetailModel:(NSMutableDictionary *)radioDetailModel{
    if (!_radioDetailModel) {
        _radioDetailModel = [NSMutableDictionary dictionary];
    }
    
    _radioDetailModel = radioDetailModel;
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_radioDetailModel valueForKeyPath:@"data.radioInfo.coverimg"]]];
    UIImage *image = [UIImage imageWithData:imageData];
    _theImageView.image = image;
    
    [_userInfoView configureWithDic:_radioDetailModel];
    
    
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    /**
     *  判断当前播放的是哪一个歌曲, 如果有的话, 就改变cell中播放按钮的值;
        如果有当前的播放的歌曲, 歌曲下标是currentPlayingIndex - 100;
     */
    UIImage *buttonImage = nil;
    // 获取对应的url;
    NSString *musicUrlString = [array[indexPath.row] valueForKey:@"musicUrl"];
    NSURL *musicUrl = [NSURL URLWithString:musicUrlString];
 
    if ( _currentPlayingUrl && [musicUrl isEqual:_currentPlayingUrl] ){
        buttonImage = [[UIImage imageNamed:@"pause"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    }else{
        buttonImage = [[UIImage imageNamed:@"start"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
    }
    //设置button的tag值, 方便后面使用
    cell.playButton.tag = 100 + indexPath.row;
    [cell.playButton setImage:buttonImage forState:(UIControlStateNormal)];
    [cell.playButton addTarget:self action:@selector(playAction:) forControlEvents:(UIControlEventTouchUpInside)];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (!_playContainerVC) {
        _playContainerVC = [[PlayContainerViewController alloc] init];
    }
    
    [self updateMainPlayAndPlayer];
     _playContainerVC.index = indexPath.row;
    _playContainerVC.musicList = [[self.radioDetailModel valueForKeyPath:@"data.list"] mutableCopy];
    _playContainerVC.name = [self.radioDetailModel valueForKeyPath:@"data.radioInfo.userinfo.uname"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEADDPLAY" object:nil userInfo:@{@"index": @(indexPath.row), @"radioDetailModel": [self.radioDetailModel valueForKeyPath:@"data"]}];

    [self.navigationController pushViewController:_playContainerVC animated:YES];

}

/**
 *  当视图显示的时候, 判断当前播放的是哪一个歌曲;
 *
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 获取当前正在播放的url
    if ([MyPlayerManager defaultManager].playState == Play) {
        // 重新刷新数据
        NSInteger index = [MyPlayerManager defaultManager].index;
        _currentPlayingUrl = [MyPlayerManager defaultManager].mediaLists[index];
        [_radioDetailTableView reloadData];
    }else{
        _currentPlayingUrl = nil;
    }
}

#pragma mark --- 点击cell中播放button执行的方法-----
- (void)playAction:(UIButton *)button{
    
    
    // 获取对应的行
    NSInteger index = button.tag - 100;
    
    NSArray *dataList = [self.radioDetailModel valueForKeyPath:@"data.list"];
    // 获取对应的url
    NSString *musicUrlString = [dataList[index] valueForKey:@"musicUrl"];
    NSURL *musicUrl = [NSURL URLWithString:musicUrlString];
    // 加载音乐播放器
    MyPlayerManager *myPlayer = [MyPlayerManager defaultManager];
    
    
    //如果正在播放, 获取播放对应的url
    NSInteger playingIndex = myPlayer.index;
    NSURL *playUrl = myPlayer.mediaLists[playingIndex];

    if ([musicUrl isEqual:playUrl]) {
        [self updateMainPlayAndPlayer];
        if (myPlayer.playState == Play) {
            _currentPlayingUrl = nil;
            [myPlayer pause];
            [_radioDetailTableView reloadData];
        }else{
            _currentPlayingUrl = musicUrl;
            [myPlayer play];
            [_radioDetailTableView reloadData];
        }
        return;
    }

    NSArray *urlString = [dataList valueForKeyPath:@"musicUrl"];
    NSMutableArray *musicList = [NSMutableArray array];
    for (NSString *item in urlString) {
        NSURL *url = [NSURL URLWithString:item];
        [musicList addObject:url];
    }
    myPlayer.index = index;
    myPlayer.mediaLists = musicList;
    self.currentPlayingUrl = musicUrl;
    [myPlayer play];
  
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEADDPLAY" object:nil userInfo:@{@"index": @(index), @"radioDetailModel": [self.radioDetailModel valueForKeyPath:@"data"]}];
    [_radioDetailTableView reloadData];

}


#pragma mark --- 监听音乐改变时候的通知 ---
- (void)changeMedia: (NSNotification *)sender{
    NSNumber *indexNum = sender.userInfo[@"index"];
    NSInteger index = indexNum.integerValue;
    
    // 将tableView的index行设置为选中状态
    [_radioDetailTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
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
