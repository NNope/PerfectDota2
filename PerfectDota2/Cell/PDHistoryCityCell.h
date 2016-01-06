//
//  PDHistoryCityCell.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/6.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDHistoryCityButton.h"

@protocol PDHistoryCityCellDelegate <NSObject>

@optional
- (void)pdHistoryCityButtonDidClick:(PDHistoryCityButton *)btn;
@end

@interface PDHistoryCityCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PDHistoryCityButton *city1;
@property (weak, nonatomic) IBOutlet PDHistoryCityButton *city2;
@property (weak, nonatomic) IBOutlet PDHistoryCityButton *city3;
@property (nonatomic, assign) id<PDHistoryCityCellDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *historyCitys;
- (IBAction)btn1Click:(id)sender;
- (IBAction)btn2Click:(id)sender;
- (IBAction)btn3Click:(id)sender;

@end
