//
//  PDWallModel.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/27.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDWallModel.h"

@implementation PDWallModel

- (void)setAuthor:(NSString *)author
{
    _author = [[NSString stringWithFormat:@"作者-%@",author] copy];
}
@end
