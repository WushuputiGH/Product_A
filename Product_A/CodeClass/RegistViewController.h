//
//  RegistViewController.h
//  Product_A
//
//  Created by lanou on 16/7/1.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistView.h"


@interface RegistViewController : UIViewController

@property (nonatomic, assign)NSInteger gender;
@property (nonatomic, strong)UIImage *uploadImage;

@property (strong, nonatomic) IBOutlet UIScrollView *theScrollerView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)back:(UIButton *)sender;
@property (nonatomic, strong, readwrite) RegistView *registView;

@property (nonatomic, copy, readwrite) void (^registSuccessed) (NSString *email);








@end
