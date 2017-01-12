//
//  PDCafeAreaView.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/1/7.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDCafeAreaView.h"
#import "PDCityBaseModel.h"

#define MARGIN 10
#define BUTTONHEIGHT 40
#define MAXCOLSPEROW 3
@implementation PDCafeAreaView


-(instancetype)initWithFrame:(CGRect)frame areaList:(NSMutableArray *)arealist
{
    self.btnsArr = [NSMutableArray array];
    self.areaList = arealist;
    
    frame.size = CGSizeMake(SCREENWIDTH, MARGIN+(MARGIN+BUTTONHEIGHT)*self.row);
    if (self = [super initWithFrame:frame])
    {
        for (int i = 0; i < self.areaList.count; i++)
        {
            PDHistoryCityButton *btn = [[PDHistoryCityButton alloc] init];
            [btn addTarget:self action:@selector(chooseArea:) forControlEvents:UIControlEventTouchUpInside];
            // 取出这个市辖区
            PDCityBaseModel *area = (PDCityBaseModel *)self.areaList[i];
            [btn setTitle:area.name forState:UIControlStateNormal];
            [self addSubview:btn];
            [self.btnsArr addObject:btn];
        }
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    self.frame = CGRectMake(0, self.y, SCREENWIDTH, MARGIN+(MARGIN+BUTTONHEIGHT)*self.row);
    self.backgroundColor = PDGrayColor;
    
    // 布局按钮
    CGFloat buttonW = (self.width - (MAXCOLSPEROW + 1) * MARGIN) / MAXCOLSPEROW;
    CGFloat buttonH = 40;
    
    for (int i = 0; i<self.btnsArr.count; i++) {
        int row = i / MAXCOLSPEROW;
        int col = i % MAXCOLSPEROW;
        
        PDHistoryCityButton *btn = self.btnsArr[i];
        btn.frame = CGRectMake(col * (buttonW + MARGIN) + MARGIN, row * (buttonH + MARGIN) + MARGIN, buttonW, buttonH);
    }
    // 默认选中 全区按钮
    [self chooseArea:self.btnsArr[0]];
}

- (void)hideAreaView
{
    // hide
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

-(void)showAreaView
{
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0, self.height);
    }];
}

- (void)chooseArea:(PDHistoryCityButton *)sender
{
    
    [self hideAreaView];
    if (self.areaHandle)
    {
        self.areaHandle(sender);
    }
    
    if (sender.selected)
    {
        // show
        return;
    }
    else
    {
        // 所有的全部取消选中
        for (PDHistoryCityButton *btn in self.btnsArr)
        {
            btn.selected = NO;
        }
        sender.selected = !sender.selected;
    }
    
   
}

-(void)setAreaBlock:(areaBlock)handle
{
    self.areaHandle = handle;
}

-(NSInteger)row
{
    
    // 算下到底有几行  10/3 = 3  9/3 = 3
    NSInteger remainder = self.areaList.count % MAXCOLSPEROW;
    _row = self.areaList.count / MAXCOLSPEROW;
    _row = remainder==0?_row:_row+1;
    return _row;
}

//-(void)setAreaList:(NSMutableArray *)areaList
//{
//    _areaList = areaList;
//}


@end
