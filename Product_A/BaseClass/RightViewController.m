//
//  RightViewController.m
//  Product_A
//
//  Created by lanou on 16/6/24.
//  Copyright © 2016年 H. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

@property (nonatomic, strong)UIButton *button;
@property (nonatomic, strong)UITapGestureRecognizer *tap;
@property (nonatomic, strong)UIPanGestureRecognizer *pan;

@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
    [self.view addSubview:self.titleLabel];
    // 竖线
    UIView *vertical = [[UIView alloc] initWithFrame:CGRectMake(40, 20, 1, kNaviH)];
    vertical.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:vertical];
    
    // 横线
    UIView *horizontal = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + kNaviH, kScreenWidth, 1)];
     horizontal.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:horizontal];
    
    [self.view addGestureRecognizer:self.tap];
    
    UIScreenEdgePanGestureRecognizer *screenEdgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(screenEdgePanAction:)];
    
    // 设置边界为左边界
    screenEdgePan.edges  = UIRectEdgeLeft;
    [self.view addGestureRecognizer:screenEdgePan];
    
    [self.view addGestureRecognizer:self.pan];
    
    
}

#pragma  mark --属性


- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        _pan.enabled = NO;
    }
    return _pan;
}

- (UITapGestureRecognizer *)tap{
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] init];
        [_tap addTarget:self action:@selector(tap:)];
    }
    return _tap;
}

- (UIButton*)button {
    if (!_button) {
        _button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _button.frame = CGRectMake(10, 30, 20, 20);
        [_button setTitle:@"三" forState:(UIControlStateNormal)];
        [_button setTitleColor:PKCOLOR(25, 25, 25) forState:(UIControlStateNormal)];
        [_button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _button;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 30, 200, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = PKCOLOR(25, 25, 25);
    }
    return _titleLabel;
}


- (void)buttonAction:(UIButton *)button {
    [self changeFrameWithType: MOVETYPERIGHT];
    
   }

- (void)changeFrameWithType: (MOVETYPE)moveType
{
    CGRect newFrame = self.navigationController.view.frame;
    if (moveType == MOVETYPELEFT) {
        self.tap.enabled = NO;
        self.button.userInteractionEnabled = YES;
        self.pan.enabled = NO;
        newFrame.origin.x = 0;
    } else if (moveType == MOVETYPERIGHT){
        self.tap.enabled = YES;
        self.button.userInteractionEnabled = NO;
        self.pan.enabled = YES;
        newFrame.origin.x = kScreenWidth - kMovieDistance;
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.view.frame = newFrame;
    }];
}

- (void)tap:(UIGestureRecognizer *)tap {
    [self changeFrameWithType:(MOVETYPELEFT)];
}

- (void)panAction: (UIPanGestureRecognizer *)pan {
    CGPoint location = [pan translationInView:self.navigationController.view.superview];
    NSLog(@"%@", NSStringFromCGPoint(location));
    CGRect newFrame = self.navigationController.view.frame;
    newFrame.origin.x += location.x;
    [self constraintNewFrame:&newFrame];
    self.navigationController.view.frame = newFrame;
    
    if (pan.state == UIGestureRecognizerStateEnded && ([pan locationInView:self.navigationController.view.superview].x <= kScreenWidth - kMovieDistance)) {
        [self changeFrameWithType:MOVETYPELEFT];
    }
    [pan setTranslation:CGPointZero inView:self.navigationController.view.superview];

}

- (void)screenEdgePanAction: (UIScreenEdgePanGestureRecognizer *)screenEdgePan {
    CGPoint location = [screenEdgePan locationInView:self.navigationController.view.superview];
    NSLog(@"%@", NSStringFromCGPoint(location));
    CGRect newFrame = self.navigationController.view.frame;
    newFrame.origin.x = location.x;
    [self constraintNewFrame:&newFrame];
    self.navigationController.view.frame = newFrame;
    
    if (screenEdgePan.state == UIGestureRecognizerStateEnded) {
        [self changeFrameWithType:MOVETYPERIGHT];
    }
}

- (void)constraintNewFrame:(CGRect *)newFrame {
    if (newFrame ->origin.x >= kScreenWidth - kMovieDistance) {
        newFrame -> origin.x = kScreenWidth - kMovieDistance;
    }else if (newFrame -> origin.x <= 0)
    {
        //  在进行pan的时候, 如果newFrame小于零的时候,
        newFrame -> origin.x = 0;
    }
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
