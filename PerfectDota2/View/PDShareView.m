//
//  PDShareView.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/23.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDShareView.h"
#import "PDShareButton.h"
#import "OpenShareHeader.h"

static CGFloat const WhiteHeight = 110;

@implementation PDShareView

//-(instancetype)initWithFrame:(CGRect)frame
//{
//    if (self = [super initWithFrame:frame])
//    {
//        [self setupBgView:frame];
//        [self showShareView];
//        
//    }
//    return self;
//}


- (instancetype)initWithFrame:(CGRect)frame ShareBtnImgs:(NSArray *)imgs btnTitles:(NSArray *)titles;
{
    if (self = [super initWithFrame:frame])
    {
        [self setupBgView:frame];
        [self setupShareBtnWithImgs:imgs titles:titles];
        [self showShareView];
    }
    return self;
}

- (void)setupBgView:(CGRect)frame
{
    UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
    self.bgView = bg;
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = 0;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView:)];
    [self.bgView addGestureRecognizer:tap];
    [self addSubview:self.bgView];
    
    UIView *share = [[UIView alloc] init];
    self.whiteView = share;
    self.whiteView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, WhiteHeight);
    self.whiteView.backgroundColor = [UIColor whiteColor];
    self.whiteView.alpha = 1;
    [self addSubview:self.whiteView];
    
    // 添加按钮 之后再封装出来
}

- (void)setupShareBtnWithImgs:(NSArray *)imgs titles:(NSArray *)titles
{
    for (int i =0; i < imgs.count; i++)
    {
        PDShareButton *shareBtn = [[PDShareButton alloc] init];
        [shareBtn setImage:[UIImage imageNamed:imgs[i]] forState:UIControlStateNormal];
        [shareBtn setTitle:titles[i] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        CGFloat btnW = self.whiteView.width/imgs.count;
        shareBtn.frame = CGRectMake(i*btnW, 0, btnW, self.whiteView.height);
        [self.whiteView addSubview:shareBtn];
    }
}

#pragma mark - show and hide 
- (void)shareBtnClick:(PDShareButton *)sender
{
    NSString *currentTitle = sender.currentTitle;
    
    OSMessage *msg=[[OSMessage alloc]init];
    msg.title = self.shareModel.shareTitle;
    msg.desc = self.shareModel.shareDesc;
    msg.link = self.shareModel.shareLink;
    msg.image = self.shareModel.shereThumbImage;
    // 如果是空 就分享APP
    if (!msg.link)
    {
        msg.title = @"";
        msg.desc = @"";
        msg.link = @"";
        msg.image = @"";
    }
    
    if ([currentTitle isEqualToString:@"微信朋友"])
    {
        //link
        [OpenShare shareToWeixinSession:msg Success:^(OSMessage *message) {
         
            [self showSuccessMsgBox];
            [self hideShareView:nil];

        } Fail:^(OSMessage *message, NSError *error) {
            [self hideShareView:nil];
        }];
        
        
    }
    else if ([currentTitle isEqualToString:@"微信朋友圈"])
    {
        
        [OpenShare shareToWeixinTimeline:msg Success:^(OSMessage *message) {
            
            [self showSuccessMsgBox];
            [self hideShareView:nil];
        } Fail:^(OSMessage *message, NSError *error) {
            
            [self hideShareView:nil];
        }];
    }
    else if ([currentTitle isEqualToString:@"QQ好友"])
    {
        
    }
    else if ([currentTitle isEqualToString:@"新浪微博"])
    {
        
    }
    else
    {
        PDLog(@"暂不支持该分享");
    }
    
//    [self hideShareView:nil];
    
}

- (void)showSuccessMsgBox
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"分享成功";
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

- (void)showShareView
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0.4;
        self.whiteView.transform = CGAffineTransformMakeTranslation(0, -WhiteHeight);
    } completion:^(BOOL finished) {
        nil;
    }];
}

// 点击分享后，暂时隐藏，不是真正移除
- (void)hideShareViewDidClick
{
    self.bgView.alpha = 0;
    self.whiteView.transform = CGAffineTransformIdentity;
}

// 真正的移除
- (void)hideShareView:(UITapGestureRecognizer *)gesture
{
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.alpha = 0;
        self.whiteView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

-(void)dealloc
{
    PDLog(@"dealloc");
}

@end
