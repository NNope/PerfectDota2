//
//  PDNewVideoModel.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/15.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDNewestVideoModel.h"

@implementation PDNewestVideoModel

-(void)setCid:(NSInteger)cid
{
    _cid = cid;
    if (cid == 2)
    {
        self.type = @"集锦";
    }
    else if (cid == 3)
    {
        self.type = @"赛事";
    }
    else if (cid == 4)
    {
        self.type = @"解说";
    }
}

@end
