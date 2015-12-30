//
//  SPViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/4.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "SPViewController.h"
#import "NewsTableViewController.h"
static CGFloat TagCount;

@interface SPViewController ()<PDTagViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet PDTagView *tagView;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;

@end

@implementation SPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *arr = @[@"最新",@"赛事",@"集锦",@"解说",@"直播"];
    self.tagView.tagNameList = arr;
    self.tagView.delegate = self;
    TagCount = self.tagView.tagNameList.count;

    
    [self removeSuperTitleView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (self.childViewControllers.count ==0)
    {
        [self.tagView setSubviewsFrame];
        
        [self addChildVc];
        // 添加默认控制器
        UIViewController *vc1 = [self.childViewControllers firstObject];
        [self.contentScrollView addSubview:vc1.view];
        vc1.view.frame = self.contentScrollView.bounds;
    }
}
// 创建childVC
-(void)addChildVc
{
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width*TagCount, -20);
    for (int i = 0; i < TagCount ; i++)
    {
        NewsTableViewController *newsVc = [[UIStoryboard storyboardWithName:@"News" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        newsVc.pdVideoTableType = i;
        newsVc.title = self.tagView.tagNameList[i];
        [self addChildViewController:newsVc];
    }
    
}
#pragma mark - UIScrollViewDelegate
// 代码控制偏移结束后 要载入对应才childVc
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
    // so 只要加入对应的要显示的ChildVc就可以
    NSInteger index = scrollView.contentOffset.x/self.contentScrollView.width;
    UIViewController *indexVc = self.childViewControllers[index];
    
    self.tagView.selectIndex = index;
    self.tagView.isTagChange = YES;
    // 如果不是第一次添加
    if (indexVc.view.superview)
        return;
    [self.contentScrollView addSubview:indexVc.view];
    // scrollView的bounds就是当前偏移后位置
    indexVc.view.frame = self.contentScrollView.bounds;
}

// 手指控制偏移结束后 要载入对应才childVc
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
// 滚动过程中需要实时变化tag 和 markView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 边缘就是负的了
    CGFloat offsetX = scrollView.contentOffset.x;
    CGFloat offsetABS = ABS(offsetX/scrollView.width);
    // 左滑 或者右滑时  每次左边的index
    NSInteger leftIndex = (int)offsetABS;
    // 对应的右边的index
    NSInteger rightIndex = offsetABS + 1;
    CGFloat rightScale = offsetABS - leftIndex;
    // 左边的就 取反了
    CGFloat leftScale = 1 - rightScale;
    
    // 防止第一个左滑是影响第一个
    // 防止最后一个右滑时影响自己
    if (rightIndex < TagCount && offsetX > 0)
    {
        if (self.tagView.isTagChange)
        {
            PDTagLabel *lblLeft = self.tagView.subviews[leftIndex];
            lblLeft.scalePercent = leftScale;
            
            // 如果是第一个 ，再往左不处理
            PDTagLabel *lblRight = self.tagView.subviews[rightIndex];
            lblRight.scalePercent = rightScale;
        }
        // 移动markView
        CGFloat markTranslate = (offsetX/scrollView.width)*self.tagView.TagLabelWidth;
        self.tagView.markView.transform = CGAffineTransformMakeTranslation(markTranslate, 0);
        
    }
    
    
}

#pragma mark - PDTagDelegate
-(void)pdTagView:(PDTagView *)tagView didSelectTaglabel:(PDTagLabel *)label
{
    CGFloat lblOffset = label.tag * self.contentScrollView.width;
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    // 点击之后不要让didscroll里去一个个的变化，但是要变化指定的
    if (self.tagView.selectIndex != label.tag)
    {
        self.tagView.isTagChange = NO;
    }
    // 这个原本是经过的lbl都会变化，会有没有重置的问题，做的修复。
    // 现改为中间的lbl不变化 就不需要了
    [self.tagView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PDTagLabel class]])
        {
            PDTagLabel *temp = (PDTagLabel*)obj;
            temp.scalePercent = 0;
        }
    }];
    label.scalePercent = 1.0;
    self.tagView.selectIndex = label.tag;
    [self.contentScrollView setContentOffset:CGPointMake(lblOffset, offsetY) animated:YES];
}

@end
