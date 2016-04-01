//
//  NSDictionary+Category.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/3/10.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Category)

/**
 *  json字符串转字典
 *
 *  @param JSONString <#JSONString description#>
 *
 *  @return <#return value description#>
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)JSONString;
@end
