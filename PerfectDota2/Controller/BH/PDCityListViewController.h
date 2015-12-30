//
//  PDCityListViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDBaseViewController.h"
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface PDCityListViewController : PDBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}


@property (nonatomic, copy) NSString *locationCity;
@property (nonatomic, weak) UITableView *cityTableView;
// 纬度
@property (nonatomic, assign) CGFloat Latitude;
// 经度
@property (nonatomic, assign) CGFloat Longitude;

@end
