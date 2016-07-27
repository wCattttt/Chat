//
//  UIViewController+AlertController.h
//  Chat
//
//  Created by 魏唯隆 on 16/7/26.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import <UIKit/UIKit.h>
// 只含一个确定按钮的AlertView
@interface UIViewController (AlertController)
- (void)showAlertWithTitle:(NSString *)title withMsg:(NSString *)msg;
@end
