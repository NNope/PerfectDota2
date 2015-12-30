//
//  PDContainWebViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/21.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDLocalWebViewController.h"

#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PDAVPlayerViewController.h"

@implementation PDLocalWebViewController

-(instancetype)init
{
    if (self = [super init])
    {
        
    }
    return self;
}
- (instancetype)initWitnContentiew:(UIScrollView *)content
{
    
    if (self = [super init])
    {
        self.contenView = content;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    

    UIWebView *web = [[UIWebView alloc] initWithFrame:CGRectMake(0, self.isHideTitle?0:NAVIBARHEIGHT, SCREENWIDTH, self.isHideTitle?(self.view.bounds.size.height - NAVIBARHEIGHT - TABBARHEIGHT):self.view.bounds.size.height - NAVIBARHEIGHT)];
    self.webView = web;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    if (!self.webUrl && self.isHideTitle)
    {
        self.webUrl = [self.title isEqualToString:@"英雄"] ? HEROESPATH:ITEMSPATH;
    }

    [self loadWebUrl];
    
    // 添加手势
    if (self.isHideTitle)
    {
//        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(scrollContentView:)];
//        [self.webView addGestureRecognizer:pan];
//        self.webView.userInteractionEnabled = NO;
    }
    
}

- (void)scrollContentView:(UIPanGestureRecognizer *)recognize
{
//    CGPoint translaion = [recognize translationInView:recognize.view];
}
- (void)loadWebUrl
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}

#pragma mark - UIWebViewDelegate
/**
 当webView发送一个请求之前都会调用这个方法, 返回YES, 可以加载这个请求, 返回NO, 代表禁止加载这个请求
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = [request.URL.absoluteString stringByRemovingPercentEncoding];
    /*Users/TXx/Library/Developer/CoreSimulator/Devices/15C09B99-AE0D-43DE-ACE2-E6D1FFA971B7/data/Containers/Data/Application/5A805119-FDAC-4A39-B3E1-EFAA366F20E4/Documents/app1/static/webview.html?sendapp={\"action\":\"openUrl\",\"url\":\"local://heroes/i.html?earthshaker\",\"target\":\"_blank\"}"*/
    NSRange sendapp = [url rangeOfString:@"sendapp="];
    if (sendapp.length != 0)
    {
        NSString *strSendapp = [url substringFromIndex:sendapp.location+sendapp.length];
        // action url target
        NSArray *arr = [strSendapp componentsSeparatedByString:@","];
        // 判断action
        NSArray *arrAction = [arr[0] componentsSeparatedByString:@":"];
        if ([arrAction[1] isEqualToString:@"\"openUrl\""])// open
        {
            if (!self.hasPush)
            {
                NSString *toUrl = [NSString stringDealWithUrlString:arr[1]];
                // 打开一个新的webvc
                PDLocalWebViewController *web = [[PDLocalWebViewController alloc] init];
                web.webUrl = [APP1PATH stringByAppendingPathComponent:toUrl];
                web.hasPush = YES;
                web.titleView.titleType = PDTitleTypeLike;
                [self.navigationController pushViewController:web animated:YES];
                return NO;
            }

        }
        else if ([arrAction[1] isEqualToString:@"\"playVideo\""])// 播放视频
        {
            // {"action":"playVideo","url":"http://dota2.dl.wanmei.com/dota2/video/abilities/queen_of_pain_shadow_strike.mp4"}
            NSString *videoUrl = [NSString stringDealWithUrlString:arr[1]];
//            PDLog(@"%@",toUrl);
            PDAVPlayerViewController *playerVc = [[PDAVPlayerViewController alloc] init];
            playerVc.player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:videoUrl]];
            [self presentViewController:playerVc animated:YES completion:^{
                [playerVc.player play];
            }];
            
        }
//        else if ([arrAction[1] isEqualToString:@"\"setWindow\""])
//        {
//            if ([arr[1] rangeOfString:@"title"].length != 0)
//            {
//                // title "title":"撼地者"
//                NSRange localRange = [arr[1] rangeOfString:@":\""];
//                NSString *title = [arr[1] substringFromIndex:localRange.location+localRange.length];
//                title = [title substringToIndex:[title rangeOfString:@"\""].location];
//                PDLog(@"%@",title);
//                self.titleView.title = title;
//                return NO;
//            }
//        }
        

    }
       return YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (!self.isHideTitle)
    {
        NSString *title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        if ([title isEqualToString:@"英雄详细"])
            return;
        else
            self.titleView.title = title;
    }
}


@end
