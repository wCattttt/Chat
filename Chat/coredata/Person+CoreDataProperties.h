//
//  Person+CoreDataProperties.h
//  Chat
//
//  Created by 魏唯隆 on 16/7/19.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSNumber *pid;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *password;

@end

NS_ASSUME_NONNULL_END
