//
//  ShareButton.h
//  Product_A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareButton : UIButton

@property (nonatomic, strong, readwrite) UIImage *shareImage;
@property (nonatomic, strong, readwrite) NSString *shareTitle;
@property (nonatomic, strong, readwrite) NSString *shareContent;
@property (nonatomic, strong, readwrite) NSString *shareUrl;


- (void)configureWithShareTitle:(NSString *)shareTitle shareContent: (NSString *)shareContent shareUrl:(NSString *)shareUrl shareImage:(UIImage *)shareImage;

@end
