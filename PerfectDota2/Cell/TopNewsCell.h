//
//  TopImgCell.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/9.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopNewsModel.h"
#import "TTAdsView.h"
@class TopNewsCell;

@protocol TopNewsCellDelegate <NSObject>
@optional
- (void)TopNewsCell:(TopNewsCell *)topcell didSelectItemAtIndex:(NSInteger)index Url:(NSString *)url;

@end


@interface TopNewsCell : UITableViewCell<TTAdsViewDelegate>

@property (nonatomic, weak) TTAdsView *ttAdsView;

@property (nonatomic, strong) NSArray *topNewsList;

@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *pics;
@property (nonatomic, strong) TopNewsModel *topNewsModel;

@property (nonatomic, weak) id<TopNewsCellDelegate> delegate;
//@property (nonatomic, weak) UIViewController *tableVC;

@end
