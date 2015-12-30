//
//  GlobeConst.h
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//extern CGFloat const NavigationBarHeight;
/**
 *  通知
 */
// 程序启动刷新通知
extern NSString *const PDNewsAllRefresh;



/**
 *  存储
 */
// 程序启动第一次不要执行didappear
extern NSString *const isFirstRefresh;
extern NSString *const lastCityNameKey;

@interface GlobeConst : NSObject

@end
