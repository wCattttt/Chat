//
//  UIViewController+AlertController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/26.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "UIViewController+AlertController.h"

@implementation UIViewController (AlertController)
- (void)showAlertWithTitle:(NSString *)title withMsg:(NSString *)msg{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *determineAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:determineAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
