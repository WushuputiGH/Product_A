//
//  UserInfonView.h
//  Product_A
//
//  Created by lanou on 16/6/29.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfonView : UIView


@property (nonatomic, strong)UILabel *unameLabel;
@property (nonatomic, strong)UILabel *descLabel;
@property (nonatomic, strong)UIImageView *iconImageView;
@property (nonatomic, strong)UIImageView *voiceImageView;
@property (nonatomic, strong)UILabel *musicvisitnumLabel;

- (void)configureWithDic:(NSDictionary *)dic;

@end
