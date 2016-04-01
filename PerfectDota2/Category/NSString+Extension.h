//
//  NSString+Extension.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

/**
 *  非公共的一个转换方式
 */
+ (NSString *)stringDealWithUrlString:(NSString *)url;


/**
 *  时间长度转为字符串
 *
 *  @param duration 总长度
 *
 *  @return 时间格式字符串
 */
+ (NSString *)stringWithDuration:(NSInteger)duration;


/**
 *  JSON字符串转为字典格式
 *
 *  @param JSONString <#JSONString description#>
 *
 *  @return <#return value description#>
 */
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;


/**
 *  MD5处理
 */
+ (NSString *)md5Encode:(NSString *)str;

/**
 *  根据error获得string
 *
 *  @param error
 *
 *  @return NSString
 */
+ (NSString *)stringFromError:(NSError *)error;


/**
 **************** url处理 ********************
 */

//判断获取url 后缀名
+ (BOOL)isUrl:(NSString *)url SuffixInArray:(NSArray *)arraySuffix;

//获取去除参数的url
+ (NSString *)getUrlWithoutParameter:(NSString *)url;

//获取url 参数值
+ (NSString *)getValueOfParameter:(NSString *)key url:(NSString *)url;





/**
 ***************** 设备 ********************
 */

/**
 *  获取当前版本号
 *
 *  @return 当前软件版本号
 */
+ (NSString *)getCurrentVersion;

/**
 *  获得运营商
 *
 *  @return 运营商
 */
+(NSString*)getCarrier;

@end
