//
//  RegistViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/20.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "RegistViewController.h"

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
}
- (IBAction)regist:(id)sender {
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
