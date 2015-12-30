//
//  PDCityListViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDCityListViewController.h"

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
    
    // 1.-----根据id 注册一个自定义Cell
    [self.cityTableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:KcityCellID];
}

- (void)setupTitle
{
    if (!self.locationCity)
    {
        self.locationCity = @"";
    }
    self.titleView.title  = [NSString stringWithFormat:@"切换到当前城市-%@",self.locationCity];
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
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // 2.-------事先注册过后 就可以直接用这个方法取出Cell 在CellForRow里
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KcityCellID forIndexPath:indexPath];
    if (indexPath.section == 0) // 定位城市
    {
        if (self.locationCity.length == 0) // 没有定位到
        {
            
        }
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}


#pragma mark - UITableViewDelegate


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return KsectionHeaderHeight;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, KsectionHeaderHeight)];
    sectionHeaderView.backgroundColor = [UIColor colorWithRed:226/255.0 green:226/255.0 blue:226/255.0 alpha:1];
    UILabel *sectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, SCREENWIDTH, KsectionHeaderHeight)];
    sectionLabel.textColor = [UIColor colorWithRed:100/255.0 green:100/255.0 blue:100/255.0 alpha:1];
    sectionLabel.font = [UIFont boldSystemFontOfSize:14];
    [sectionHeaderView addSubview:sectionLabel];
    
    NSString *title = @"";
    if (section == 0)
    {
        title = @"定位城市";
    }
    sectionLabel.text = title;
    
    return sectionHeaderView;
}

@end
