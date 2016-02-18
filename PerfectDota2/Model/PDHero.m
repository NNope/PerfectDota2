//
//  PDHero.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/18.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDHero.h"

@implementation PDHero

-(void)setImage:(NSString *)image
{
    // <img ms-src="../static/images/heroes/{{item.img}}_hphover.png">
    NSString *path = [NSString stringWithFormat:@"%@/static/images/heroes/%@_hphover.png",APP1PATH,image];
    _image = [path copy];
}

@end
