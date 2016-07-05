//
//  CommentTableViewCell.h
//  Product_A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *theImageView;
@property (strong, nonatomic) IBOutlet UILabel *theNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *theTimeLabel;

@property (strong, nonatomic) IBOutlet UILabel *theCommentLabel;



- (void)cellCongifureWith:(NSDictionary *)oneCommentInfo;

@end
