//
//  RadioDownloadTableViewController.m
//  Product_A
//
//  Created by lanou on 16/7/2.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RadioDownloadTableViewController.h"
#import "RadioListTableViewCell.h"

@interface RadioDownloadTableViewController ()

@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic, strong)NSArray *downloadingMusic;
@property (nonatomic, strong)NSArray *didDownloadingMusic;


@end

@implementation RadioDownloadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 创建定时器, 用于监控下载
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(downLoadTimer:) userInfo:nil repeats:1];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(10, 5, 10, 5);
    self.tableView.separatorColor = [UIColor lightTextColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(-20, 10, 10, 10);
    [self refreshDate];
    // 添加监控, 检测下载数据变化时候执行
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshDate) name:@"COMPLETEDOWNLOAD" object:nil];
    self.tableView.backgroundColor = PKCOLOR(40, 40, 40);
    self.tableView.estimatedRowHeight = 50;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.downloadingMusic.count;
    }
    if (section == 1) {
        return self.didDownloadingMusic.count;
    }
    return 0;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"radioListCell"];
    if (cell == nil) {
        cell = [[RadioListTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"radioListCell"];
    }
    
    if (indexPath.section == 0) {
        [cell.downLoadload setEnabled:YES];
        [cell configureWithMusicInfoDic:self.downloadingMusic[indexPath.row]];
        [cell changeDownloadButton:self.downloadingMusic[indexPath.row]];
        
    }
    
    if (indexPath.section == 1) {
        [cell.downLoadload setEnabled:NO];
        cell.textLabel.text = self.didDownloadingMusic[indexPath.row][0];
        [cell.downLoadload setImage:[UIImage imageNamed:@"download2"] forState:UIControlStateNormal];
        [cell.downLoadload setTitle:@"已完成" forState:(UIControlStateNormal)];
    }

    // 设置cell没有点选背景
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    // 设置cell的字体
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.downLoadload.tintColor = [UIColor lightGrayColor];
    cell.backgroundColor = PKCOLOR(40, 40, 40);
    
    return cell;
}




- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    header.contentView.backgroundColor = PKCOLOR(40, 40, 40);

    if (section == 0) {
        header.textLabel.text = @"正在下载";
    }
    if (section == 1) {
        header.textLabel.text = @"下载完成";
    }
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
 
    if (section == 0) {
        if (self.downloadingMusic.count == 0) {
            return 0;
        }
        return 30;
    }
    if (section == 1) {
        if (self.didDownloadingMusic.count == 0) {
            return 0;
        }
        return 30;
    }
    return 0;

}

- (void)downLoadTimer:(NSTimer *)timer{
    // 获取显示的cell
    NSArray *visibleCells = [self.tableView visibleCells];
    for (RadioListTableViewCell *cell in visibleCells) {
        // 获取cell 对应的index
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        if (indexPath.section == 0) {
            [cell configureWithMusicInfoDic:self.downloadingMusic[indexPath.row]];
            [cell changeDownloadButton:self.downloadingMusic[indexPath.row]];

        }
        
    }
    
}



- (void)refreshDate{
    // 获取正在下载的
    DownLoadManager *dManager = [DownLoadManager defaultManager];
    NSDictionary *downLoadTaskInfoDict = dManager.downLoadTaskInfoDict;
    NSMutableArray *downloadingArray = [NSMutableArray array];
    for (NSString *key in downLoadTaskInfoDict) {
        DownLoadTaskInfo *downLoadTaskInfo = downLoadTaskInfoDict[key];
        [downloadingArray addObject:downLoadTaskInfo.musicInfo];
    }
    self.downloadingMusic = downloadingArray;
    
    // 从数据库中, 获取已经下载的信息
    RadioDownloadTable *radioDownTable = [[RadioDownloadTable alloc] init];
    self.didDownloadingMusic = [radioDownTable selectAll];
    [self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
