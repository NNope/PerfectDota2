//
//  PDSetItem.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/23.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDSetItem : NSObject

/** 标题 */
@property (nonatomic, copy) NSString *title;
/** 子标题 */
@property (nonatomic, copy) NSString *subtitle;
/** 左边的标记 */
@property (nonatomic, assign) BOOL isBadge;
/**
 *  子标题是否靠左
 */
@property (nonatomic, assign) BOOL isLeftSub;

/** 点击这行cell，需要调转到哪个控制器 */
@property (nonatomic, assign) Class destVcClass;

/** 封装点击这行cell想做的事情 */
@property (nonatomic, copy) void (^operation)(id viewController);

+ (instancetype)itemWithTitle:(NSString *)title;
@end
