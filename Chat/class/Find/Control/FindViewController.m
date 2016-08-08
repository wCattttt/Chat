//
//  FindViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/20.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//
#define TCOLOR(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#import "FindViewController.h"

#import "GameViewController.h"
#import "SweepViewController.h"
#import "RockViewController.h"

@interface FindViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    __weak IBOutlet UIView *_dotView;

}
@end

@implementation FindViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = TCOLOR(14, 13, 19, 1);
    
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    [self.navigationController.navigationBar setTitleTextAttributes:attriBute];
    
    _dotView.layer.masksToBounds = YES;
    _dotView.layer.cornerRadius = 5;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
    
    self.title = @"发现";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            GameViewController *gameVC = [[GameViewController alloc] init];
            gameVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:gameVC animated:YES];
        }
            break;
            
        case 1:
        {
            if(indexPath.row == 0){
                SweepViewController *sweepVC = [[SweepViewController alloc] init];
                sweepVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:sweepVC animated:YES];
            }if(indexPath.row == 1){
                RockViewController *rockVC = [[RockViewController alloc] init];
                rockVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:rockVC animated:YES];
            }
        }
            break;
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
