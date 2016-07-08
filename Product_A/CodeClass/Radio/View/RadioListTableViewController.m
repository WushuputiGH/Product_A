//
//  RadioListTableViewController.m
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RadioListTableViewController.h"
#import "RadioListTableViewCell.h"

@interface RadioListTableViewController ()
@property (nonatomic , strong)NSTimer *timer;

@end

@implementation RadioListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 128);
    self.tableView.estimatedRowHeight = 60;
    
    // 创建定时器, 用于监控下载
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(downLoadTimer:) userInfo:nil repeats:1];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.musicList.count;  
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RadioListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"radioListCell"];
    if (cell == nil) {
        cell = [[RadioListTableViewCell alloc] initWithStyle:(UITableViewCellStyleSubtitle) reuseIdentifier:@"radioListCell"];
    }
    if (self.name) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"by: %@", self.name];
    }
    
    
    return cell;
}

- (void)downLoadTimer:(NSTimer *)timer{
    
    // 获取显示的cell
    NSArray *visibleCells = [self.tableView visibleCells];
    for (RadioListTableViewCell *cell in visibleCells) {
        // 获取cell 对应的index
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        [cell configureWithMusicInfoDic:self.musicList[indexPath.row]];
        [cell changeDownloadButton:self.musicList[indexPath.row]];
    }
    
}



@end
