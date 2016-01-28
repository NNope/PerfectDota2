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
#import "PDCafeDetailViewController.h"
#import "PDProvinceModel.h"
#import "PDLocationTool.h"
#import "PDCafeModel.h"
#import "NSString+Json.h"
#import "PDCafeCell.h"

static CGFloat const kSearchViewHeight = 42;
static CGFloat const kHeaderViewHeight = 36;
static  NSString *const PDCafeCellID = @"PDCafeCellID";

@implementation PDCafeTableViewController

/**
 *  进来的时候 利用百度定位，得到当前的城市名称，然后到读取的provinceList去匹配，得到下属的市辖区，显示自己的cityname
    不过去数组里的数组里取匹配有点慢，能不能先通过citylist，得到parentID 去直接找
 */
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpconfigure];
    [self setupTableAndSubViews];
    
    // 定位
    [PDLocationTool shareTocationTool].delegate = self;
    [[PDLocationTool shareTocationTool] getLocationCity];
    
    
    // 监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PDchooseCityChanged:) name:PDChooseCityChanged object:nil];
    
    [self.cafeTableView registerNib:[UINib nibWithNibName:@"PDCafeCell" bundle:nil] forCellReuseIdentifier:PDCafeCellID];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.firstRefresh)
    {
        [self.cafeTableView headerBeginRefreshing];
    }
}

- (void)setUpconfigure
{
    self.titleView.title = @"特权网吧";
    self.titleView.titleType = PDTitleTypeInfoAndShare;
    self.chooseArea = @"全区";
    self.firstRefresh = YES;
    self.view.backgroundColor = PDGrayColor;
    
    // 得到对应的市辖区
    self.provinceList = [PDProvinceModel mj_objectArrayWithFilename:@"dotacityData.plist"];
}
- (void)setupTableAndSubViews
{
    // table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT + kSearchViewHeight + kHeaderViewHeight, SCREENWIDTH, SCREENHEIGHT - kSearchViewHeight - NAVIBARHEIGHT -kHeaderViewHeight)];
    self.cafeTableView = table;
    [self.view addSubview:self.cafeTableView];
    self.cafeTableView.delegate = self;
    self.cafeTableView.dataSource = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.cafeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.cafeTableView.backgroundColor = PDGrayColor;
    // 动态高度
    self.cafeTableView.estimatedRowHeight = 100;  //  随便设个不那么离谱的值
    self.cafeTableView.rowHeight = UITableViewAutomaticDimension;

    
    // 刷新控件
    [self.cafeTableView addHeaderWithTarget:self action:@selector(refresh)];
    [self.cafeTableView addFooterWithTarget:self action:@selector(loadMoreNews)];
    
    // areaView 第一次是没有地区列表的
    if (self.cityAreaList)
    {
        [self setUpAreaView];
        [self setAreaButtonBlock];
    }
    
    // searchView
    PDCafeSearchView *cafeSearch = [[[NSBundle mainBundle] loadNibNamed:@"PDCafeSearchView" owner:nil options:nil] lastObject];
    cafeSearch.frame = CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, kSearchViewHeight);
    self.cafeSearchView = cafeSearch;
    self.cafeSearchView.delegate = self;
    [self.cafeSearchView updateBtnChooseCityTitle];

    [self.view addSubview:cafeSearch];

    // header
    PDCafeTabelHeaderView *head = [[[NSBundle mainBundle] loadNibNamed:@"PDCafeTabelHeaderView" owner:nil options:nil] lastObject];
    
    head.frame = CGRectMake(0, NAVIBARHEIGHT+kSearchViewHeight, SCREENWIDTH, kHeaderViewHeight);
    self.headView = head;
    [self.view addSubview:head];
    
    [self setHeaderButtonBlock];
    

}


- (void)setUpAreaView
{
    
    PDCafeAreaView *area = [[PDCafeAreaView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT+kSearchViewHeight+kHeaderViewHeight, 0, 0) areaList:self.cityAreaList];
    area.hidden = YES;
    [self.view insertSubview:area aboveSubview:self.cafeTableView];
    self.areaView = area;
    self.areaView.y -= self.areaView.height;
}

- (void)setAreaButtonBlock
{
    [self.areaView setAreaBlock:^(PDHistoryCityButton *btn) {
        PDLog(@"选择了%@",btn.currentTitle);
        self.chooseArea = btn.currentTitle;
        // 让全区按钮变换状态
        [self.headView resumeAreaBtn];
        // 此处要判断市辖区的选中状态 因为无论如何都要执行block，用来执行上面的事情，但是已选的时候不用请求
        if (!btn.selected && self.beginPost)
        {
            [self.cafeTableView headerBeginRefreshing];
        }
        
    }];

}
- (void)setHeaderButtonBlock
{
    // 点击headerView - block
    [self.headView setPDCafeTabelHeaderViewClickBlock:^(PDCafeTabelHeaderBtnType btnType, id btn) {
        
        if (btnType == PDCafeTabelHeaderBtnArea)
        {
            UIButton *Btn = (UIButton *)btn;
            PDLog(@"当前选择的市辖区 - %@",Btn.currentTitle);
            // show areaView
            self.areaView.hidden = NO;
            if (Btn.selected) //收回
            {
                [self.areaView hideAreaView];
            }
            else // 展开
            {
                [self.areaView showAreaView];
            }
            
            Btn.selected = !Btn.selected;
        }
        else if (btnType == PDCafeTabelHeaderBtnDistance)
        {
            PDLog(@"距离");
            self.order_by = @"distance";
            if (self.beginPost)
            {
                [self.cafeTableView headerBeginRefreshing];
            }
        }
        else if (btnType == PDCafeTabelHeaderBtnScale)
        {
            PDLog(@"规模");
            self.order_by = @"count";
            if (self.beginPost)
            {
                [self.cafeTableView headerBeginRefreshing];
            }
        }
    }];

}
#pragma mark - private
// 比较城市是否相同
- (void)ChooseIsEqualToLocation
{
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
            [self.cafeTableView headerBeginRefreshing];
        }];
        [alert addAction:action2];
        
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

// 占位图
- (void)showOrHidePlaceholderView
{
    if (self.cafeList.count == 0)
    {
        if (self.placeholderView)
        {
            self.placeholderView.hidden = NO;
        }
        else
        {
            UIView *place = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.cafeTableView.width, self.cafeTableView.height)];
            place.backgroundColor = [UIColor whiteColor];
            [self.cafeTableView addSubview:place];
            self.placeholderView = place;
            // 图
            UIImageView *imgPlace = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_comment_icon"]];
            imgPlace.center = self.placeholderView.center;
            imgPlace.centerY -= 70;
            [self.placeholderView addSubview:imgPlace];
            // label
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, imgPlace.centerY + (imgPlace.size.height/2) + 15, SCREENWIDTH, 20)];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = @"没有找到该区域相关特权网吧";
            lbl.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
            lbl.font = [UIFont systemFontOfSize:14];
            [self.placeholderView addSubview:lbl];
            
        }
    }
    else // 如果查到了
    {
        if (self.placeholderView)
        {
            self.placeholderView.hidden = YES;
        }
    }
    
}
#pragma mark - 通知
// 修改了选择的城市 通知
- (void)PDchooseCityChanged:(NSNotification *)noti
{
    
    [self.areaView removeFromSuperview];
    self.areaView = nil;
    
    // 重新创建areaView
    [self setUpAreaView];
    // 刚好回来选择下 全区  请求下
    [self setAreaButtonBlock];
}

#pragma mark - 请求
// 下拉刷新用
- (void)refresh
{
    self.firstRefresh = NO;
    if (self.beginPost)
    {
        self.currentpage = 1;
        // 请求网吧
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.order_by forKey:@"order_by"];
        [param setObject:self.chooseCity forKey:@"city"];
        if ([self.chooseArea isEqualToString:@"全区"])
        {
            [param setObject:@"" forKey:@"district"];
        }
        else
        {
            [param setObject:self.chooseArea forKey:@"district"];
        }
        
        NSString *lon = [NSString stringWithFormat:@"%f",self.Longitude];
        NSString *la = [NSString stringWithFormat:@"%f",self.Latitude];
        [param setObject:lon forKey:@"longitude"];
        [param setObject:la forKey:@"latitude"];
        [param setObject:@"20" forKey:@"pageSize"];
        [param setObject:[NSString stringWithFormat:@"%ld",self.currentpage] forKey:@"page"];
        [param setObject:@"38818" forKey:@"r"];
        [param setObject:@"1452512146" forKey:@"t"];
        [param setObject:@"16042a8129931c233fef4fd70c17" forKey:@"v"];
        
        NSString *cafeUrl = [NSString stringWithFormat:@"http://act.dota2.com.cn/api/getcafes"];
        PDLog(@"%@",param);
        
        AFHTTPSessionManager *mr = [[AFHTTPSessionManager alloc] init];
        // 置空 从NSdata
        mr.responseSerializer = [AFHTTPResponseSerializer serializer];
        mr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
        [mr POST:cafeUrl parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *strData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSString parseJSONStringToNSDictionary:strData];
            PDLog(@"分页信息----totalRecords-%@  currentPage-%@  totalPages-%@",dict[@"totalRecords"],dict[@"currentPage"],dict[@"totalPages"]);
            self.cafeList = [PDCafeModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
            // 如果没有查到 显示占位图
            [self showOrHidePlaceholderView];
                        // 记录当前的请求的页码
            //        self.currentpage = [dict[@"currentPage"] integerValue];
            self.totalPages = [dict[@"totalPages"] integerValue];
            [self.cafeTableView headerEndRefreshing];
            [self.cafeTableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.cafeTableView headerEndRefreshing];
            PDLog(@"%@",error);
        }];

    }
    
}

- (void)loadMoreNews
{
    // 加载更多
    if (self.currentpage < self.totalPages)
    {
        self.currentpage += 1;
        // 请求网吧
        NSMutableDictionary *param = [NSMutableDictionary dictionary];
        [param setObject:self.order_by forKey:@"order_by"];
        [param setObject:self.chooseCity forKey:@"city"];
        if ([self.chooseArea isEqualToString:@"全区"])
        {
            [param setObject:@"" forKey:@"district"];
        }
        else
        {
            [param setObject:self.chooseArea forKey:@"district"];
        }
        
        NSString *lon = [NSString stringWithFormat:@"%f",self.Longitude];
        NSString *la = [NSString stringWithFormat:@"%f",self.Latitude];
        [param setObject:lon forKey:@"longitude"];
        [param setObject:la forKey:@"latitude"];
        [param setObject:@"20" forKey:@"pageSize"];
        [param setObject:[NSString stringWithFormat:@"%ld",self.currentpage] forKey:@"page"];
        [param setObject:@"38818" forKey:@"r"];
        [param setObject:@"1452512146" forKey:@"t"];
        [param setObject:@"16042a8129931c233fef4fd70c17" forKey:@"v"];
        
        NSString *cafeUrl = [NSString stringWithFormat:@"http://act.dota2.com.cn/api/getcafes"];
        PDLog(@"%@",param);
        
        AFHTTPSessionManager *mr = [[AFHTTPSessionManager alloc] init];
        // 置空 从NSdata
        mr.responseSerializer = [AFHTTPResponseSerializer serializer];
        mr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
        [mr POST:cafeUrl parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
            
            NSString *strData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary *dict = [NSString parseJSONStringToNSDictionary:strData];
            PDLog(@"分页信息----totalRecords-%@  currentPage-%@  totalPages-%@",dict[@"totalRecords"],dict[@"currentPage"],dict[@"totalPages"]);
            NSArray *newCafes = [PDCafeModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
            
            // 将新数据插入到旧数据的最前面
            //        NSRange range = NSMakeRange(0, newCafes.count);
            //        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
            //        [self.cafeList insertObjects:newCafes atIndexes:indexSet];
            
            // 加到后面
            [self.cafeList addObjectsFromArray:newCafes];
            // 记录当前的请求的页码
            self.totalPages = [dict[@"totalPages"] integerValue];
            
            [self.cafeTableView footerEndRefreshing];
            [self.cafeTableView reloadData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self.cafeTableView footerEndRefreshing];
            PDLog(@"%@",error);
        }];

    }
    else
    {
        // 没有更多了
        [self.cafeTableView tableViewNoMore];
    }

}




#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cafeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 单元格复用
    PDCafeCell *cell = [tableView dequeueReusableCellWithIdentifier:PDCafeCellID];
    cell.cafeModel = self.cafeList[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDCafeDetailViewController *detailVc = [[PDCafeDetailViewController alloc] init];
    detailVc.cafeModel = self.cafeList[indexPath.row];
    [self.navigationController pushViewController:detailVc animated:YES];
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
-(void)PDLocationToolGetLocationCity:(NSString *)cityName result:(BMKReverseGeoCodeResult *)result Latitude:(CGFloat)latitude Longitude:(CGFloat)longitude
{
    self.beginPost = YES;
    self.locationCity = cityName;
    self.Latitude = latitude;
    self.Longitude = longitude;
    
    // 修改选择城市名 主要是第一次没有保存
    [self.cafeSearchView updateBtnChooseCityTitle];
    // 建立areaview 主要是第一次没有选择城市
    if (!self.areaView)
    {
        [self setUpAreaView];
        [self setAreaButtonBlock];
    }
    if (self.chooseCity && self.Longitude && self.Latitude && self.beginPost) // 这些都有才请求 不然等定位后
    {
        [self.cafeTableView headerBeginRefreshing];
    }
    
    // 比较城市是否相同
    [self ChooseIsEqualToLocation];
}

#pragma mark - PDTitleViewDelegate



#pragma mark - Getter Setter
// 得到最新的choose
-(NSString *)chooseCity
{
    _chooseCity = [[PDLocationTool shareTocationTool] readLastChooseCity];
       return _chooseCity;
}

// 初始化得到所有省份列表 默认获取市辖区列表
-(void)setProvinceList:(NSMutableArray *)provinceList
{
    _provinceList = provinceList;
    
}


-(NSMutableArray *)cityAreaList
{
    
    for (PDProvinceModel *provice in self.provinceList)
    {
        // 每个省份
        for (PDCityModel *city in provice.citylist)
        {
            if ([city.name isEqualToString:self.chooseCity])
            {
                // 更新areaView的列表
                _cityAreaList = city.arealist;
            }
        }
    }
    return _cityAreaList;
}

// 更新当前选择的市辖区
-(void)setChooseArea:(NSString *)chooseArea
{
    _chooseArea = [chooseArea copy];
    [self.headView.BtnArea setTitle:_chooseArea forState:UIControlStateNormal];
}


@end
