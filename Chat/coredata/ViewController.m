//
//  ViewController.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/19.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Person.h"

#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *_messageLabel;
    
    UITableView *_tableView;
    
    AppDelegate *appDelegate;
    NSMutableArray *personData;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    personData = @[].mutableCopy;
    
    appDelegate = [UIApplication sharedApplication].delegate;
    
    [self createButton];
    
    [self createTableView];
    
    [self createMessageLabel];
    
}


- (void)createButton{
    NSArray *array = @[@"增", @"删", @"改", @"查"];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, 50 * (idx + 1), [UIScreen mainScreen].bounds.size.width - 16, 45)];
        button.backgroundColor = [UIColor orangeColor];
        button.tag = idx;
        [button setTitle:obj forState:UIControlStateNormal];
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
    }];
}
- (void)click:(UIButton *)button{
    switch (button.tag) {
        case 0:
            [self coreDataAdd];
            break;
        case 1:
            [self coreDataDelete];
            break;
        case 2:
            [self coreDataUpdate];
            break;
        case 3:
            [self coreDataSelect];
            break;
            
    }
}

- (void)createTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, KScreenWidth, KScreenHeight - 300) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (void)createMessageLabel{
    // 创建显示信息的Label
    _messageLabel = [[UILabel alloc] initWithFrame:[UIApplication sharedApplication].statusBarFrame];
    _messageLabel.backgroundColor = [UIColor blackColor];
    _messageLabel.textColor = [UIColor whiteColor];
    _messageLabel.textAlignment = NSTextAlignmentCenter;
    _messageLabel.window.windowLevel = UIWindowLevelStatusBar + 1.0f;
    _messageLabel.hidden = YES;
    [self.view addSubview:_messageLabel];
}
- (void)showStatusMessage:(NSString *)message{
//    [UIApplication sharedApplication].statusBarHidden = YES;
    _messageLabel.hidden = NO;
    _messageLabel.alpha = 1.0f;
    _messageLabel.text = @"";
    
    CGSize totalSize = _messageLabel.frame.size;
    _messageLabel.frame = (CGRect){ _messageLabel.frame.origin, 0, totalSize.height };
    
    [UIView animateWithDuration:0.5f animations:^{
        _messageLabel.frame = (CGRect){ _messageLabel.frame.origin, totalSize };
    } completion:^(BOOL finished){
        _messageLabel.text = message;
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timeAction) userInfo:nil repeats:NO];
}
- (void)timeAction{
    _messageLabel.hidden = YES;
//    [UIApplication sharedApplication].statusBarHidden = NO;
}

#pragma mark 数据库操作
// 增
- (void)coreDataAdd{
    // 初始化一个Person对象
    Person *person = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    person.pid = [NSNumber numberWithInt:1];
    person.name = @"zhangsan";
    person.age = [NSNumber numberWithInt:22];
    person.password = @"123";
    
    NSError *error;
    [appDelegate.persistentContainer.viewContext save: &error];
    if(error){
        [self showStatusMessage:@"新增失败"];
        NSLog(@"==== %@", error);
    }else{
        [self showStatusMessage:@"新增成功"];
    }
    
    [self coreDataSelect];
}
// 删
- (void)coreDataDelete{
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:personEntity];
    
    // 设置检索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", @"zhangsan"];
    [request setPredicate:predicate];
    // 查询满足条件的person
    NSArray *persons = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    if(persons.count){
        [persons enumerateObjectsUsingBlock:^(Person *person, NSUInteger idx, BOOL * _Nonnull stop) {
            // 删除
            [appDelegate.persistentContainer.viewContext deleteObject:person];
        }];
        
        // 保存
        [appDelegate.persistentContainer.viewContext save:nil];
        [self showStatusMessage:@"删除完成"];
    }else{
        [self showStatusMessage:@"没有满足条件的数据"];
    }
    [self coreDataSelect];
    
}
// 改
- (void)coreDataUpdate{
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:personEntity];
    
    // 设置检索条件
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", @"zhangsan"];
    [request setPredicate:predicate];
    // 查询满足条件的person
    NSArray *persons = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
    if(persons.count){
        [persons enumerateObjectsUsingBlock:^(Person *person, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@", [person objectID]);
            // 改
            person.name = @"改";
        }];
        
        // 保存
        [appDelegate.persistentContainer.viewContext save:nil];
        [self showStatusMessage:@"删除完成"];
    }else{
        [self showStatusMessage:@"没有满足条件的数据"];
    }
    [self coreDataSelect];
}
// 查
- (void)coreDataSelect{
    // 读取类信息
    NSEntityDescription *personEntity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    // 建立请求
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:personEntity];
    NSError *error;
    personData = [appDelegate.persistentContainer.viewContext executeFetchRequest:request error:&error].mutableCopy;
    if(error){
        [self showStatusMessage:@"查询失败"];
        NSLog(@"==== %@", error);
    }else{
        [self showStatusMessage:@"查询成功"];
        [_tableView reloadData];
    }
}


#pragma mark UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return personData.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if(indexPath.row < personData.count){
        Person *person = personData[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"id:%@, name:%@, age:%@, password:%@", person.pid, person.name, person.age, person.password];
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
