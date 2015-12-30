//
//  PDLocationTool.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDLocationTool.h"

static PDLocationTool *tool;

@interface PDLocationTool()
{
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}
@end

@implementation PDLocationTool

+ (void)getLocationCity
{
//    _locService
    
}

- (void)startLocationService
{
    // 定位
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
}
@end
