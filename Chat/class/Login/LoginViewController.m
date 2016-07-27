//
//  LoginViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/20.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "LoginViewController.h"
#import "EMSDK.h"

#import "MainViewController.h"

@interface LoginViewController ()
{
    __weak IBOutlet UITextField *_usernameTF;
    __weak IBOutlet UITextField *_passwordTF;

}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
 
}
- (IBAction)login:(id)sender {
    [self.view endEditing:YES];
    [self showHudInView:self.view hint:@"登录..."];
    EMError *error = [[EMClient sharedClient] loginWithUsername:_usernameTF.text password:_passwordTF.text];
    [self hideHud];
    if (!error) {
        NSLog(@"登录成功");
        [[NSUserDefaults standardUserDefaults] setObject:_usernameTF.text forKey:KUserName];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordTF.text forKey:KPassword];
        
        // 登录成功跳转MainViewController
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KUserState];
        MainViewController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"];
        UIApplication.sharedApplication.delegate.window.rootViewController = mainVC;
    }else{
        [self showHint:@"登录失败"];
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
