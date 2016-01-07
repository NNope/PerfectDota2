//
//  PDCafeAreaView.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/7.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDCafeAreaView.h"

#define MARGIN 18
#define BUTTONHEIGHT 40
#define MAXCOLSPEROW 3
@implementation PDCafeAreaView


-(instancetype)initWithFrame:(CGRect)frame areaList:(NSArray *)arealist
{
    self.btnsArr = [NSMutableArray array];
    self.areaList = arealist;
    frame.size = CGSizeMake(SCREENWIDTH, MARGIN+(MARGIN+BUTTONHEIGHT)*(self.areaList.count/MAXCOLSPEROW));
    if (self = [super initWithFrame:frame])
    {
        for (int i = 0; i < self.areaList.count; i++)
        {
            PDHistoryCityButton *btn = [[PDHistoryCityButton alloc] init];
            [btn addTarget:self action:@selector(chooseArea:) forControlEvents:UIControlEventTouchDown];
            [btn setTitle:self.areaList[i] forState:UIControlStateNormal];
            [self addSubview:btn];
            [self.btnsArr addObject:btn];
        }
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat buttonW = (self.width - (MAXCOLSPEROW + 1) * MARGIN) / MAXCOLSPEROW;
    CGFloat buttonH = 40;
    
    for (int i = 0; i<self.btnsArr.count; i++) {
        int row = i / MAXCOLSPEROW;
        int col = i % MAXCOLSPEROW;
        
        PDHistoryCityButton *btn = self.btnsArr[i];
        btn.frame = CGRectMake(col * (buttonW + MARGIN) + MARGIN, row * (buttonH + MARGIN), buttonW, buttonH);
    }
}

-(void)setAreaBlock:(areaBlock)handle
{
    self.areaHandle = handle;
}

- (void)chooseArea:(PDHistoryCityButton *)sender
{
    sender.selected = !sender.selected;
    if (self.areaHandle)
    {
        self.areaHandle(sender);
    }
}


@end
