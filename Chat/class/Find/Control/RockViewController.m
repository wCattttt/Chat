//
//  RockViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/8/8.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "RockViewController.h"

@interface RockViewController ()
{
    UIImageView *imgView;
}
@end

@implementation RockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"摇动手机";
    self.view.backgroundColor = [UIColor darkGrayColor];
    
    [[UIApplication sharedApplication]setApplicationSupportsShakeToEdit:YES];
    
    [self becomeFirstResponder];
    
    UIImageView *rockImgView = [[UIImageView alloc] initWithFrame:CGRectMake((KScreenWidth-50)/2, (KScreenHeight-50)/2, 50, 50)];
    rockImgView.image = [UIImage imageNamed:@"rock"];
    [self.view addSubview:rockImgView];
    
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (KScreenHeight - KScreenWidth)/2, KScreenWidth, KScreenWidth)];
    imgView.image = [UIImage imageNamed:@"doge"];
    [self.view addSubview:imgView];
    imgView.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self resignFirstResponder];
    
}

#pragma mark - ShakeToEdit 摇动手机之后的回调方法

- (void) motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    //检测到摇动开始
    if (motion == UIEventSubtypeMotionShake)
    {
        // your code
        
        NSLog(@"begin animations");
        
    }
    
}

- (void) motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    //摇动取消
    NSLog(@"摇动取消");
    
}

- (void) motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event

{
    //摇动结束
    if (event.subtype == UIEventSubtypeMotionShake) {
        // your code
        NSLog(@"摇动结束");
        
        CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        colorAnimation.autoreverses = YES;
        colorAnimation.duration = 4;
        colorAnimation.fromValue = [NSNumber numberWithDouble:0.1f];
        colorAnimation.toValue = [NSNumber numberWithDouble:1.0f];
        [imgView.layer addAnimation:colorAnimation forKey:@"alphaAnimation"];
    
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
