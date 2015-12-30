//
//  NewsTableViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/10.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopNewsCell.h"
/**
 用来区分tableView所处的版块
 */
typedef enum {
    PDNewsTableTypeAll,
    PDNewsTableTypeGov,
    PDNewsTableTypeUpdate,
    PDNewsTableTypeMedia,
    PDNewsTableTypeMatch
}PDNewsTableType;

typedef enum {
    PDVideoTableTypeNewest,      // 最新
    PDVideoTableTypeMatch,       // 赛事
    PDVideoTableTypeHighlights,  // 集锦
    PDVideoTableTypeCommentate,  // 解说
    PDVideoTableTypeLive         // 直播
}PDVideoTableType;

@interface NewsTableViewController : UITableViewController<TopNewsCellDelegate>
@property (nonatomic, assign) PDNewsTableType pdNewsTableType;
@property (nonatomic, assign) PDVideoTableType pdVideoTableType;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, strong) NSArray *topNewsList;
// 新闻数据数组
@property (nonatomic, strong) NSMutableArray *newsList;
// 最新视频数组
@property (nonatomic, strong) NSMutableArray *videoList;
/**
 *  区分新闻版块类型
 */
@property (nonatomic, copy) NSString *typeBaseUrl;
/**
 *  区分视频类型 和 get请求参数
 *  4解说 2集锦  3赛事
 */
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, assign) BOOL topSuccess;
@property (nonatomic, assign) BOOL newSuccess;
/**
 *  每个vc只做一次自动刷新
 */
@property(nonatomic, assign) BOOL hasAutoRefresh;

@end
