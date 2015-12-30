//
//  ZXViewController.m
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "ZXViewController.h"
#import "PDTagLabel.h"
#import "PDTitleView.h"
#import "NewsTableViewController.h"

static CGFloat TagCount;
static CGFloat TagLabelWidth;
@implementation ZXViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    [self removeSuperTitleView];
    
    // 全部 官方 更新 媒体  赛事
    NSArray *arr = @[@"全部",@"官方",@"更新",@"媒体",@"赛事"];
    self.tagNameList = arr;
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (self.childViewControllers.count<=0)
    {
            [[NSNotificationCenter defaultCenter]postNotificationName:PDNewsAllRefresh object:nil];
    // 创建tagView
    [self addTagView];
    
    // 创建childVC 提前做了 发通知用到的
    [self addChildVc];
    
    // 添加默认控制器
        UIViewController *vc1 = [self.childViewControllers firstObject];
        vc1.view.frame = self.contentScrollView.bounds;
        
        vc1.view.frame = CGRectMake(0, -20, SCREENWIDTH, self.contentScrollView.height);
        
        [self.contentScrollView addSubview:vc1.view];

        
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
#pragma mark - addSubViews
// 创建tagView
-(void)addTagView
{
        TagCount = self.tagNameList.count;
        CGFloat lblW = self.TagView.width/TagCount;
        CGFloat lblH = self.TagView.height - 1;
        CGFloat lblY = 0;
        TagLabelWidth = lblW;
        for (int i = 0; i < TagCount; i++)
        {
            CGFloat lblX = i*lblW;
            PDTagLabel *lbl = [[PDTagLabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
            lbl.text = self.tagNameList[i];
            lbl.tag = i;
            lbl.userInteractionEnabled = YES;
            [self.TagView addSubview:lbl];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagLabelClick:)];
            [lbl addGestureRecognizer:tap];
            // 默认选中第一个
            if (i == 0)
            {
                lbl.scalePercent = 1.0;
            }
            
        }
        
        // 获取文字的宽度 不是label的宽度
        UILabel *lbl = (UILabel *)self.TagView.subviews[1];
        CGSize textSize =
        [lbl.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:lbl.font.fontName size:lbl.font.pointSize]}];
        // x要再计算下
        CGFloat markX = (lbl.width - textSize.width )/2;
        UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(markX, self.TagView.height-3, textSize.width, 3)];
        self.markView = redView;
        self.markView.backgroundColor = PDRedColor;
        [self.TagView addSubview:self.markView];
    
    self.isTagChange = YES;
}

// 创建childVC
-(void)addChildVc
{
    self.contentScrollView.showsVerticalScrollIndicator = NO;
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    self.contentScrollView.delegate = self;
    self.contentScrollView.pagingEnabled = YES;
    self.contentScrollView.contentSize = CGSizeMake(SCREENWIDTH*TagCount, -20);
    for (int i = 0; i < TagCount ; i++)
    {
        NewsTableViewController *newsVc = [[UIStoryboard storyboardWithName:@"News" bundle:[NSBundle mainBundle]] instantiateInitialViewController];
        // 新闻版块类别
        newsVc.pdNewsTableType = i;
        newsVc.title = self.tagNameList[i];
        [self addChildViewController:newsVc];
    }
    
}

// 进入扫一扫
- (IBAction)scanClick:(id)sender
{
    
    QRCodeReaderViewController *qrreader = [[QRCodeReaderViewController alloc] init];
    qrreader.modalPresentationStyle = UIModalPresentationFormSheet;
    qrreader.delegate = self;
    
    // block回调方式，仍然会执行didScanResult回调
    __weak typeof (self) wSelf = self;
    [qrreader setCompletionWithBlock:^(NSString *resultAsString) {
        
        [wSelf.navigationController popViewControllerAnimated:YES];
        [[[UIAlertView alloc] initWithTitle:@"" message:resultAsString delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil] show];
        
        
        // 扫描结果
//        _label.text = resultAsString;
        
    }];
    
    // 测试 push
    [self.navigationController pushViewController:qrreader animated:YES];
}

// tag点击
-(void)tagLabelClick:(UITapGestureRecognizer *)recognizer
{
    
    PDTagLabel *selectLabel = (PDTagLabel*)recognizer.view;
    CGFloat lblOffset = selectLabel.tag * self.contentScrollView.width;
    CGFloat offsetY = self.contentScrollView.contentOffset.y;
    // 点击之后不要让didscroll里去一个个的变化，但是要变化指定的
    if (self.selectIndex != selectLabel.tag)
    {
        self.isTagChange = NO;
    }
    [self.TagView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PDTagLabel class]])
        {
//            if (obj.tag != selectLabel.tag)
//            {
                PDTagLabel *temp = (PDTagLabel*)obj;
                temp.scalePercent = 0;
//            }
        }
    }];
    selectLabel.scalePercent = 1.0;
    self.selectIndex = selectLabel.tag;
    [self.contentScrollView setContentOffset:CGPointMake(lblOffset, offsetY) animated:YES];
}

#pragma mark - UIScrollViewDelegate
// 代码控制偏移结束后 要载入对应才childVc
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 结束后 tagView要做偏移，此项目tag不需要滚动，so
    
    // so 只要加入对应的要显示的ChildVc就可以
    NSInteger index = scrollView.contentOffset.x/self.contentScrollView.width;
    UIViewController *indexVc = self.childViewControllers[index];
    
    // 有个bug 强制别的恢复大小

    self.isTagChange = YES;
    self.selectIndex = index;
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
    /* 得到左右对应的缩放百分比
     比如往左了一点点，那么offset=0.9 取整后还是0
     对于缩放比例来说 右边的要变小一点点，就是 0.9-0=0.9
     -----内部的计算方式: 0.7+(1-0.7)*scale 所以传入0.9 会缩小一点点【原本是在右边的】
     */
    CGFloat rightScale = offsetABS - leftIndex;
    // 左边的就 取反了
    CGFloat leftScale = 1 - rightScale;
    
    // 防止第一个左滑是影响第一个
    // 防止最后一个右滑时影响自己
    if (rightIndex < TagCount && offsetX > 0)
    {
        if (self.isTagChange)
        {
            PDTagLabel *lblLeft = self.TagView.subviews[leftIndex+1];// 该死的里面多加了红条
            lblLeft.scalePercent = leftScale;
            
            // 如果是第一个 ，再往左不处理
            PDTagLabel *lblRight = self.TagView.subviews[rightIndex+1];
            lblRight.scalePercent = rightScale;
        }
        // 移动markView
        CGFloat markTranslate = (offsetX/scrollView.width)*TagLabelWidth;
        self.markView.transform = CGAffineTransformMakeTranslation(markTranslate, 0);

    }
}

@end
