//
//  RootViewController.m
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RootViewController.h"
#import "RightViewController.h"
#define kCAGradientLayerH (kScreenHeight / 3.0)
@interface RootViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong)NSArray *controllers;
@property (nonatomic, strong)NSArray *titles;
@property (nonatomic, strong)RightViewController *rightVC;
@property (nonatomic, strong)UINavigationController *myNavigationVC;
@property (nonatomic, assign)BOOL isFirstSelected;

@end

@implementation RootViewController

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initGradientLayer];
    [self initTableView];
}

- (void)initTableView {
    _controllers = @[@"RadioViewController", @"ReadViewController", @"CommunityViewController", @"ProductViewController", @"SettingViewController"];
    _titles = @[@"电台", @"阅读", @"社区", @"良品", @"设置"];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20 + kCAGradientLayerH, kScreenWidth, kScreenHeight - 20 - kCAGradientLayerH - 64) style:(UITableViewStylePlain)];
    tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = PKCOLOR(40, 40, 40);
    tableView.rowHeight = tableView.height / _titles.count;
    tableView.dataSource = self;
    tableView.delegate = self;
    [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:nil scrollPosition:(UITableViewScrollPositionTop)];
    [self.view addSubview:tableView];

    
    // 初始化子视图
    _rightVC = [[NSClassFromString(_controllers[0]) alloc] init];
    _rightVC.titleLabel.text = _titles[0];
    _myNavigationVC = [[UINavigationController alloc] initWithRootViewController:_rightVC];
    _myNavigationVC.navigationBar.hidden = YES;
    [self.view addSubview:_myNavigationVC.view];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"rootCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"rootCell"];
    }
    cell.textLabel.text = _titles[indexPath.row];
    
    cell.textLabel.font = [UIFont systemFontOfSize:tableView.rowHeight / 4];
//    NSLog(@"%f", tableView.rowHeight);
//    NSLog(@"%f", cell.height);
//    NSLog(@"%d", cell.isSelected);
    cell.textLabel.textColor = PKCOLOR(80, 80, 80);
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor grayColor];
    cell.backgroundColor = PKCOLOR(40, 40, 40);
    if ((indexPath.row == 0 && _isFirstSelected == NO) || cell.isSelected == YES) {
        cell.textLabel.textColor = PKCOLOR(240, 240, 240);
        _isFirstSelected = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = PKCOLOR(240, 240, 240);
    if ([_rightVC isMemberOfClass: [NSClassFromString(_controllers[indexPath.row]) class]]) {
        [_rightVC changeFrameWithType:MOVETYPELEFT];
        return;
    }
    [_myNavigationVC.view removeFromSuperview];
    
    // 初始化子视图控制器
   
    _rightVC = [[NSClassFromString(_controllers[indexPath.row]) alloc] init];
    _rightVC.titleLabel.text = _titles[indexPath.row];
    _myNavigationVC = [[UINavigationController alloc] initWithRootViewController:_rightVC];
    _myNavigationVC.navigationBar.hidden = YES;
    [self.view addSubview:_myNavigationVC.view];
//    _myNavigationVC.view.frame = CGRectMake(kScreenWidth - kMovieDistance, 0, kScreenWidth, kScreenHeight);
    CGRect newFrame = _rightVC.navigationController.view.frame;
    newFrame.origin.x = kScreenWidth - kMovieDistance;
    _rightVC.navigationController.view.frame = newFrame;
    [_rightVC changeFrameWithType:MOVETYPELEFT];
    
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.textColor = PKCOLOR(80, 80, 80);
    
}



- (void)initGradientLayer {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 20, kScreenWidth, kCAGradientLayerH);
    gradientLayer.colors = @[(id)PKCOLOR(180, 180, 180).CGColor, (id)PKCOLOR(100, 90, 100).CGColor,(id)PKCOLOR(40, 40, 40).CGColor];
    [self.view.layer addSublayer:gradientLayer];
    
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
