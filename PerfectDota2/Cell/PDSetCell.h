//
//  PDSetCell.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/23.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDSetItem.h"

@interface PDSetCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) PDSetItem *item;
@end
