//
//  PDSettingViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/23.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDSettingViewController.h"
#import "PDSetSwitchItem.h"
#import "PDSetArrowItem.h"
#import "PDSetGroup.h"
#import "PDSetCell.h"

@interface PDSettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PDSettingViewController

-(instancetype)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleView.title = @"设置";
    
    // 设置tableView属性
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, NAVIBARHEIGHT,SCREENWIDTH, SCREENHEIGHT) style:UITableViewStyleGrouped];
    table.delegate = self;
    table.dataSource = self;
    self.tableView = table;
    [self.view addSubview:self.tableView];
//    self.tableView
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.sectionFooterHeight = 55;
    self.tableView.sectionHeaderHeight = 55;
    self.tableView.contentInset = UIEdgeInsetsMake( -10, 0, 0, 0);
    
    // 1.创建第一组
    PDSetGroup *group = [PDSetGroup group];
    [self.groups addObject:group];
    
    // 2.设置组的基本数据
    group.header = @"系统设置";
    
    // 3.设置组的所有行数据
    PDSetArrowItem *picCache = [PDSetArrowItem itemWithTitle:@"清除图片缓存"];
    picCache.subtitle = @"19MB";
    
    PDSetSwitchItem *wifi = [PDSetSwitchItem itemWithTitle:@"允许非WiFi网络缓存"];
    wifi.isSelected = NO;
    PDSetSwitchItem *push = [PDSetSwitchItem itemWithTitle:@"是否接收推送通知"];
    push.isSelected = YES;
    
    group.items = @[picCache,wifi,push];
    
    
    
    // 其他设置
    PDSetGroup *group2 = [PDSetGroup group];
    [self.groups addObject:group2];
    
    // 2.设置组的基本数据
    group2.header = @"其他设置";
    
    // 3.设置组的所有行数据
    PDSetArrowItem *back = [PDSetArrowItem itemWithTitle:@"意见反馈"];
    back.subtitle = @"QQ群:12356576";
    back.isLeftSub = YES;
    
    PDSetArrowItem *share = [PDSetArrowItem itemWithTitle:@"推荐给好友"];
    
    PDSetArrowItem *good = [PDSetArrowItem itemWithTitle:@"给我们好评"];
    PDSetArrowItem *version = [PDSetArrowItem itemWithTitle:@"检查版本更新"];
    version.subtitle = @"当前2.8.0";
    PDSetArrowItem *zlkVersion = [PDSetArrowItem itemWithTitle:@"检查资料库更新"];
    zlkVersion.subtitle = @"当前2.8";
    PDSetArrowItem *log = [PDSetArrowItem itemWithTitle:@"版本更新日志"];
    PDSetArrowItem *start = [PDSetArrowItem itemWithTitle:@"欢迎页"];
    PDSetArrowItem *about = [PDSetArrowItem itemWithTitle:@"关于我们"];
    
    group2.items = @[back,share,good,version,zlkVersion,log,start,about];

    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.groups.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    PDSetGroup *group = self.groups[section];
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PDSetCell *cell = [PDSetCell cellWithTableView:tableView];
    PDSetGroup *group = self.groups[indexPath.section];
    cell.item = group.items[indexPath.row];
    return cell;
}

#pragma mark - head foot
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    PDSetGroup *group = self.groups[section];
    return group.footer;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PDSetGroup *group = self.groups[section];
    return group.header;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.取出这行对应的item模型
    PDSetGroup *group = self.groups[indexPath.section];
    PDSetItem *item = group.items[indexPath.row];
    
    // 2.判断有无需要跳转的控制器
    if (item.destVcClass) {
        UIViewController *destVc = [[item.destVcClass alloc] init];
        destVc.title = item.title;
        [self.navigationController pushViewController:destVc animated:YES];
    }
    
    // 3.判断有无想执行的操作
    if (item.operation) {
        item.operation(self);
    }
}


- (NSMutableArray *)groups
{
    if (_groups == nil) {
        self.groups = [NSMutableArray array];
    }
    return _groups;
}
@end
