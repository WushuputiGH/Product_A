//
//  CommentTableViewCell.m
//  Product_A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.theImageView.layer.cornerRadius = 25;
    self.theImageView.clipsToBounds = YES;
    self.theCommentLabel.layer.cornerRadius = 5;
    self.theCommentLabel.clipsToBounds = YES;
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)cellCongifureWith:(NSDictionary *)oneCommentInfo
{
    
    [self.theImageView sd_setImageWithURL:[NSURL URLWithString:[oneCommentInfo valueForKeyPath:@"userinfo.icon"]]];
    self.theNameLabel.text = [oneCommentInfo valueForKeyPath:@"userinfo.uname"];
    self.theTimeLabel.text = [oneCommentInfo valueForKeyPath:@"addtime_f"];
    self.theCommentLabel.text = [oneCommentInfo valueForKeyPath:@"content"];    
}


@end
