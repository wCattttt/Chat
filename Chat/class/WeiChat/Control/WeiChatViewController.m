//
//  WeiChatViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/20.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "WeiChatViewController.h"
#import "EMSDK.h"
#import "EaseUI.h"
#import "ChatTableView.h"

@interface WeiChatViewController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource, EMChatManagerDelegate>
{
    ChatTableView *_tableView;
    AVAudioPlayer *_player;
    
    UIButton *_rightBt;
    int _num;
}
@end

@implementation WeiChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"微信";
    
    [self stepPlay];
    [self _createRightBt];
    _num = 1;

    //获取未读消息数，此时并没有把self注册为SDK的delegate，读取出的未读数是上次退出程序时的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupUnreadMessageCount) name:@"setupUnreadMessageCount" object:nil];
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    // 刷新tableView
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshChatTableView) name:@"refreshChatTableView" object:nil];
    
    [self setupUnreadMessageCount];
    
    
    [self _createTableView];
}

- (void)_createRightBt{
    _rightBt = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBt.frame = CGRectMake(0, 0, 50, 50);
    [_rightBt setImage:[UIImage imageNamed:@"VoiceSearchFeedback001@2x"] forState:UIControlStateNormal];
    [_rightBt addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBt];
    
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
}

- (void)timeAction{
    if(_num < 20){
        _num ++;
    }else{
        _num = 1;
    }
    [UIView animateWithDuration:0.1 animations:^{
        [_rightBt setImage:[UIImage imageNamed:[NSString stringWithFormat:@"Voice%d", _num]] forState:UIControlStateNormal];
    }];
}

- (void)rightAction{
    
}

- (void)_createTableView{
    _tableView = [[ChatTableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.chatData = [self getConversations];
    [self.view addSubview:_tableView];
    
    // 添加下拉刷新
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.tintColor = [UIColor redColor];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    
    _tableView.refreshControl = refreshControl;
}

- (void)stepPlay{
    NSError *error;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    // 加载文件，准备播放
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fade" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    [_player prepareToPlay];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tableView.chatData = [self getConversations];
    [_tableView reloadData];
    
    [_player play];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [_player stop];
}

- (void)refreshData{
    _tableView.chatData = [self getConversations];
    [_tableView reloadData];
    [_tableView.refreshControl endRefreshing];
}


// 统计未读消息数
-(void)setupUnreadMessageCount
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    if (unreadCount > 0) {
        self.navigationController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%i",(int)unreadCount];
    }else{
        self.navigationController.tabBarItem.badgeValue = nil;
    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}
// 刷新tableView
- (void)refreshChatTableView{
    _tableView.chatData = [self getConversations];
    [_tableView reloadData];
}

#pragma mark 获取内存中的会话数组
- (NSArray *)getConversations{
    NSMutableArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];   // 获取内存中的会话列表
    //    NSArray *conversationsdb = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];  // 获取所有会话，如果内存中不存在会从DB中加载
    [conversations enumerateObjectsUsingBlock:^(EMConversation *conversation, NSUInteger idx, BOOL * _Nonnull stop) {
        if(conversation.latestMessage == nil){
            [conversations removeObject:conversation];
        }
    }];
    
    return conversations;
}

#pragma mark 接收消息回调
/*!
 @method
 @brief 接收到一条及以上消息
 */
- (void)didReceiveMessages:(NSArray *)aMessages{
    
    
    _tableView.chatData = [self getConversations];
    [_tableView reloadData];
    
    [self setupUnreadMessageCount];
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
