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
// 选择城市修改通知
extern NSString *const PDChooseCityChanged;
extern NSString *const chooseCityInfoKey;


/**
 *  存储
 */


/**
 *  Library/Preferences
 */
// 程序启动第一次不要执行didappear
extern NSString *const isFirstRefresh;
extern NSString *const topNewsDict;


/**
 *  Cafe
 */
// 上次选择的城市名
extern NSString *const lastChooseCityNameKey;
// 上次选择的Latitude
extern NSString *const lastChooseLatitudeKey;
// 上次选择的Longitude
extern NSString *const lastChooseLongitudeKey;
// 上次定位的城市名
extern NSString *const lastLocationCityNameKey;

/**
 *  Library/Caches
 */

@interface GlobeConst : NSObject

@end
