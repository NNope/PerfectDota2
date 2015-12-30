//
//  PDVideoAlbumModel.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDVideoAlbumModel : NSObject
/**
 * 
 "_id": "561b7953d2dd63052109bdb6",
	"title": "2015法兰克福特锦赛",
	"class_id": 3,
	"discirption": "2015法兰克福特锦赛",
	"thumbnail": "http://img.dota2.com.cn/dota2/57/4e/574ebf0e93a36237ba0ce47c47686b8c1450088797.jpg",
	"total": 113,
	"seat": 57,
	"last_uped": 1448876509394,
	"is_release": 1,
	"created": 1444641107836,
	"__v": 0

 */

@property (nonatomic, copy) NSString *_id;
@property (nonatomic, copy) NSString *title;
// 就是类别
@property (nonatomic, assign) NSInteger class_id;
@property (nonatomic, copy) NSString *discirption;
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger seat;
@property (nonatomic, assign) NSInteger last_uped;
@property (nonatomic, assign) NSInteger created;

@end
