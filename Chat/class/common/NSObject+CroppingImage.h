//
//  NSObject+CroppingImage.h
//  Chat
//
//  Created by 魏唯隆 on 16/7/28.
//  Copyright © 2016年 魏唯隆. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CroppingImage)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)img;
@end
