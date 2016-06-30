//
//  ColumnsDetailTableViewCell.m
//  Product_A
//
//  Created by lanou on 16/6/27.
//  Copyright © 2016年 H. All rights reserved.
//

#import "ColumnsDetailTableViewCell.h"

@implementation ColumnsDetailTableViewCell

- (void)awakeFromNib {
    
    
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initConfingure];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfingure];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initConfingure];
    }
    return self;
}

-(void)initConfingure{
    
    
    self.theTitleLabel = [[UILabel alloc] init];
    [self.contentView addSubview: self.theTitleLabel];
    self.theImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:self.theImageView];
    self.theContentLabel = [[UILabel alloc] init];
    self.theContentLabel.numberOfLines = 0;
    [self.contentView addSubview:self.theContentLabel];


    // 设置label的字体大小
    UIFont *titleFont = [UIFont systemFontOfSize:kColumensDetailTitleFontSize];
    self.theTitleLabel.font = titleFont;
    // 计算label的高度大小
    CGRect titleRect = [@"高度Height" boundingRectWithSize:CGSizeMake(999, 5) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:titleFont} context:nil];
    CGFloat height = titleRect.size.height;
    

    [self.theTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(25);
        make.left.equalTo(self.contentView).offset(20);
        make.right.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@(height));
    
    }];
    
    [self.theImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.theTitleLabel.mas_bottom).offset(17);
        make.left.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-17);
        make.width.equalTo(self.theImageView.mas_height).multipliedBy(608/300.0);
    }];
    

    // 设置conent的字体, 字体颜色等
    self.theContentLabel.font = [UIFont systemFontOfSize:kColumensDetailContentFontSize];
    self.theContentLabel.textColor = kColumensDetailContentFontColor;
    
    [self.theContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.theImageView);
        make.left.equalTo(self.theImageView.mas_right).offset(17);
        make.right.equalTo(self.contentView).offset(-20);
        // 注意需要设置label的最大宽度, 要不然会超过cell
        make.height.lessThanOrEqualTo(self.theImageView.mas_height);
    }];
}


- (void)cellConfigureWith:(ColumnsDetailItem *)item{
    
    self.theTitleLabel.text = item.title;
    self.theContentLabel.text = item.content;
    [self.theImageView sd_setImageWithURL:[NSURL URLWithString:item.coverimg]];



    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
