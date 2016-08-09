//
//  AddressBookViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/20.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "AddressBookViewController.h"
#import "EMSDK.h"
#import "EaseUI.h"

#import "AddressTableView.h"

@interface AddressBookViewController ()<EMUserListViewControllerDataSource>
{
    AddressTableView *_tableView;
//    NSMutableArray *_userData;
}
@end

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通讯录";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUser)];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(addressBook)];
    
    [self createTableView];
}

- (void)addUser{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"添加好友" message:@"输入好友名称" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:nil];
    [alertController addTextFieldWithConfigurationHandler:nil];
    UITextField *userTF = alertController.textFields.firstObject;
    userTF.placeholder = @"好友用户名";
    UITextField *msgTF = alertController.textFields[1];
    msgTF.placeholder = @"好友验证信息";
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *sendAction = [UIAlertAction actionWithTitle:@"发送" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager addContact:userTF.text message:msgTF.text];
        if (!error) {
            NSLog(@"添加成功");
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:sendAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
    // 从数据库获取好友
//    NSArray *userlistDB = [[EMClient sharedClient].contactManager getContactsFromDB];
    
    
}

- (void)createTableView{
    // 从服务器获取好友方法
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        NSLog(@"获取成功 -- %@",userlist);
    }else{
        [self showHint:@"检查网络"];
    }
    _tableView = [[AddressTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.userData = userlist;
    [self.view addSubview:_tableView];
    
    // 添加下拉刷新
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor greenColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"别催我!"];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    _tableView.refreshControl = refreshControl;
    
}

- (void)refreshData{
    // 从服务器获取好友方法
    EMError *error = nil;
    NSArray *userlist = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error) {
        NSLog(@"获取成功 -- %@",userlist);
        _tableView.userData = userlist;
        [_tableView reloadData];
    }
    [_tableView.refreshControl endRefreshing];
}


- (void)addressBook{
    EaseUsersListViewController *listViewController = [[EaseUsersListViewController alloc] init];
    listViewController.dataSource = self;
    listViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listViewController animated:YES];
}
/*!
 @method
 @brief 获取用户模型
 @discussion 根据buddy获取用户自定信息，联系人列表里展示昵称和头像
 @param userListViewController 当前联系人视图
 @param buddy 好友的信息描述类
 @result 返回用户模型
 */
//联系人列表扩展样例
- (id<IUserModel>)userListViewController:(EaseUsersListViewController *)userListViewController
                           modelForBuddy:(NSString *)buddy
{
    //用户可以根据自己的用户体系，根据buddy设置用户昵称和头像
    id<IUserModel> model = nil;
    model = [[EaseUserModel alloc] initWithBuddy:buddy];
//    model.avatarURLPath = @"";//头像网络地址
//    model.nickname = @"昵称";//用户昵称
    return model;
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
