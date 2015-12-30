//
//  NSString+Extension.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

/**
 *  截取web传递的url协议
 *
 *  @param url <#url description#>
 *
 *  @return <#return value description#>
 */
+ (NSString *)stringDealWithUrlString:(NSString *)url
{
    // {"action":"playVideo","url":"http://dota2.dl.wanmei.com/dota2/video/abilities/queen_of_pain_shadow_strike.mp4"}
    // 判断内部
    NSRange urlRange = [url rangeOfString:@"\"url\":\""];
    // local://heroes/i.html?earthshaker"
    // http://dota2.dl.wanmei.com/dota2/video/abilities/queen_of_pain_shadow_strike.mp4"
    NSString *toUrl = [url substringFromIndex:urlRange.location+urlRange.length];
    
    // local://heroes/i.html?earthshaker
    // http://dota2.dl.wanmei.com/dota2/video/abilities/queen_of_pain_shadow_strike.mp4
    toUrl = [toUrl substringToIndex:[toUrl rangeOfString:@"\""].location];
    
    if ([toUrl hasPrefix:@"local"])
    {
        toUrl = [toUrl substringFromIndex:[@"local://" length]];
    }
    return toUrl;
}

/**
 *  毫秒转换
 */
+ (NSString *)stringWithDuration:(NSInteger)duration
{
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    
    second = duration/1000;
    if (second >= 60)
    {
        minute = second/60;
        second = second%60;
    }
    if (minute >= 60)
    {
        hour = minute/60;
        minute = minute%60;
    }
    NSString *strSec = [self getTwoLength:second];
    NSString *strMin = [self getTwoLength:minute];
    NSString *strHou = [self getTwoLength:hour];
    
    return [NSString stringWithFormat:@"%@:%@:%@",strHou,strMin,strSec];
}

+ (NSString *)getTwoLength:(NSInteger)time
{
    if (time < 10)
    {
        return [NSString stringWithFormat:@"0%lu",time];
    }
    else
        return [NSString stringWithFormat:@"%lu",time];
}

@end
