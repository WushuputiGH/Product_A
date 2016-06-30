//
//  RadioListTableViewCell.m
//  Product_A
//
//  Created by lanou on 16/6/30.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RadioListTableViewCell.h"

@implementation RadioListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.downLoadload = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _downLoadload = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.downLoadload setImage:[UIImage imageNamed:@"u148_end.png"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.downLoadload];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    [_downLoadload mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-16);
        make.centerY.equalTo(self.contentView);
        make.height.width.equalTo(@30);
    }];
}







@end
