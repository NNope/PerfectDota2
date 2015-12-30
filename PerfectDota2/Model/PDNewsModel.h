//
//  NewsModel.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/10.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDNewsModel : NSObject
/*
 "id": "178223",
 "title": "本周六ECL秋季赛DOTA2线上预选赛最后一轮预告",
 "date": "2015-12-04",
 "pic": "http://www.dota2.com.cn/resources/jpg/151204/10251449209465734.jpg",
 "url": "http://www.dota2.com.cn/wapnews/matchnews/20151204/178223.htm",
 "desc": "本周六将进行ECL秋季赛DOTA2项目线上预选赛的最后一轮",
 "showComment": true,
 "type": "matchnews",
 "isVideo": false,
 "newstype": "0",
 "topicinfo": {}
 */
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, assign) BOOL showComment;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL isVideo;
@property (nonatomic, copy) NSString *newstype;
@property (nonatomic, strong) NSDictionary *topicinfo;
@end
