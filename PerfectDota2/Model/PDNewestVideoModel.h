//
//  PDNewVideoModel.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/15.
//  Copyright © 2015年 谈Xx. All rights reserved.
//  视频-最新

#import <Foundation/Foundation.h>
#import "PDAuthorModel.h"

@interface PDNewestVideoModel : NSObject
/**
 *  "cid": 4,
	"title": "【Secret VS Liquid#2-3】StarLadder DOTA2西瓦幽鬼1207",
	"video_id": "XMTQwNzAwMTM0OA==",
	"duration": 3076130,毫秒
	"link": "http://v.youku.com/v_show/id_XMTQwNzAwMTM0OA==.html",
	"thumbnail": "http://r2.ykimg.com/054204085665EC336A0A400481D7F08E",
	"bigThumbnail": "http://r2.ykimg.com/054104085665EC336A0A400481D7F08E",
	"author": {
 "id": "109937062",
 "name": "西瓦幽鬼",
 "link": "http://v.youku.com/user_show/id_UNDM5NzQ4MjQ4.html"
	},
	"up_count": 30,
	"favorite_count": 0,
	"view_count": 8063,
	"comment_count": 10,
	"down_count": 0,
	"last_uped": 1449715334518,
	"is_release": 1,
	"published": "2015-12-08 02:33:34",

 */
/**
*  4解说 2集锦  3赛事
*/
@property (nonatomic, assign) NSInteger cid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) NSInteger duration;
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *bigThumbnail;
@property (nonatomic, strong) PDAuthorModel *author;
@property (nonatomic, strong) NSString *published;
@end
