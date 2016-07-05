//
//  ShareViewController.h
//  Product_A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController

@property (nonatomic, strong, readwrite) UIButton *shareButton;
@property (nonatomic, strong, readwrite) UIImage *shareImage;
@property (nonatomic, strong, readwrite) NSString *shareTitle;
@property (nonatomic, strong, readwrite) NSString *shareContent;
@property (nonatomic, strong, readwrite) NSString *shareUrl;


- (instancetype)initWithShareTitle:(NSString *)shareTitle shareContent: (NSString *)shareContent shareUrl:(NSString *)shareUrl shareImage:(UIImage *)shareImage;


- (void)configureWithShareTitle:(NSString *)shareTitle shareContent: (NSString *)shareContent shareUrl:(NSString *)shareUrl shareImage:(UIImage *)shareImage;

@end
