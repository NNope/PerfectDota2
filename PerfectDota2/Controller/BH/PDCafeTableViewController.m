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
#import "PDLocationTool.h"

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
    
    [self setupTableAndHeader];
    
    // 定位
    [PDLocationTool shareTocationTool].delegate = self;
    [[PDLocationTool shareTocationTool] getLocationCity];
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PDchooseCityChanged:) name:PDChooseCityChanged object:nil];
    
    // 得到对应的市辖区
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

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 比较城市是否相同
    if (![self.locationCity isEqualToString:self.chooseCity])
    {
        // 提示是否切换
        
    }
}

- (void)setupTableAndHeader
{
    // searchView
    PDCafeSearchView *cafeSearch = [[[NSBundle mainBundle] loadNibNamed:@"PDCafeSearchView" owner:nil options:nil] lastObject];
    cafeSearch.frame = CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, kSearchViewHeight);
    self.cafeSearchView = cafeSearch;
    self.cafeSearchView.delegate = self;
    [self updateBtnChooseCityTitle];

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

// 修改了选择的城市 通知
- (void)PDchooseCityChanged:(NSNotification *)noti
{
    self.chooseCity = noti.userInfo[chooseCityInfoKey];
    [[PDLocationTool shareTocationTool] saveChooseCity:self.chooseCity];
    [self updateBtnChooseCityTitle];
    
}
// 更新选择的城市按钮
- (void)updateBtnChooseCityTitle
{
    [self.cafeSearchView.btnCity setTitle:self.chooseCity forState:UIControlStateNormal];
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
    cityVc.chooseCity = self.chooseCity;
    [self.navigationController pushViewController:cityVc animated:YES];
}

#pragma mark - PDLocationToolDelegate
- (void)PDLocationToolGetLocationCity:(NSString *)cityName result:(BMKReverseGeoCodeResult *)result
{
    self.locationCity = cityName;
    [self updateBtnChooseCityTitle];
}


#pragma mark - Getter Setter
-(NSString *)chooseCity
{
    _chooseCity = [[PDLocationTool shareTocationTool] readLastChooseCity];
    return _chooseCity;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
