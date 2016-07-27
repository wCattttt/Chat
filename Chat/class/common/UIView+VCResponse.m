//
//  UIView+VCResponse.m
//  Chat
//
//  Created by 魏唯隆 on 16/7/26.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import "UIView+VCResponse.h"

@implementation UIView (VCResponse)
- (UIViewController *)viewController{
    UIResponder *next = self.nextResponder;
    do {
        if([next isKindOfClass:[UIViewController class]]){
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next != nil);
    
    return nil;
}
@end
