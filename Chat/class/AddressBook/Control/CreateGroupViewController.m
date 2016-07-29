//
//  CreateGroupViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/29.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "AddGroupUserViewController.h"
#import "CreateGroupModel.h"
#import "EMSDK.h"

@interface CreateGroupViewController ()

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _createView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popVC) name:@"CreateGroupComplete" object:nil];
}
- (void)popVC{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)_createView{
    NSArray *tfArray = @[@"群名称", @"群描述", @"群组验证信息"];
    [tfArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(8, idx*40 + 10*idx + 70, KScreenWidth - 16, 40)];
        tf.borderStyle = UITextBorderStyleRoundedRect;
        tf.placeholder = obj;
        tf.tag = idx + 100;
        [self.view addSubview:tf];
    }];
    
    UIButton *addUserBt = [UIButton buttonWithType:UIButtonTypeCustom];
    addUserBt.layer.masksToBounds = YES;
    addUserBt.layer.cornerRadius = 8;
    addUserBt.frame = CGRectMake(8, 150 + 70, KScreenWidth - 16, 40);
    [addUserBt setTitle:@"添加群成员" forState:UIControlStateNormal];
    [addUserBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addUserBt.backgroundColor = [UIColor colorWithRed:40.2f/255 green:180.2f/255 blue:247.2f/255 alpha:1];
    [addUserBt addTarget:self action:@selector(addUser) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addUserBt];

    
}

- (void)addUser{
    UITextField *title = [self.view viewWithTag:100];
    UITextField *description = [self.view viewWithTag:101];
    UITextField *message = [self.view viewWithTag:102];
    if(title.text.length <= 0){
        [self showHint:@"群名称未填写"];
        return;
    }else if(description.text.length <= 0){
        [self showHint:@"群描述未填写"];
        return;
    }else if(message.text.length <= 0){
        [self showHint:@"群验证信息未填写"];
        return;
    }
    
    AddGroupUserViewController *addGroupVC = [[AddGroupUserViewController alloc] init];
    
    CreateGroupModel *model = [[CreateGroupModel alloc] init];
    model.groupTitle = title.text;
    model.groupDescription = description.text;
    model.groupMessage = message.text;
    EMGroupOptions *setting = [[EMGroupOptions alloc] init];
    setting.maxUsersCount = 500;
    setting.style = EMGroupStylePrivateOnlyOwnerInvite;// 创建不同类型的群组，这里需要才传入不同的类型
    model.setting = setting;
    
    addGroupVC.createGroupModel = model;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:addGroupVC];
    [self presentViewController:nav animated:YES completion:nil];
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
