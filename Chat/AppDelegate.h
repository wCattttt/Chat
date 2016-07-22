//
//  AppDelegate.h
//  Chat
//
//  Created by 魏唯隆 on 16/7/19.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;


- (void)saveContext;


@end

