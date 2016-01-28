//
//  PDCafeMapViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/22.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDCafeModel.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface PDCafeMapViewController : PDBaseViewController

@property (nonatomic, strong) PDCafeModel *cafeModel;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
@property (nonatomic, strong) BMKUserLocation *userLocation;

@end
