//
//  MainViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/20.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "MainViewController.h"
#import "EMSDK.h"

@interface MainViewController ()<EMContactManagerDelegate>
{

}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _initVC];
    
    //注册好友回调
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    EMError *error = nil;
    EMPushOptions *options = [[EMClient sharedClient] getPushOptionsFromServerWithError:&error];
    [[EMClient sharedClient] setApnsNickname:@"昵称"];
    NSArray *ignoredGroupIds = [[EMClient sharedClient].groupManager getAllIgnoredGroupIds];
}

- (void)_initVC{
    
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.tabBarController.tabBar.tintColor =[UIColor redColor];
        // ios10新特性，修改未选中的颜色
        obj.tabBarController.tabBar.unselectedItemTintColor =[UIColor orangeColor];
        if(idx == 0){
            obj.tabBarItem.badgeColor =[UIColor greenColor];
        }
    }];

}




/*!
 *  用户A发送加用户B为好友的申请，用户B会收到这个回调
 *
 *  @param aUsername   用户名
 *  @param aMessage    附属信息
 */
- (void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                       message:(NSString *)aMessage{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@添加好友请求", aUsername] message:aMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *refusedAction = [UIAlertAction actionWithTitle:@"不接受" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager declineInvitationForUsername:aUsername];
        if (!error) {
            [self showHint:@"已拒绝"];
        }
    }];
    UIAlertAction *agreedAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
        if (!error) {
            [self showHint:@"已接受"];
        }
    }];
    [alertController addAction:refusedAction];
    [alertController addAction:agreedAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B同意后，用户A会收到这个回调
 */
- (void)didReceiveAgreedFromUsername:(NSString *)aUsername{
    [self showHint:[NSString stringWithFormat:@"%@已同意您的请求", aUsername]];
}

/*!
 @method
 @brief 用户A发送加用户B为好友的申请，用户B拒绝后，用户A会收到这个回调
 */
- (void)didReceiveDeclinedFromUsername:(NSString *)aUsername{
    [self showHint:[NSString stringWithFormat:@"%@拒绝了您的请求", aUsername]];
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
