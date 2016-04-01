//
//  NSString+Extension.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "NSString+Extension.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

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
 *  时间长度转为字符串
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
        return [NSString stringWithFormat:@"0%ld",(long)time];
    }
    else
        return [NSString stringWithFormat:@"%ld",(long)time];
}

// JSON字符串转为字典格式
+(NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString
{
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}



// MD5处理
+ (NSString *)md5Encode:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    NSString *md5Result = [NSString stringWithFormat:
                           @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return md5Result;
    
}

/**
 *  根据error获得string
 *
 *  @param error
 *
 *  @return NSString
 */
+ (NSString *)stringFromError:(NSError *)error
{
    if (error && error.userInfo) {
        NSMutableString *tipStr = [[NSMutableString alloc] init];
        if ([error.userInfo objectForKey:@"msg"])
        {
            NSArray *msgArray = [[error.userInfo objectForKey:@"msg"] allValues];
            NSUInteger num = [msgArray count];
            for (int i = 0; i < num; i++)
            {
                NSString *msgStr = [msgArray objectAtIndex:i];
                if (i+1 < num)
                {
                    [tipStr appendString:[NSString stringWithFormat:@"%@\n", msgStr]];
                }else{
                    [tipStr appendString:msgStr];
                }
            }
        }
        else
        {
            if ([error.userInfo objectForKey:@"NSLocalizedDescription"])
            {
                tipStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
            }
            else
            {
                [tipStr appendFormat:@"ErrorCode%ld", (long)error.code];
            }
        }
        return tipStr;
    }
    return nil;
}


/**
 **************** url处理 ********************
 */

//判断获取url 后缀名
+ (BOOL)isUrl:(NSString *)url SuffixInArray:(NSArray *)arraySuffix
{
    NSString *strSuff = @"";
    if (url.length <= 0 || arraySuffix.count <= 0)
    {
        return NO;
    }
    // 去除参数
    NSString *noParameterUrl = [self getUrlWithoutParameter:url];
    // 后缀名
    strSuff = [[noParameterUrl componentsSeparatedByString:@"."] lastObject];
    strSuff = [strSuff lowercaseString];
    // 数组中是否包含这个后缀
    if ([arraySuffix containsObject:strSuff])
    {
        return YES;
    }
    return NO;
}

//获取去除参数的url
+ (NSString *)getUrlWithoutParameter:(NSString *)url
{
    if (url.length <= 0)
    {
        return nil;
    }
    NSString *tempUrl = [url copy];
    if ([tempUrl rangeOfString:@"?"].location != NSNotFound)
    {
        // 根据？分组
        NSArray *array = [tempUrl componentsSeparatedByString:@"?"];
        tempUrl = [array objectAtIndex:0];
    }
    return tempUrl;
}

//获取url 参数值
+ (NSString *)getValueOfParameter:(NSString *)key url:(NSString *)url
{
    NSError *error;
    // 正则表达式检测
    NSString *regTags=[[NSString alloc] initWithFormat:@"(^|&|\\?)+%@=+([^&]*)(&|$)",key];
    // 不区分大小写
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regTags
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    // 正则匹配
    NSArray *matches = [regex matchesInString:url
                                      options:0
                                        range:NSMakeRange(0, [url length])];
    for (NSTextCheckingResult *match in matches)
    {
        NSString *tagValue = [url substringWithRange:[match rangeAtIndex:2]];  // 分组2所对应的串
        return tagValue;
    }
    return @"0";
}



/**
 ***************** 设备 ********************
 */
// 得到当前软件版本号
+ (NSString *)getCurrentVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return app_Version;
}

// 获得运营商
+(NSString*)getCarrier
{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [info subscriberCellularProvider];
    NSString * mcc = [carrier mobileCountryCode];
    NSString * mnc = [carrier mobileNetworkCode];
    if (mnc == nil || mnc.length <1 || [mnc isEqualToString:@"SIM Not Inserted"] )
    {
        return @"Unknown";
    }
    else
    {
        if ([mcc isEqualToString:@"460"])
        {
            NSInteger MNC = [mnc intValue];
            switch (MNC)
            {
                case 00:
                case 02:
                case 07:
                    return @"中国移动";
                    break;
                case 01:
                case 06:
                    return @"中国联通";
                    break;
                case 03:
                case 05:
                    return @"中国电信";
                    break;
                case 20:
                    return @"中国铁通";
                    break;
                default:
                    break;
            }
        }
    }
    
    return @"Unknown";
}


@end
