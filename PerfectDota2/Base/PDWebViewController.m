//
//  PDWebInfoViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/11.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDWebViewController.h"
#import <WebKit/WebKit.h>

@interface PDWebViewController ()<WKNavigationDelegate,WKUIDelegate,PDTitleViewDelegate>
@property (nonatomic, weak) WKWebView *wkWebView;
@end

@implementation PDWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加webview
    WKWebView *web = [[WKWebView alloc]init];
    [self.view addSubview:web];
    self.wkWebView = web;
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    if (self.isHideTitle)
    {
        [self removeSuperTitleView];
    }
    else
    {
        // 增加title的监听
        [self.wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    }
    
    if (self.webUrl)
    {
        [self loadWebUrl];
    }
    
    [self setupNotReachableTip];
    
    
 
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    // 要记得移除KVO监听
    if (!self.isHideTitle)
    {
        [self.wkWebView removeObserver:self forKeyPath:@"title"];
    }
}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
        
    self.wkWebView.frame = CGRectMake(0, self.isHideTitle?0:NAVIBARHEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVIBARHEIGHT);
}

#pragma mark - WKNavigationDelegate

// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
{
    
    PDLog(@"页面加载失败时调用");
}
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    
    PDLog(@"页面开始加载时调用");
}
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    PDLog(@"页面开始加载时调用");
    if (self.failImg.hidden == YES)
    {
        [self setupLoadingImg];
    }
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    // 失败提示隐藏
    self.failImg.hidden = YES;
    self.refreshBtn.hidden = YES;
    
    // 隐藏菊花
    [self.loadingImage.layer removeAllAnimations];
    [self.loadingImage removeFromSuperview];
}

// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    PDLog(@"接收到服务器跳转请求之后调用");
}
// 在收到响应后，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler
//{
//    PDLog(@"在收到响应后，决定是否跳转");
//}
// 在发送请求之前，决定是否跳转
//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
//{
//    PDLog(@"%@",navigationAction.request.URL);
//   
//
//    if ([navigationAction.request.URL.absoluteString isEqualToString:@"http://www.dota2.com.cn/secretshop/"])
//    {
//        [self.wkWebView loadRequest:navigationAction.request];
////        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//    else
//    {
//        decisionHandler(WKNavigationActionPolicyAllow);
//    }
//}

/**
 *  处理需要打开新WKWebView的跳转
 *  target="_blank" 需要打开一个新窗口、
 *
 *  @return <#return value description#>
 */
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    // 难道是如果没有打开这个新窗口?
    if (navigationAction.targetFrame == nil)
    {
        PDLog(@"%@",navigationAction.request.URL.absoluteString);
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}
#pragma mark - PDTitleViewDelegate

-(void)pdTitleView:(PDTitleView *)titleView clickBackButton:(UIButton *)backbtn
{
    if ([self.wkWebView canGoBack])
    {
        [self.wkWebView goBack];
    }
    else
    {
        if (self.navigationController.topViewController == self)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


#pragma mark - private

- (void)setupLoadingImg
{
    
    UIImageView *loadingImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
    //    refreshingImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    loadingImage.center = self.view.center;
    [self.view addSubview:loadingImage];
    self.loadingImage = loadingImage;
    
    //使用CABasicAnimation创建基础动画
    CABasicAnimation *anima = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];//绕着z轴为矢量，进行旋转(@"transform.rotation.z"==@@"transform.rotation")
    anima.toValue = [NSNumber numberWithFloat:M_PI];
    anima.duration = 1.0f;
    anima.repeatCount = CGFLOAT_MAX;
    [self.loadingImage.layer addAnimation:anima forKey:@"rotateAnimation"];
}

// 创建无网络状态背景
- (void)setupNotReachableTip
{
    UIImageView *fail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"common_instruct_img"]];
    fail.center = self.view.center;
    self.failImg = fail;
    [self.view addSubview:self.failImg];
    self.failImg.hidden = YES;
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setTitle:@"点击重新加载" forState:UIControlStateNormal];
    [self.view addSubview:refreshBtn];
    self.refreshBtn = refreshBtn;
    CGSize size = [refreshBtn.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil]];
    refreshBtn.size = size;
    CGPoint newcenter = fail.center;
    newcenter.y = fail.center.y + fail.height/2 + 20;
    refreshBtn.center = newcenter;
    self.refreshBtn.hidden = YES;
    [self.refreshBtn addTarget:self action:@selector(loadWebUrl) forControlEvents:UIControlEventTouchUpInside];
    
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
        self.failImg.hidden = NO;
        self.refreshBtn.hidden = NO;
    }
}

/**
 *  加载url
 */
- (void)loadWebUrl
{
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}

// KVO监听变化 标题和进度条
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//    if ([keyPath isEqualToString:@"estimatedProgress"]) {
//        
//        if (object == webView) {
//            [self.progressView setAlpha:1.0f];
//            [self.progressView setProgress:self.currentSubView.webView.estimatedProgress animated:YES];
//            
//            if(self.currentSubView.webView.estimatedProgress >= 1.0f) {
//                
//                [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
//                    [self.progressView setAlpha:0.0f];
//                } completion:^(BOOL finished) {
//                    [self.progressView setProgress:0.0f animated:NO];
//                }];
//                
//            }
//        }
//        else
//        {
//            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
//        }
//        
//    }
    if ([keyPath isEqualToString:@"title"])
    {
        if (object == self.wkWebView)
        {
            // 如果已经设置了标题
            if (self.title.length <= 0)
            {
                self.titleView.title = self.wkWebView.title;
            }
            
        }
        else
        {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
            
        }
    }
    else
    {
        
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - Getter Setter

- (void)setNewsModel:(PDNewsModel *)newsModel
{
    _newsModel = newsModel;
    self.webUrl = newsModel.url;
    self.shareModel = [[PDShareModel alloc] init];
    self.shareModel.shareLink = newsModel.url;
    self.shareModel.shareTitle = newsModel.title;
    self.shareModel.shareDesc = newsModel.desc;
    
    UIImageView *thumb = [[UIImageView alloc] init];
    __weak typeof(self) weakself = self;
    [thumb sd_setImageWithURL:[NSURL URLWithString:newsModel.pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        weakself.shareModel.shereThumbImage = thumb.image;
        
    }];
}





@end
