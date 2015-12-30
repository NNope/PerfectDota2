//
//  PDShareButton.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/24.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDShareButton.h"

static CGFloat const margin = 10;
static CGFloat const IMAGEY = 20;

@interface PDShareButton()

@property (nonatomic, strong) UIFont *titleFont;

@end

@implementation PDShareButton
/**
 *  从文件中解析一个对象的时候就会调用这个方法
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

/**
 *  通过代码创建控件的时候就会调用
 */
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

/**
  *  初始化
  */
- (void)setup
{
    // 字体大小
    self.titleFont = [UIFont systemFontOfSize:11];
    self.titleLabel.font = self.titleFont;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // 图标居中
    self.imageView.contentMode = UIViewContentModeCenter;
}

// 记录下设置的img的size
-(void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    self.btnImgSize = image.size;
}

/**
 *  控制内部label的frame
 *  contentRect : 按钮自己的边框
 */
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = margin + self.btnImgSize.height + IMAGEY;
    NSDictionary *attrs = @{NSFontAttributeName : self.titleFont};
    CGFloat titleW = contentRect.size.width;
    
    CGFloat titleH = [self.currentTitle boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.height;
//    CGFloat titleH = contentRect.size.height;
    return CGRectMake(titleX, titleY, titleW, titleH);
}

/**
 *  控制内部imageView的frame
 */
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageW = self.btnImgSize.width;
    CGFloat imageX = (contentRect.size.width - self.btnImgSize.width)/2;
    CGFloat imageY = IMAGEY;
    CGFloat imageH = self.btnImgSize.height;
    return CGRectMake(imageX, imageY, imageW, imageH);
}
@end
