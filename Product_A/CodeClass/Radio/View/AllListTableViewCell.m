//
//  AllListTableViewCell.m
//  Product_A
//
//  Created by lanou on 16/6/28.
//  Copyright © 2016年 H. All rights reserved.
//

#import "AllListTableViewCell.h"

@implementation AllListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initNameLabelAndEnnameLabel];
    }
    return self;
}


- (void)initNameLabelAndEnnameLabel{
    self.theImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.theImageView];
    [_theImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(7);
        make.left.equalTo(self.contentView).offset(7);
        make.bottom.equalTo(self.contentView).offset(-7);
        make.width.equalTo(_theImageView.mas_height);
    }];
    
    self.theTitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_theTitleLabel];
    _theTitleLabel.font = [UIFont systemFontOfSize:20];
    _theTitleLabel.textColor = [UIColor darkTextColor];
    // 计算高度
    [_theTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_theImageView.mas_top).offset(5);
        make.left.equalTo(_theImageView.mas_right).offset(7);
    }];
 
    self.theUnNameLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_theUnNameLabel];
    _theUnNameLabel.font = [UIFont systemFontOfSize:15];
    _theUnNameLabel.textColor = [UIColor darkGrayColor];
   
    [_theUnNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_theTitleLabel.mas_bottom).offset(2);
        make.left.equalTo(_theTitleLabel);
    }];
    
    self.theDescLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_theDescLabel];
    _theDescLabel.numberOfLines = 0;
    _theDescLabel.font = [UIFont systemFontOfSize:17];
    _theDescLabel.textColor = [UIColor lightGrayColor];
    
    [_theDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_theUnNameLabel.mas_bottom).offset(5);
        make.left.equalTo(_theTitleLabel);
        make.right.lessThanOrEqualTo(self.contentView).offset(-5);
    }];

    self.countLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_countLabel];
    _countLabel.numberOfLines = 0;
    _countLabel.font = [UIFont systemFontOfSize:15];
    _countLabel.textColor = [UIColor lightGrayColor];
    
    [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.equalTo(_theTitleLabel);
    }];

    self.voiceImage = [[UIImageView alloc] init];
    [self.contentView addSubview:_voiceImage];
    _voiceImage.image = [UIImage imageNamed:@"WiFi.png"];
    [_voiceImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_countLabel.mas_left).offset(-5);
        make.centerY.equalTo(_countLabel.mas_centerY);
        make.height.width.equalTo(@15);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)CellConfigureWith:(NSDictionary *)radioInfo{
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:radioInfo[@"coverimg"]]];
    _theTitleLabel.text = radioInfo[@"title"];
    _theUnNameLabel.text = [radioInfo valueForKeyPath:@"userinfo.uname"];
    _theDescLabel.text = radioInfo[@"desc"];
    _countLabel.text = [NSString stringWithFormat:@"%@", radioInfo[@"count"]];
    
}

@end
