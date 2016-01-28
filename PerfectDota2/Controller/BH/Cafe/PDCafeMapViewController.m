//
//  PDCafeMapViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/22.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDCafeMapViewController.h"
#import "PDLocationTool.h"
#define MapToolBarHeight 60

@interface PDCafeMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>
{
    
    BMKLocationService* _locService;
}

- (IBAction)btnLocationClick:(id)sender;
@end

@implementation PDCafeMapViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"网吧路线及周边地图";
//    self.view.backgroundColor = PDGrayColor;
    self.view.size = [UIScreen mainScreen].bounds.size;
    
    // 修改按钮
    self.btnLocation.layer.cornerRadius = 5;
    self.btnLocation.clipsToBounds = YES;
    [self setUpAnnotation];
    
    _locService = [[BMKLocationService alloc]init];

}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    _locService.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    _locService.delegate = nil;
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)setUpAnnotation 
{
    // 创建网吧大头针
    BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.cafeModel.latitude, self.cafeModel.longitude};
    item.coordinate = pt;
    item.title = self.cafeModel.cafe_name;
    [_mapView addAnnotation:item];
    
    [_mapView selectAnnotation:item animated:YES];
    // 移动到目标位置
    _mapView.centerCoordinate = pt;
    _mapView.zoomLevel = 16;

}


// 显示定位区域 显示自身区域
- (IBAction)btnLocationClick:(id)sender {
    // 定位到了后 不要再定了
    if (!self.userLocation)
    {
        [_locService startUserLocationService];
        _mapView.showsUserLocation = NO;//先关闭显示的定位图层
        _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
        _mapView.showsUserLocation = YES;//显示定位图层
    }
    else
    _mapView.centerCoordinate = self.userLocation.location.coordinate;

}


#pragma mark - BMKLocationServiceDelegate
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    if (userLocation)
    {
        self.userLocation = userLocation;
        [_locService stopUserLocationService];
    }
    else
    {
        PDLog(@"PDCafeMapViewController------定位失败");
    }
    [_mapView updateLocationData:userLocation];
    _mapView.centerCoordinate = self.userLocation.location.coordinate;
}

@end
