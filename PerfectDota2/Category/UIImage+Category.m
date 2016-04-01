//
//  UIImage+Category.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/3/15.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)

/**
 *  根据颜色值返回image
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
