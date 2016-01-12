//
//  GlobeConst.m
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "GlobeConst.h"

/**
 *  通知
 */
// 程序启动刷新通知
NSString *const PDNewsAllRefresh = @"PDNewsAllRefresh";
NSString *const PDChooseCityChanged = @"PDChooseCityChanged";
NSString *const chooseCityInfoKey = @"chooseCityInfoKey";

/**
 *  存储
 */

// 程序启动第一次不要执行didappear
NSString *const isFirstRefresh = @"isFirstRefresh";
// 上次选择的城市名
NSString *const lastChooseCityNameKey = @"lastChooseCityNameKey";
// 上次选择的Latitude
NSString *const lastChooseLatitudeKey = @"lastChooseLatitudeKey";
// 上次选择的Longitude
NSString *const lastChooseLongitudeKey = @"lastChooseLongitudeKey";
// 上次定位的城市名
NSString *const lastLocationCityNameKey = @"lastLocationCityNameKey";


@implementation GlobeConst

@end
