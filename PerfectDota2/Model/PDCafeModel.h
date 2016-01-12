//
//  PDCafeModel.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/11.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDCafeModel : NSObject


/**
 *
 "id": "4951",
 "cafe_name": "\u676d\u5dde\u7f51\u575b\u7f51\u7edc\u79d1\u6280\u6709\u9650\u516c\u53f8",
 "machine_count": "93",
 "cafe_face_img_small": "",
 "cafe_inner_img_small": "",
 "address_province": "\u6d59\u6c5f",
 "address_city": "\u676d\u5dde",
 "address_district": "\u897f\u6e56\u533a",
 "address_detail": "\u6587\u4e8c\u8def322\u53f7",
 "longitude": "120.132435",
 "latitude": "30.289017",
 "phone": "0571-88077122",
 "distance": "0.68"
 */
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *cafe_name;
/**
 *  规模
 */
@property (nonatomic, copy) NSString *machine_count;
/**
 *  cell
 */
@property (nonatomic, copy) NSString *cafe_face_img_small;
/**
 *  detail
 */
@property (nonatomic, copy) NSString *cafe_inner_img_small;
/**
 *  城市
 */
@property (nonatomic, copy) NSString *address_city;
/**
 *  区
 */
@property (nonatomic, copy) NSString *address_district;
/**
 *  地址
 */
@property (nonatomic, copy) NSString *address_detail;

@property (nonatomic, assign) CGFloat longitude;
@property (nonatomic, assign) CGFloat latitude;

// 电话
@property (nonatomic, copy) NSString *phone;
// 距离
@property (nonatomic, assign) double distance;
@end
