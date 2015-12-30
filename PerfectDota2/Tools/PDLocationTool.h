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

@interface PDLocationTool : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
}

+ (void)getLocationCity;

@end
