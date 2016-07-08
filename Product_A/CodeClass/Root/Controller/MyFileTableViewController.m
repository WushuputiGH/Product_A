//
//  MyFileTableViewController.m
//  Product_A
//
//  Created by lanou on 16/7/7.
//  Copyright © 2016年 H. All rights reserved.
//

#import "MyFileTableViewController.h"
#import "RadioDownloadTable.h"
#import "MyPlayerManager.h"
#import "PlayContainerViewController.h"

@interface MyFileTableViewController ()

@property (nonatomic, strong)NSMutableArray *didDownloadingMusic;
@property (nonatomic, strong)PlayContainerViewController *playContainerVC;
@property (nonatomic, assign)NSInteger count;

@property (nonatomic, strong)NSMutableArray *imageArray;

@end

@implementation MyFileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 从数据库中, 获取已经下载的信息
    RadioDownloadTable *radioDownTable = [[RadioDownloadTable alloc] init];
    self.didDownloadingMusic = [[radioDownTable selectAll] mutableCopy];
    
    self.imageArray = [NSMutableArray array];
    for (NSArray *array in self.didDownloadingMusic) {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[2]]];
        UIImage *image = [UIImage imageWithData:data];
        [self.imageArray addObject:image];
    }
    
    
    // 添加监控, 检测下载数据变化时候执行
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDate) name:@"COMPLETEDOWNLOAD" object:nil];
    self.tableView.backgroundColor = PKCOLOR(40, 40, 40);
    self.tableView.estimatedRowHeight = 50;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshDate{
    RadioDownloadTable *radioDownTable = [[RadioDownloadTable alloc] init];
    self.didDownloadingMusic = [[radioDownTable selectAll] mutableCopy];
    [self.imageArray removeAllObjects];
    for (NSArray *array in self.didDownloadingMusic) {
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:array[2]]];
        UIImage *image = [UIImage imageWithData:data];
        [self.imageArray addObject:image];
    }
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.didDownloadingMusic.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"reuseIdentifier"];
    }
    cell.textLabel.text = self.didDownloadingMusic[indexPath.row][0];
    
//    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.didDownloadingMusic[indexPath.row][2]]];
//    UIImage *image = [UIImage imageWithData:data];
    cell.imageView.image = self.imageArray[indexPath.row];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 设置cell的字体
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = PKCOLOR(40, 40, 40);
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    header.contentView.backgroundColor = PKCOLOR(40, 40, 40);
    header.textLabel.text = @"本地文件";
    return header;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        RadioDownloadTable *radioDownTable = [[RadioDownloadTable alloc] init];
        [radioDownTable deleteWithUrl:self.didDownloadingMusic[indexPath.row][1]];
        [self.didDownloadingMusic removeObjectAtIndex:indexPath.row];
        [self.imageArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
    
    }   
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!_playContainerVC) {
        _playContainerVC = [[PlayContainerViewController alloc] init];
    }
    
//    [self updateMainPlayAndPlayer];
    _playContainerVC.index = indexPath.row;
    NSMutableArray *musicPathList = [NSMutableArray array];
    for (NSArray *musicInfo in self.didDownloadingMusic) {
        NSDictionary *dic = @{@"musicUrl": musicInfo[3], @"coverimg": musicInfo[2], @"playInfo": @{@"title": musicInfo[0]}};
//        [_imageView sd_setImageWithURL:[NSURL URLWithString:_musicInfo[@"coverimg"]]];
//        _titleLabel.text = [_musicInfo valueForKeyPath:@"playInfo.title"];
        [musicPathList addObject:dic];
    }
    _playContainerVC.isLocation = YES;
    _playContainerVC.musicList = [musicPathList mutableCopy];
//    _playContainerVC.name = self.didDownloadingMusic[indexPath.row][0];
    
    NSMutableDictionary *radioDetailModel = [NSMutableDictionary dictionary];
    NSMutableArray *array = [NSMutableArray array];
    for (NSArray *item in self.didDownloadingMusic) {
        NSDictionary *dic = @{@"coverimg": item[2], @"title": item[0], @"musicUrl": item[3], @"playInfo": @{@"title": item[0]}};
        [array addObject:dic];
    }
    [radioDetailModel setValue:array forKeyPath:@"list"];
    
    
    
//    [radioDetailModel setValue:<#(nullable id)#> forKeyPath:@"radioInfo.userinfo.uname"];
    
//    
//    NSArray *array = [self.radioData valueForKeyPath:@"list"];
//    [self.playView.imageView sd_setImageWithURL:[NSURL URLWithString:array[index][@"coverimg"]]];
//    self.playView.titleLabel.text = array[index][@"title"];
//    self.playView.userLabel.text = [self.radioData valueForKeyPath:@"radioInfo.userinfo.uname"];
//    [self changePlayViewButtonImager];
//    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NOTICEADDPLAY" object:nil userInfo:@{@"index": @(indexPath.row), @"radioDetailModel": radioDetailModel, @"isLoacation": @1}];
    
//    [self.navigationController pushViewController:_playContainerVC animated:YES];
    [self presentViewController:_playContainerVC animated:YES completion:nil];
    
    
    
}


//- (void)updateMainPlayAndPlayer{
//    
//    if (_count) {
//        // 刷新数据时候, 除了要本处的数据重新赋值, 还需要赋值播放管理器的东西
//        _playContainerVC.musicList = [[self.radioDetailModel valueForKeyPath:@"data.list"] mutableCopy];
//        
//        NSMutableArray *urlArray = [NSMutableArray array];
//        for (NSString *string in [self.radioDetailModel valueForKeyPath:@"data.list.musicUrl"]) {
//            NSURL *url = [NSURL URLWithString:string];
//            [urlArray addObject:url];
//        }
//        
//        [[MyPlayerManager defaultManager] upDateMediaLists: urlArray];
//        // 设置播放器的下标, 增加count
//        [MyPlayerManager defaultManager].index += _count;
//        
//        // 更改_playContainerVC的下标
//        _playContainerVC.index += _count;
//        _count = 0;
//    }
//    
//}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
