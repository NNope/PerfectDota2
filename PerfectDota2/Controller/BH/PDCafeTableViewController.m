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
    
    [self setupTableAndSubViews];
    
    // 定位
    [PDLocationTool shareTocationTool].delegate = self;
    [[PDLocationTool shareTocationTool] getLocationCity];
    
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
   
}

- (void)setupTableAndSubViews
{
    // searchView
    PDCafeSearchView *cafeSearch = [[[NSBundle mainBundle] loadNibNamed:@"PDCafeSearchView" owner:nil options:nil] lastObject];
    cafeSearch.frame = CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, kSearchViewHeight);
    self.cafeSearchView = cafeSearch;
    self.cafeSearchView.delegate = self;
    [self.cafeSearchView updateBtnChooseCityTitle];

    [self.view addSubview:cafeSearch];
    
    // header
    PDCafeTabelHeaderView *head = [[[NSBundle mainBundle] loadNibNamed:@"PDCafeTabelHeaderView" owner:nil options:nil] lastObject];
    // 点击block
    [head setPDCafeTabelHeaderViewClickBlock:^(PDCafeTabelHeaderBtnType btnType) {
        if (btnType == PDCafeTabelHeaderBtnArea)
        {
            PDLog(@"全区");
        }
        else if (btnType == PDCafeTabelHeaderBtnDistance)
        {
            PDLog(@"距离");
        }
        else if (btnType == PDCafeTabelHeaderBtnScale)
        {
            PDLog(@"规模");
        }
    }];
    head.frame = CGRectMake(0, NAVIBARHEIGHT+kSearchViewHeight, SCREENWIDTH, kHeaderViewHeight);
    self.headView = head;
    [self.view addSubview:head];
    
    // areaView
    PDCafeAreaView *area = [PDCafeAreaView alloc] initWithFrame:<#(CGRect)#> areaList:<#(NSMutableArray *)#>
    
    // table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT + kSearchViewHeight + kHeaderViewHeight, SCREENWIDTH, SCREENHEIGHT - kSearchViewHeight - NAVIBARHEIGHT -kHeaderViewHeight)];
    self.cafeTableView = table;
    [self.view addSubview:self.cafeTableView];
    self.cafeTableView.delegate = self;
    self.cafeTableView.dataSource = self;

}

- (void)ChooseIsEqualToLocation
{
    // 比较城市是否相同
    if (![self.locationCity isEqualToString:self.chooseCity] && self.locationCity)
    {
        // 提示是否切换
        PDLog(@"当前选择的城市和定位不一致，是否切换？");
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前选择的城市和定位不一致，是否切换？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1  = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        UIAlertAction *action2  = [UIAlertAction actionWithTitle:@"切换" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [[PDLocationTool shareTocationTool] saveChooseCity:self.locationCity];
            [self.cafeSearchView updateBtnChooseCityTitle];
        }];
        [alert addAction:action2];
        
        
        [self presentViewController:alert animated:YES completion:nil];
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
    cityVc.chooseCity = self.chooseCity;
    [self.navigationController pushViewController:cityVc animated:YES];
}

#pragma mark - PDLocationToolDelegate
- (void)PDLocationToolGetLocationCity:(NSString *)cityName result:(BMKReverseGeoCodeResult *)result
{
    self.locationCity = cityName;
    [self.cafeSearchView updateBtnChooseCityTitle];
    
    // 比较城市是否相同
    [self ChooseIsEqualToLocation];
}


#pragma mark - Getter Setter
-(NSString *)chooseCity
{
    _chooseCity = [[PDLocationTool shareTocationTool] readLastChooseCity];
    return _chooseCity;
}


@end
