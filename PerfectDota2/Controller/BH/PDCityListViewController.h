//
//  PDCityListViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/29.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDLocationTool.h"

@interface PDCityListViewController : PDBaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,PDLocationToolDelegate>
{
    
}

// 当前选择的城市 - 传进来的 以及后续修改的
@property (nonatomic, copy) NSString *chooseCity;
// 定位城市
@property (nonatomic, copy) NSString *locationCity;
/**
 *  全部城市列表
 */
@property (nonatomic, strong) NSMutableArray *cityAllList;
/**
 *  拼音分组后的列表
 */
@property (nonatomic, strong) NSMutableArray *cityGroupList;
/**
 *  城市名列表
 */
@property (nonatomic, strong) NSMutableArray *cityNameList;
/**
 *  历史城市列表
 */
@property (nonatomic, strong) NSMutableArray *cityHistoryList;
/**
 *  索引列表
 */
@property (nonatomic, strong) NSMutableArray *indexList;

@property (nonatomic, weak) UITableView *cityTableView;

@end
