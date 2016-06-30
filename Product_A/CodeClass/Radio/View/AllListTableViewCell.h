//
//  AllListTableViewCell.h
//  Product_A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllListTableViewCell : UITableViewCell

@property (nonatomic, strong, readwrite) UIImageView *theImageView;
@property (nonatomic, strong, readwrite) UILabel *theTitleLabel;
@property (nonatomic, strong, readwrite) UILabel *theUnNameLabel;
@property (nonatomic, strong, readwrite) UILabel *theDescLabel;
@property (nonatomic, strong, readwrite) UIImageView *voiceImage;
@property (nonatomic, strong, readwrite) UILabel *countLabel;

-(void)CellConfigureWith:(NSDictionary *)radioInfo;


@end
