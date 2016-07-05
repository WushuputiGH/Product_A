//
//  CommentSendView.m
//  Product_A
//
//  Created by lanou on 16/7/4.
//  Copyright © 2016年 H. All rights reserved.
//

#import "CommentSendView.h"

@implementation CommentSendView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.isPlaceHorld = 1;
    }
    return self;
}


- (IBAction)sendButton:(UIButton *)sender {
    
}
@end
