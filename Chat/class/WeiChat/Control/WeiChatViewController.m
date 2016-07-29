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

@interface WeiChatViewController ()<EaseConversationListViewControllerDelegate, EaseConversationListViewControllerDataSource, EMChatManagerDelegate, AVAudioPlayerDelegate>
{
    ChatTableView *_tableView;
    AVAudioPlayer *_player;
    
    UIButton *_rightBt;
    int _num;
    NSTimer *_timer;
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
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
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
    
    _rightBt.selected = !_rightBt.selected;
    if(_rightBt.selected){
        [_timer invalidate];
        [_player stop];
    }else{
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        [_player play];
    }
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
    NSString *path = [[NSBundle mainBundle] pathForResource:@"fade" ofType:@"mp3"];
    NSURL *url = [[NSURL alloc]initFileURLWithPath:path];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    _player.delegate = self;
    //添加通知拔出耳机
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    //设置锁屏
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    MPMediaItemArtwork *artWork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"fade.jpg"]];
    
    NSDictionary *dic = @{MPMediaItemPropertyTitle:@"Fade",
                          MPMediaItemPropertyArtist:@"我也不知道是谁😂",
                          MPMediaItemPropertyArtwork:artWork
                          };
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dic];
    
    _player.numberOfLoops = -1; //  单曲循环
    [_player prepareToPlay];
//    [_player play];
}

-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
            [_player pause];
            [_timer invalidate];
        }
    }
}
#pragma mark - 接收方法的设置
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {  //判断是否为远程控制
        switch (event.subtype) {
            case  UIEventSubtypeRemoteControlPlay:
                if (![_player isPlaying]) {
                    [_player play];
                }
                break;
            case UIEventSubtypeRemoteControlPause:
                if ([_player isPlaying]) {
                    [_player pause];
                }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一首");
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一首 ");
                break;
            default:
                break;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _tableView.chatData = [self getConversations];
    [_tableView reloadData];
    // 注册响应后台控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
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

/*!
 *  当前登录账号在其它设备登录时会接收到该回调
 */
- (void)didLoginFromOtherDevice{
    [UIApplication sharedApplication].delegate.window.rootViewController = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
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
