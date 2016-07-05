//
//  CommentTableViewController.h
//  Product_A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ArticleInfoModel.h"

@interface CommentTableViewController : UITableViewController

@property (nonatomic, strong, readwrite) ArticleInfoModel *articleInfoModel;

- (void)netRequst;

@end
