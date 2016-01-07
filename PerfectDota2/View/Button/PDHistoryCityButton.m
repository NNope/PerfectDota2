//
//  PDHistoryCityButton.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/6.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDHistoryCityButton.h"
#define RedColor [UIColor colorWithRed:163/255.0 green:36/255.0 blue:15/255.0 alpha:1.0]

@implementation PDHistoryCityButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self setTitleColor:RedColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    
    self.layer.borderColor = [RedColor CGColor];
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
}

-(void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected == YES)
    {
        self.backgroundColor = RedColor;
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    else
    {
        self.backgroundColor = [UIColor clearColor];
        [self setTitleColor:RedColor forState:UIControlStateNormal];
    }
    
}

@end
