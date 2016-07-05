//
//  PlayTitleView.h
//  Product_A
//
//  Created by lanou on 16/7/5.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareButton.h"

@interface PlayTitleView : UIView
@property (strong, nonatomic) IBOutlet UIButton *playTypeButton;
@property (strong, nonatomic) IBOutlet UILabel *theLabel;

@property (strong, nonatomic) IBOutlet UIButton *colloctionButton;

@property (strong, nonatomic) IBOutlet ShareButton *shareButton;


- (IBAction)changePlayType:(UIButton *)sender;

- (IBAction)colloction:(UIButton *)sender;

- (void)changeAccrodingPlaytype;



@end
