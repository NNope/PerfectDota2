//
//  UIView+Frame.h
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)
- (void)setX:(CGFloat)x;

- (CGFloat)x;

- (void)setY:(CGFloat)y;

- (CGFloat)y;

- (void)setCenterX:(CGFloat)centerX;

- (CGFloat)centerX;

- (void)setCenterY:(CGFloat)centerY;

- (CGFloat)centerY;

- (void)setWidth:(CGFloat)width;

- (CGFloat)width;

- (void)setHeight:(CGFloat)height;

- (CGFloat)height;

- (void)setSize:(CGSize)size;

- (CGSize)size;
@end
