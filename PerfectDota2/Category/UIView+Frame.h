//
//  UIView+Frame.h
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)


/**
 *  添加渐变图层
 *
 *  @param cgColorArray 颜色数组 其余默认值
 */
- (void)addGradientLayerWithColors:(NSArray *)cgColorArray;

/**
 *  增加渐变图层
 *
 *  @param cgColorArray  颜色数组
 *  @param floatNumArray 区间分布
 *  @param startPoint    0,0左上角
 *  @param endPoint      1,1右下角
 */
- (void)addGradientLayerWithColors:(NSArray *)cgColorArray locations:(NSArray *)floatNumArray startPoint:(CGPoint )startPoint endPoint:(CGPoint)endPoint;




/**
 * *********************    Frame      *********************
 */
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
