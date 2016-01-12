//
//  NSString+Json.h
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/11.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Json)

+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;
@end
