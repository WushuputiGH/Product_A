//
//  HotListCollectionViewCell.m
//  Product_A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 H. All rights reserved.
//

#import "HotListCollectionViewCell.h"

@implementation HotListCollectionViewCell

- (instancetype)init{
    self = [super init];
    if (self) {
        _theImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_theImageView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _theImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_theImageView];
    }
    return self;
}

- (void)cellConfigureWithImageURLString:(NSString *)imageURLString
{
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString]];
}


@end
