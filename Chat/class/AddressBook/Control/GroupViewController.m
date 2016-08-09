//
//  GroupViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/26.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "GroupViewController.h"
#import "GroupTableView.h"
#import "EMSDK.h"

@interface GroupViewController ()
{
    GroupTableView *_tableView;
}
@end

@implementation GroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"群聊";
    
    [self _createTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView) name:@"CreateGroupComplete" object:nil];
}

- (void)_createTableView{
    NSArray *rooms = [[EMClient sharedClient].groupManager getAllGroups];
    
    _tableView = [[GroupTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    _tableView.groupData = rooms;
    [self.view addSubview:_tableView];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor blueColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"努力加载中..."];
    [refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    
    _tableView.refreshControl = refreshControl;
    
}

- (void)refreshTableView{
    NSArray *rooms = [[EMClient sharedClient].groupManager getAllGroups];
    _tableView.groupData = rooms;
    [_tableView reloadData];
    
    [_tableView.refreshControl endRefreshing];
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
