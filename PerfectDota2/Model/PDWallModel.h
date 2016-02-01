//
//  PDWallModel.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/27.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDWallModel : NSObject
/**
 *  "id": "166708",
 "filename": "火女-莉娜",
 "filesize": "391K,845K,1.13M",
 "filefrom": "完美世界pwcd",
 "author": "佳佳里",
 "thumbnail": "http:\/\/www.dota2.com.cn\/resources\/jpg\/141203\/10251417601380433.jpg",
 "iPhone640": "http:\/\/www.dota2.com.cn\/resources\/jpg\/141203\/10251417600271286.jpg",
 "iPhone1080": "http:\/\/www.dota2.com.cn\/resources\/jpg\/141203\/10251417600276084.jpg",
 "iPad2048": "http:\/\/www.dota2.com.cn\/resources\/jpg\/141203\/10251417600284326.jpg"
 */
@property (nonatomic, assign) NSInteger ID;
/**
 *  显示名称
 */
@property (nonatomic, copy) NSString *filename;
/**
 *  文件大小
 */
@property (nonatomic, copy) NSString *filesize;
/**
 *  来源
 */
@property (nonatomic, copy) NSString *filefrom;
/**
 *  来源
 */
@property (nonatomic, copy) NSString *author;
/**
 *  缩略图
 */
@property (nonatomic, copy) NSString *thumbnail;
@property (nonatomic, copy) NSString *iPhone640;
@property (nonatomic, copy) NSString *iPhone1080;
@property (nonatomic, copy) NSString *iPad2048;

@end
