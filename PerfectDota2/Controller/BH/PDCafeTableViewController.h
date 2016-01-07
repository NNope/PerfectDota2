//
//  PDCafeTableViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/28.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDCafeSearchView.h"
#import "PDCafeTabelHeaderView.h"
#import "PDLocationTool.h"
#import "PDCafeAreaView.h"

@interface PDCafeTableViewController : PDBaseViewController<UITableViewDataSource,UITableViewDelegate,PDCafeSearchViewDelegate,PDLocationToolDelegate>
{
    
    BMKLocationService* _locService;
    BMKGeoCodeSearch* _geocodesearch;
}

@property (nonatomic, weak) UITableView *cafeTableView;
@property (nonatomic, weak) PDCafeSearchView *cafeSearchView;
@property (nonatomic, weak) PDCafeTabelHeaderView *headView;
@property (nonatomic, weak) PDCafeAreaView *areaView;
@property (nonatomic, weak) UIView *bgAreaView;

/**
 *  当前定位城市名 - 区别于按钮当前显示名，如果不同 提示切换
 */
@property (nonatomic, copy) NSString *locationCity;
/**
 *  当前选择的城市 - 可能在城市列表更改后回来的
 */
@property (nonatomic, copy) NSString *chooseCity;
/**
 *  全部省份列表
 */
@property (nonatomic, strong) NSMutableArray *provinceList;
/**
 *  市辖区列表
 */
@property (nonatomic, strong) NSArray *citybaseList;

// 纬度
@property (nonatomic, assign) CGFloat Latitude;
// 经度
@property (nonatomic, assign) CGFloat Longitude;
@end
