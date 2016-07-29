//
//  CreateGroupModel.h
//  Chat
//
//  Created by 魏唯隆 on 16/7/29.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import <Foundation/Foundation.h>
@class EMGroupOptions;

@interface CreateGroupModel : NSObject

@property (nonatomic, copy) NSString *groupTitle;
@property (nonatomic, copy) NSString *groupDescription;
@property (nonatomic, copy) NSString *groupMessage;
@property (nonatomic, retain) EMGroupOptions *setting;

@end
