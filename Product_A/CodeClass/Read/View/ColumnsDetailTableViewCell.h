//
//  ColumnsDetailTableViewCell.h
//  Product_A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColumnsDetailModel.h"

@interface ColumnsDetailTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) UIImageView *theImageView;
@property (nonatomic, strong, readwrite) UILabel *theTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *theContentLabel;


- (void)cellConfigureWith:(ColumnsDetailItem *)item;

@end
