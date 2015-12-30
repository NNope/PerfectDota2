//
//  TTTagView.m
//  TTTagView
//
//  Created by 谈Xx on 15/12/3.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDTagView.h"
#import "PDTagLabel.h"
static CGFloat const rightItemW = 60;

@implementation PDTagView

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.isTagChange = YES;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.isTagChange = YES;
    }
    return self;
}

-(void)setTagNameList:(NSArray *)tagNameList
{
    _tagNameList = tagNameList;
    for (int i = 0; i < tagNameList.count; i++)
    {
        PDTagLabel *lbl = [[PDTagLabel alloc] init];
        lbl.text = self.tagNameList[i];
        lbl.tag = i;
        lbl.userInteractionEnabled = YES;
        [self addSubview:lbl];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagLabelClick:)];
        [lbl addGestureRecognizer:tap];
    }
    if (tagNameList.count < 3)
    {
        self.isNeedMargin = YES;
    }
    
    UIView *redLine = [[UIView alloc] init];
    redLine.backgroundColor = PDRedColor;
    self.redLine = redLine;
    [self addSubview:redLine];
    
    
    UIView *markview = [[UIView alloc] init];
    markview.backgroundColor = PDRedColor;
    self.markView = markview;
    [self addSubview:self.markView];
    // 默认选中第0个
    self.selectIndex = 0;
}

-(void)setSubviewsFrame
{
    // redline
    self.redLine.frame = CGRectMake(0, self.height-1, self.width, 1);
    
    // tagLabel
    __block CGFloat lblW;
    lblW = self.width/self.tagNameList.count;
    CGFloat lblH = self.height - 1;
    CGFloat lblY = 0;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UILabel class]])
        {
            CGFloat lblX = idx*lblW;
            if (self.isNeedMargin)// 如果小于3个，去除2边的间距，
            {
                lblW = (self.width - 2*rightItemW)/self.tagNameList.count;
                lblX = rightItemW + idx*lblW;
            }
            // 开始tagLabel
            obj.frame = CGRectMake(lblX, lblY, lblW, lblH);
            //
            if (obj.tag == 0)
            {
                PDTagLabel *first = (PDTagLabel *)obj;
                first.scalePercent = 1.0;
            }
        }
    }];
    self.TagLabelWidth = lblW;
    // markView 先给默认值 第一个
    // 获取文字的宽度 不是label的宽度
    UILabel *lbl = (UILabel *)self.subviews[0];
    CGSize textSize =
    [lbl.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:lbl.font.fontName size:lbl.font.pointSize]}];
    // x要再计算下
    CGFloat markX = (lblW - textSize.width )/2;;
    if (self.isNeedMargin)
    {
        markX += rightItemW;
    }
    self.markView.frame = CGRectMake(markX, self.height-3, textSize.width, 3);

}

// 滑动markView
-(void)moveMarkViewFromIndex:(NSInteger)oldindex ToIndex:(NSInteger)newIndex
{
    // 移动markView
//    CGFloat markTranslate = (newIndex - oldindex)*TagLabelWidth;
//    [UIView animateWithDuration:0.25f animations:^{
//        self.markView.transform = CGAffineTransformTranslate(self.markView.transform, markTranslate, 0);
//    }];
    
}

/**
 *  点击后的代理方法
 *  应该算好偏移量传递出去，直接外层开始便宜
 *  @param recognizer
 */
-(void)tagLabelClick:(UITapGestureRecognizer *)recognizer
{
    PDTagLabel *lbl = (PDTagLabel *)recognizer.view;
    if ([self.delegate respondsToSelector:@selector(pdTagView:didSelectTaglabel:)])
    {
        // 让外层做scroll的便宜
        [self.delegate pdTagView:self didSelectTaglabel:lbl];
    }
    // 自己做mark的偏移
//    [self moveMarkViewFromIndex:self.selectIndex ToIndex:lbl.tag];
    if (!self.selectIndex == lbl.tag)
    {
        self.isTagChange = NO;
    }
    self.selectIndex = lbl.tag;
}


@end
