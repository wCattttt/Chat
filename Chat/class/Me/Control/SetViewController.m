//
//  SetViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/26.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "SetViewController.h"
#import "EMSDK.h"
#import "LoginViewController.h"
#import "UIViewController+AlertController.h"

@interface SetViewController()
{

}

@end

@implementation SetViewController

- (void)viewDidLoad{
    UIButton *logoutBt = [UIButton buttonWithType:UIButtonTypeCustom];
    logoutBt.layer.masksToBounds = YES;
    logoutBt.layer.cornerRadius = 8;
    logoutBt.backgroundColor = [UIColor redColor];
    logoutBt.frame = CGRectMake(8, 70, KScreenWidth - 16, 45);
    [logoutBt setTitle:@"退出登录" forState:UIControlStateNormal];
    [logoutBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logoutBt addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logoutBt];
}

- (void)logoutAction{
    
    EMError *error = [[EMClient sharedClient] logout:YES];
    if (!error) {
        [self showAlertWithTitle:@"提示" withMsg:@"退出成功"];
//        [self.navigationController popViewControllerAnimated:YES];
        UIApplication.sharedApplication.delegate.window.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    }else{
        [self showHint:error.errorDescription];
    }
}

@end
