//
//  NSString+Json.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/11.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "NSString+Json.h"


@implementation NSString (Json)


+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

@end
