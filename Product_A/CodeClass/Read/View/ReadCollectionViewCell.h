//
//  ReadCollectionViewCell.h
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadItem.h"

@interface ReadCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong, readwrite) UILabel *nameLabel;
@property (nonatomic, strong, readwrite) UILabel *ennameLabel;
@property (nonatomic, strong, readwrite) UIImageView *imageView;

- (void)readCollectionViewCellConfigureWith:(ReadItem *)readItem;

@end
