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
@end
