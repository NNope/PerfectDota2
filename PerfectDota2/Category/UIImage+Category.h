//
//  UIImage+Category.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/3/15.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 *  根据颜色值返回image
 *
 *  @param color <#color description#>
 *
 *  @return <#return value description#>
 */
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
