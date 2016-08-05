//
//  MeViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/20.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//
#define TCOLOR(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#import "MeViewController.h"
#import "SetViewController.h"

@interface MeViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@end

@implementation MeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = TCOLOR(14, 13, 19, 1);
    
    NSDictionary * attriBute = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    [self.navigationController.navigationBar setTitleTextAttributes:attriBute];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我";
    
    [self _initView];
    
}

- (void)_initView{
    self.tableView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);

    _usernameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:KUserName];
    _userImgView.layer.masksToBounds = YES;
    _userImgView.layer.cornerRadius = 8;
}

#pragma mark UItableView DataSource/Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            // 个人信息
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                    // 相册
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.delegate = self;
                    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                    break;
                case 1:
                    // 收藏
                    break;
                case 2:
                    // 钱包
                    break;
                case 3:
                    // 卡包
                    break;
                    
            }
        }
            break;
        case 2:
            // 表情
            break;
        case 3:
            // 设置
        {
            SetViewController *setVC = [[SetViewController alloc] init];
            setVC.hidesBottomBarWhenPushed = YES;
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
            [self.navigationController pushViewController:setVC animated:YES];
        }
            break;
    }
}

#pragma mark UIImagePickerController 协议方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *img = info[UIImagePickerControllerOriginalImage];
//    _userImgView.image = img;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[self imageByScalingAndCroppingForSize:self.tableView.frame.size withSourceImage:img]];
    [picker dismissViewControllerAnimated:YES completion:nil];
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
