//
//  ProductTableViewCell.m
//  Product_A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ProductTableViewCell.h"

@implementation ProductTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellConfigure:(NSDictionary *)productInfo{
    
    // 首先获取标题
    NSString *productTitle = productInfo[@"title"];
    
    //「悟」：最后的答案，是你自己
    self.titleLabel.text = productTitle;
    self.typeLabel.text = @"";
    [self.theImageView sd_setImageWithURL:[NSURL URLWithString:productInfo[@"coverimg"]]];
    
}

@end
