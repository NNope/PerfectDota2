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

// 当前选择的城市
@property (nonatomic, copy) NSString *currentCity;
// 定位城市
@property (nonatomic, copy) NSString *locationCity;
@property (nonatomic, weak) UITableView *cityTableView;

@end
