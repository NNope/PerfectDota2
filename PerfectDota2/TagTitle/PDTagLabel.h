
//
//  TTTagLabel.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/3.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDTagLabel : UILabel
/**
 *  默认是0.7，这个值用来控制剩下0.3的百分比，最大就是0.3
 */
@property (nonatomic, assign) CGFloat scalePercent;
@end
