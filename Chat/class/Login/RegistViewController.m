//
//  RegistViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/20.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "RegistViewController.h"
#import "EMSDK.h"

@interface RegistViewController ()
{
    __weak IBOutlet UITextField *_userNameTF;
    __weak IBOutlet UITextField *_passwordTF;
    __weak IBOutlet UITextField *_rePasswordTF;

}
@end

@implementation RegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)regist:(id)sender {
    [self.view endEditing:YES];
    if(_userNameTF.text.length > 0 && _passwordTF.text.length > 0 && _rePasswordTF.text.length > 0 &&   [_passwordTF.text isEqualToString:_rePasswordTF.text]){
        [self showHudInView:self.view hint:@"正在注册..."];
        EMError *error = [[EMClient sharedClient] registerWithUsername:_userNameTF.text password:_passwordTF.text];
        [self hideHud];
        if (error==nil) {
            [self showHint:@"注册成功"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self showHint:@"注册失败"];
        }
    }else{
        [self showHint:@"两次密码不一致"];
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
