//
//  PDLocationTool.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@protocol PDLocationToolDelegate <NSObject>

@optional
/**
 *  返回定位结果
 *  一般只需用这个
 */
- (void)PDLocationToolGetLocationCity:(NSString *)cityName result:(BMKReverseGeoCodeResult *)result;
/**
 *  定位结束后
 */
- (void)PDLocationToolDidUpdateLocation:(BMKUserLocation *)userLocation;
/**
 *  反向地理编码后
 */
- (void)PDLocationToolGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;

@end

@interface PDLocationTool : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, assign) id<PDLocationToolDelegate> delegate;

@property (nonatomic, copy) NSString *locationCity;
// 纬度
@property (nonatomic, assign) CGFloat Latitude;
// 经度
@property (nonatomic, assign) CGFloat Longitude;

+ (instancetype)shareTocationTool;

/**
 *  读取上次选择的城市
 */
- (NSString *)readLastChooseCity;
/**
 *  读取上次定位的城市
 */
- (NSString *)readLastLocationCity;
/**
 *  读取历史城市
 */
- (NSMutableArray *)readHistoryCity;

/**
 *  保存新的选择城市
 *
 */
- (void)saveChooseCity:(NSString *)chooseCityName;

/**
 *  定位最新的城市
 */
- (void)getLocationCity;

@end
