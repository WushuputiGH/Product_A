//
//  CommentSendView.h
//  Product_A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentSendView : UIView
@property (strong, nonatomic) IBOutlet UITextView *commentTextView;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendButton:(UIButton *)sender;

// 定义属性, 用于判断textview是否可以当做占位符, 初始值为1;
@property (nonatomic, assign, readwrite) BOOL isPlaceHorld;

@end
