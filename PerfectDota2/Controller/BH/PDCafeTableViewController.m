//
//  PDCafeTableViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/28.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDCafeTableViewController.h"
#import "PDCityModel.h"
#import "PDCityListViewController.h"
#import "PDProvinceModel.h"

static CGFloat const kSearchViewHeight = 42;
static CGFloat const kHeaderViewHeight = 36;

@implementation PDCafeTableViewController

/**
 *  进来的时候 利用百度定位，得到当前的城市名称，然后到读取的provinceList去匹配，得到下属的市辖区，显示自己的cityname
    不过去数组里的数组里取匹配有点慢，能不能先通过citylist，得到parentID 去直接找
 */
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.titleView.title = @"特权网吧";
    self.titleView.titleType = PDTitleTypeInfoAndShare;
    self.view.backgroundColor = PDGrayColor;
    
    [self startLocationService];
    
    [self setupTableAndHeader];

    self.provinceList = [PDProvinceModel mj_objectArrayWithFilename:@"dotacityData.plist"];
    for (PDProvinceModel *provice in self.provinceList)
    {
        // 每个省份
        for (PDCityModel *city in provice.citylist)
        {
            if ([city.name isEqualToString:@"杭州"])
            {
                // 是杭州里的区
                self.citybaseList = city.arealist;
            }
        }
    }
}

- (void)setupTableAndHeader
{
    // searchView
    PDCafeSearchView *cafeSearch = [[[NSBundle mainBundle] loadNibNamed:@"PDCafeSearchView" owner:nil options:nil] lastObject];
    cafeSearch.frame = CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, kSearchViewHeight);
    self.cafeSearchView = cafeSearch;
    self.cafeSearchView.delegate = self;
    [self.view addSubview:cafeSearch];
    
    // header
    PDCafeTabelHeaderView *head = [[[NSBundle mainBundle] loadNibNamed:@"PDCafeTabelHeaderView" owner:nil options:nil] lastObject];
    head.frame = CGRectMake(0, NAVIBARHEIGHT+kSearchViewHeight, SCREENWIDTH, kHeaderViewHeight);
    self.headView = head;
    [self.view addSubview:head];
    
    // table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT + kSearchViewHeight + kHeaderViewHeight, SCREENWIDTH, SCREENHEIGHT - kSearchViewHeight - NAVIBARHEIGHT -kHeaderViewHeight)];
    self.cafeTableView = table;
    [self.view addSubview:self.cafeTableView];
    self.cafeTableView.delegate = self;
    self.cafeTableView.dataSource = self;
    self.cafeTableView.backgroundColor = PDRedColor;

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

/**
 *  反地理编码 得到城市
 */
- (void)reverseGeocode
{
    //初始化检索对象
    _geocodesearch =[[BMKGeoCodeSearch alloc]init];
    _geocodesearch.delegate = self;
    //发起反向地理编码检索
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){self.Latitude, self.Longitude};
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[
                                                            BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = pt;
    BOOL flag = [_geocodesearch reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 单元格复用
    static NSString *sectionsTableIdentifier = @"sectionsTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sectionsTableIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:sectionsTableIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITableViewDelegate

#pragma mark - PDCafeSearchViewDelegate
-(void)pdCafeSearchView:(PDCafeSearchView *)searchview clickCityButton:(UIButton *)citybtn
{
    PDCityListViewController *cityVc = [[PDCityListViewController alloc] init];
    cityVc.locationCity = self.locationCity;
    [self.navigationController pushViewController:cityVc animated:YES];
}

#pragma mark - BMKGeoCodeSearchDelegate
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR)
    {
        self.locationCity = [result.addressDetail.city substringToIndex:2];
        [self.cafeSearchView.btnCity setTitle:self.locationCity forState:UIControlStateNormal];
        // 本地存一下 下次优先显示
        [[NSUserDefaults standardUserDefaults]setObject:self.locationCity forKey:lastCityNameKey];
        [[NSUserDefaults standardUserDefaults] synchronize]; // 同步
    }
    else
    {
        PDLog(@"抱歉，未找到结果");
    }
}
#pragma mark - BMKLocationServiceDelegate
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    if (userLocation.location.coordinate.latitude)
    {
        PDLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
        
        [_locService stopUserLocationService];
        
        // 有了经纬度 可以反地理编码
        self.Latitude = userLocation.location.coordinate.latitude;
        self.Longitude = userLocation.location.coordinate.longitude;
        [self reverseGeocode];
    }
}



@end
