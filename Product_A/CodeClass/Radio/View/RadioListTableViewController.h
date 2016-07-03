//
//  RadioListTableViewController.h
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RadioListTableViewController : UITableViewController

@property (nonatomic, strong, readwrite) NSMutableArray *musicList;
@property (nonatomic, strong, readwrite) NSString *name;

@end
