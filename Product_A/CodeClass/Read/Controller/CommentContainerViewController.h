//
//  CommentContainerViewController.h
//  Product_A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RightViewController.h"
#import "ArticleInfoModel.h"
@interface CommentContainerViewController : RightViewController
@property (nonatomic, strong, readwrite) ArticleInfoModel *articleInfoModel;
@end
