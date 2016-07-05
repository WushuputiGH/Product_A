//
//  CommentTableViewController.m
//  Product_A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import "CommentTableViewController.h"
#import "CommentModel.h"
#import "UserInfoManager.h"
#import "CommentTableViewCell.h"


@interface CommentTableViewController ()

@property (nonatomic, strong)CommentModel *commentModel;



@end

@implementation CommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 注册cell
    self.commentModel = [[CommentModel alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"commentTableCell"];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 20;
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.separatorStyle = 0;
    [self netRequst];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
}

- (void)netRequst{
    
    AFHTTPSessionManager *netManager = [AFHTTPSessionManager manager];
    netManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *parDic = [kCommentParUrl mutableCopy];
    if ([UserInfoManager getUserAuth]) {
        [parDic setValue:[UserInfoManager getUserAuth] forKey:@"auth"];
    }
    [parDic setValue:self.articleInfoModel.data[@"contentid"] forKey:@"contentid"];
    [netManager POST:kCommentUrl parameters:parDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *newData = [NSJSONSerialization JSONObjectWithData:responseObject options:(NSJSONReadingMutableContainers) error:nil];
        self.commentModel.data = newData;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
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
    NSArray *listArray = [self.commentModel.data valueForKeyPath:@"data.list"];
    return listArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentTableCell" forIndexPath:indexPath];
    NSArray *listArray = [self.commentModel.data valueForKeyPath:@"data.list"];
    [cell cellCongifureWith:listArray[indexPath.row]];
    return cell;
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
