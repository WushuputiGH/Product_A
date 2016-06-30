//
//  RadioDetailTableViewCell.m
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RadioDetailTableViewCell.h"

@implementation RadioDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}


//@property (nonatomic, strong, readwrite) UIImageView *theImageView;
//@property (nonatomic, strong, readwrite) UILabel *theTitleLabel;
//@property (nonatomic, strong, readwrite)UIImageView *voiceImageView;
//@property (nonatomic, strong, readwrite)UILabel *musicVisitLabel;
//@property (nonatomic, strong, readwrite) UIButton *playButton;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _theImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_theImageView];
        
        _theTitleLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_theTitleLabel];
        _theTitleLabel.font = [UIFont systemFontOfSize:18];
        
        _voiceImageView = [[UIImageView alloc] init];
        _voiceImageView.image = [UIImage imageNamed:@"WiFi.png"];
        [self.contentView addSubview:_voiceImageView];
        
        _musicVisitLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_musicVisitLabel];
        _musicVisitLabel.font = [UIFont systemFontOfSize:13];
        _musicVisitLabel.textColor = [UIColor grayColor];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:_playButton];
        [self containtSubviews];
        UIImage *buttonImage = [[UIImage imageNamed:@"music_icon_play_highlighted"] imageWithRenderingMode:(UIImageRenderingModeAlwaysTemplate)];
        [_playButton setImage:buttonImage forState:(UIControlStateNormal)];
    }
    return self;
}

- (void)containtSubviews{
    [_theImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(12);
        make.left.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-12);
        make.width.equalTo(_theImageView.mas_height);
    }];
    
    [_theTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_theImageView.mas_right).offset(10);
        make.top.equalTo(_theImageView.mas_top).offset(5);
    }];
    
    [_voiceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_theImageView.mas_bottom);
        make.left.equalTo(_theTitleLabel);
        make.height.width.equalTo(@(kVoiceSzie));
    }];
    
    [_musicVisitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_voiceImageView.mas_right).offset(5);
        make.centerY.equalTo(_voiceImageView.mas_centerY);
    }];
    
    [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-20);
        make.centerY.equalTo(_theImageView.mas_centerY);
        make.height.width.equalTo(@30);
    }];
}


- (void)configureWithDic:(NSDictionary *)dic{
    [_theImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"coverimg"]]];
    _theTitleLabel.text = dic[@"title"];
    _musicVisitLabel.text = [NSString stringWithFormat:@"%@", dic[@"musicVisit"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
