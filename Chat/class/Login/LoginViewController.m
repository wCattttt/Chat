//
//  LoginViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/20.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "LoginViewController.h"
#import "EMSDK.h"

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
    EMError *error = [[EMClient sharedClient] loginWithUsername:_usernameTF.text password:_passwordTF.text];
    if (!error) {
        NSLog(@"登录成功");
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:KUserState];
    }else{
        [self showHint:error];
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
