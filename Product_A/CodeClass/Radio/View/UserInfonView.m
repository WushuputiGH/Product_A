//
//  UserInfonView.m
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import "UserInfonView.h"

#define kIconSize 50
#define kVoiceSzie 15

@implementation UserInfonView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        _unameLabel = [[UILabel alloc] init];
        _unameLabel.font = [UIFont systemFontOfSize:22];
        _unameLabel.textColor = [UIColor darkTextColor];
        [self addSubview:_unameLabel];
        _descLabel = [[UILabel alloc] init];
        _descLabel.font = [UIFont systemFontOfSize:20];
        _descLabel.textColor= [UIColor darkGrayColor];
        _descLabel.numberOfLines = 0;
        [self addSubview:_descLabel];
        _iconImageView = [[UIImageView alloc]init];
        _iconImageView.layer.cornerRadius = kIconSize / 2.0;
        _iconImageView.clipsToBounds = YES;
        [self addSubview:_iconImageView];
        _voiceImageView = [[UIImageView alloc] init];
        _voiceImageView.image = [UIImage imageNamed:@"WiFi.png"];
        [self addSubview:_voiceImageView];
        _musicvisitnumLabel = [[UILabel alloc] init];
        _musicvisitnumLabel.font = [UIFont systemFontOfSize:13];
        _musicvisitnumLabel.textColor = [UIColor grayColor];
        [self addSubview:_musicvisitnumLabel];
    }
    return self;
}


- (void)configureWithDic:(NSDictionary *)dic{

    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[dic valueForKeyPath:@"data.radioInfo.userinfo.icon"]]];
    _unameLabel.text = [dic valueForKeyPath:@"data.radioInfo.userinfo.uname"];
   
    _descLabel.text = [dic valueForKeyPath:@"data.radioInfo.desc"];
    _musicvisitnumLabel.text = [NSString stringWithFormat:@"%@",[dic valueForKeyPath:@"data.radioInfo.musicvisitnum"]];
}

-(void)layoutSubviews{
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self).offset(20);
        make.height.width.equalTo(@kIconSize);
    }];
    [_unameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(8);
        make.centerY.equalTo(_iconImageView);
    }];
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView);
        make.top.equalTo(_iconImageView.mas_bottom).offset(20);
        make.width.lessThanOrEqualTo(self.superview.mas_width).offset(-20);
    }];
    [_musicvisitnumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-20);
        make.centerY.equalTo(_iconImageView);
    }];
    
    [_voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_musicvisitnumLabel.mas_left).offset(-8);
        make.centerY.equalTo(_iconImageView.mas_centerY);
        make.width.height.equalTo(@(kVoiceSzie));
    }];
   
}



@end
