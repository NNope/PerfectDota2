//
//  TTTagLabel.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/3.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDTagLabel.h"

@implementation PDTagLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        // 默认字体大小 默认是0的缩放值
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:18];
        self.scalePercent = 0;
        
    }
    return self;
}

/**
 *  默认是0.7，这个值用来控制剩下0.3的百分比，最大就是0.3
 */
-(void)setScalePercent:(CGFloat)scalePercent
{
    // 0-1
    _scalePercent = scalePercent;
    // 红色1 0 0 白色1 1 1
    self.textColor = [UIColor colorWithRed:1.0 green:1-_scalePercent blue:1-_scalePercent alpha:1];
    
    CGFloat minScale = 0.9; // 默认是0.7
    // 最大不超过1                   0.3*?
    CGFloat trueScale = minScale + (1-minScale)*scalePercent;
    self.transform = CGAffineTransformMakeScale(trueScale, trueScale);
}

@end
