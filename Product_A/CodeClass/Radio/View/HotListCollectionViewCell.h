//
//  HotListCollectionViewCell.h
//  Product_A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotListCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong, readwrite) UIImageView *theImageView;
- (void)cellConfigureWithImageURLString:(NSString *)imageURLString;
@end
