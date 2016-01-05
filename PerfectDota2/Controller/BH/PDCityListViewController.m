//
//  PDCityListViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDCityListViewController.h"
#import "PDCityBaseModel.h"
#import "ChineseString.h"

static CGFloat const KsearchBarHeight = 40;
static CGFloat const KsectionHeaderHeight = 30;
static NSString *const KcityCellID = @"KcityCellID";

@interface PDCityListViewController ()

@end

@implementation PDCityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = PDGrayColor;
    [self setupTitle];
    [self setupSearchAndTable];
    
    [PDLocationTool shareTocationTool].delegate = self;
    [[PDLocationTool shareTocationTool] getLocationCity];
    
    // 1.-----根据id 注册一个自定义Cell
    [self.cityTableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:KcityCellID];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)setupTitle
{
    self.titleView.title  = [NSString stringWithFormat:@"切换到当前城市-%@",self.chooseCity];
}

- (void)setupSearchAndTable
{
    // table
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(5, NAVIBARHEIGHT + KsearchBarHeight, SCREENWIDTH - 10, SCREENHEIGHT - NAVIBARHEIGHT - KsearchBarHeight) style:UITableViewStylePlain];;
    self.cityTableView = table;
    self.cityTableView.backgroundColor = PDGrayColor;
    self.cityTableView.delegate = self;
    self.cityTableView.dataSource = self;
    [self.view addSubview:self.cityTableView];
    
    // head
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT, SCREENWIDTH, KsearchBarHeight)];
    searchBar.placeholder = @"城市/拼音";
    searchBar.delegate =self;
    [self.view addSubview:searchBar];

}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) // 定位城市 历史城市
    {
        return 1;
    }
    else // 其他分组
    {
        NSArray *sectionArr = [self.cityGroupList objectAtIndex:section-2];
        return sectionArr.count;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 2.-------事先注册过后 就可以直接用这个方法取出Cell 在CellForRow里
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KcityCellID forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *cellText = @"";
    if (indexPath.section == 0) // 定位城市
    {
        cellText = self.locationCity;
    }
    else if (indexPath.section == 1) // 最近选择城市
    {
        
    }
    else
    {
        cellText = self.cityGroupList[indexPath.section - 2][indexPath.row];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.text = cellText;
    
    return cell;
}
// section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.indexList.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 || indexPath.section == 1)
    {
        
    }
    else
    {
        // 选择了新的城市
        self.chooseCity = self.cityGroupList[indexPath.section-2][indexPath.row];
        // 保存本地的选择城市 以及历史城市
        [[PDLocationTool shareTocationTool] saveChooseCity:self.chooseCity];
        [[NSNotificationCenter defaultCenter] postNotificationName:PDChooseCityChanged object:nil userInfo:@{chooseCityInfoKey:self.chooseCity}];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UITableViewDelegate

// 索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    [self.indexList addObject:UITableViewIndexSearch];
    return self.indexList;
}
// sectionHeader高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KsectionHeaderHeight;
}
// sectionHeader
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, KsectionHeaderHeight)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREENWIDTH, KsectionHeaderHeight)];
    sectionLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    sectionLabel.font = [UIFont boldSystemFontOfSize:14];
    [sectionHeaderView addSubview:sectionLabel];
    
    // section标题
    NSString *title = @"";
    if (section == 0)
    {
        title = @"定位城市";
    }
    else if (section == 1)
    {
        title = @"最近访问城市";
    }
    else
    {
        title = self.indexList[section];
    }
    sectionLabel.text = title;
    
    return sectionHeaderView;
}

#pragma mark - PDLocationToolDelegate
-(void)PDLocationToolGetLocationCity:(NSString *)cityName result:(BMKReverseGeoCodeResult *)result
{
    self.locationCity = cityName;
    [self.cityTableView reloadData];
    
}

#pragma mark - Getter Setter
// 从本地得到全部城市列表
-(NSMutableArray *)cityAllList
{
    if (_cityAllList == nil)
    {
        _cityAllList = [PDCityBaseModel mj_objectArrayWithFilename:@"dotacitylist.plist"];
    }
    return _cityAllList;
}

// 从全部城市里得到名称列表
-(NSMutableArray *)cityNameList
{
    if (_cityNameList == nil)
    {
        _cityNameList = [NSMutableArray array];
        // 得到名称列表 未分组 用于排序
        for (PDCityBaseModel *temp in self.cityAllList)
        {
            [_cityNameList addObject:temp.name];
        }
    }
    return _cityNameList;
}


// 从名称列表里得到索引列表
-(NSMutableArray *)indexList
{
    if (_indexList == nil)
    {
        // A-Z 增加
        _indexList = [ChineseString IndexArray:self.cityNameList];
        // 增加 #$
        NSRange range = NSMakeRange(0, 2);
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:range];
        [_indexList insertObjects:@[@"#",@"$"] atIndexes:indexSet];
    }
    return _indexList;
}

// 从名称列表里得到分组列表
-(NSMutableArray *)cityGroupList
{
    if (_cityGroupList == nil)
    {
        _cityGroupList = [ChineseString LetterSortArray:self.cityNameList];
    }
    return _cityGroupList;
}

/**
 *  先取本地上次定位城市，本地无-正在定位中，本地有-显示
 *  同时 开始定位 定位结束后 内部会更新本地，需要刷新表格
 *  @return <#return value description#>
 */
-(NSString *)locationCity
{
    if (_locationCity == nil)
    {
        _locationCity = [[[PDLocationTool shareTocationTool] readLastLocationCity] copy];
    }
    return _locationCity;
}

@end
