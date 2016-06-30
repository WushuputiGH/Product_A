//
//  ReadCollectionViewCell.m
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ReadCollectionViewCell.h"

@implementation ReadCollectionViewCell

-(instancetype)init{
    self = [super init];
    if (self) {
        [self initNameLabelAndEnnameLabel];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initNameLabelAndEnnameLabel];
    }
    return self;
}

- (void)initNameLabelAndEnnameLabel{
    
    self.imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
    self.imageView.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.imageView];
    
    self.nameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = [UIFont systemFontOfSize:18];
    self.nameLabel.textColor = [UIColor whiteColor];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-2);
        make.left.equalTo(self.contentView).offset(2);
//        make.height.equalTo(@40);
    }];
    
    self.ennameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:self.ennameLabel];
    self.ennameLabel.font = [UIFont systemFontOfSize:13];
    self.ennameLabel.textColor = [UIColor whiteColor];
    [self.ennameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel.mas_trailing).offset(2);
        make.bottom.equalTo(self.nameLabel).offset(-2);
//        make.height.equalTo(@30);
    }];

}


- (void)readCollectionViewCellConfigureWith:(ReadItem *)readItem {
    self.nameLabel.text = readItem.name;
    self.ennameLabel.text = readItem.enname;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:readItem.coverimg]];
}

@end
