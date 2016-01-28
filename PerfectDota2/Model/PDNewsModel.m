//
//  PDNewsModel
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/10.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDNewsModel.h"

@implementation PDNewsModel



/**
 *  类别
 *
 *  @param type 转换下中文
 */
-(void)setType:(NSString *)type
{
    // 利用MJExtension 但是要额外进行下转换
    if ([type isEqualToString:@"medianews"])
    {
        _type = @"媒体";
    }
    else if ([type isEqualToString:@"vernews"])
    {
        _type = @"更新";
    }
    else if ([type isEqualToString:@"matchnews"])
    {
        _type = @"赛事";
    }
    else if ([type isEqualToString:@"govnews"])
    {
        _type = @"官方";
    }
    else
        _type = [type copy];
    
}

// 转换完成后 做缓存
-(void)mj_keyValuesDidFinishConvertingToObject
{
    
}
@end
