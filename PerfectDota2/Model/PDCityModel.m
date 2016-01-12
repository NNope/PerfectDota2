//
//  PDCityModel.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/28.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDCityModel.h"

@implementation PDCityModel

-(void)setArealist:(NSMutableArray *)arealist
{
    _arealist = arealist;
    PDCityBaseModel *quanQu = [[PDCityBaseModel alloc] init];
    quanQu.name = @"全区";
    [_arealist insertObject:quanQu atIndex:0];
}

@end
