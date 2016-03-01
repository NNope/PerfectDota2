//
//  NSString+Json.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/11.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

/**
 *  json字符串转字典
 *
 *  @param JSONString <#JSONString description#>
 *
 *  @return <#return value description#>
 */
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;
@end
