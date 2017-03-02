//
//  AppDelegate.m
//  PrefectDota2
//
//  Created by 谈Xx on 15/12/2.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "AppDelegate.h"
#import "OpenShareHeader.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>

@interface AppDelegate ()
{
    BMKMapManager* _mapManager;
}

@end


//static NSUncaughtExceptionHandler newhandler;
static void (*ori_NSSetUncaughtExceptionHandler)(NSUncaughtExceptionHandler * handler );
static void my_NSSetUncaughtExceptionHandler( NSUncaughtExceptionHandler * handler);

// 我的捕获handler
static NSUncaughtExceptionHandler custom_exceptionHandler;
static NSUncaughtExceptionHandler *oldhandler;
@implementation AppDelegate

// 注册
-(BOOL)install
{
    if(NSGetUncaughtExceptionHandler() != custom_exceptionHandler)
        oldhandler = NSGetUncaughtExceptionHandler();
    
        NSSetUncaughtExceptionHandler(&custom_exceptionHandler);

    return YES;
}
// 注册回原有的
void uninstall()
{
    NSSetUncaughtExceptionHandler(oldhandler);
}

// 我的实现
void custom_exceptionHandler(NSException *exception)
{
    NSArray *arr = [exception callStackSymbols];//得到当前调用栈信息
    NSString *reason = [exception reason];//非常重要，就是崩溃的原因
    NSString *name = [exception name];//异常类型
    // 本地化
    NSString * strM = [NSString stringWithFormat:@" Version : %@ \n ExceptionTime : %@ \n Exception type : %@ \n Crash reason : %@ \n Call stack info : %@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],[NSDate date],name, reason, arr];
    [[NSUserDefaults standardUserDefaults] setObject:strM forKey:@"EXCEPTION"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 注册回之前的handler
    uninstall();
    
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    NSSetUncaughtExceptionHandler(&my_uncaught_exception_handler);
//    my_NSSetUncaughtExceptionHandler(my_uncaught_exception_handler);
    
    [self install];
    // 增加异常捕获
//    NSSetUncaughtExceptionHandler(&getExceptionLog);
    
    PDLog(@"沙盒Caches目录-----%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]);
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:isFirstRefresh];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    // 增加网络监控
    [self addAFNetworkReachability];
    
    // 分享
    [OpenShare connectWeixinWithAppId:@"wxd6f6bc8b2d7f68ac"];
    [OpenShare connectWeiboWithAppKey:@"4138700651"];
    
    // 要使用百度地图，请先启动BaiduMapManager
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"AyvUE7Mf9GD1ZlOvVK7BNv9l"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    
    
    
    return YES;
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    //第二步：添加回调
    if ([OpenShare handleOpenURL:url])
    {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
//        // Configure for text only and offset down
//        hud.mode = MBProgressHUDModeText;
//        hud.labelText = @"分享成功";
//        hud.margin = 10.f;
//        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES afterDelay:1.5];

        return YES;
    }
    //这里可以写上其他OpenShare不支持的客户端的回调，比如支付宝等。
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // 讲道理的话 这里还要处理 分享后没有调回APP，之后自己切回来后shareView的隐藏
    // ...
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)addAFNetworkReachability
{
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSString *strStatus = @"";
        switch (status)
        {
            case AFNetworkReachabilityStatusNotReachable:
            {
                strStatus = @"当前无网络连接!";
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                //                strStatus = @"wifi";
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                //                strStatus = @"网络连接!";
            }
                break;
                
            default:
                break;
        }
        self.previousStatus = status;
        if (strStatus.length > 0)
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window animated:YES];
            
            // Configure for text only and offset down
            hud.mode = MBProgressHUDModeText;
            hud.labelText = strStatus;
            hud.margin = 20.f;
            hud.removeFromSuperViewOnHide = YES;
            
            [hud hide:YES afterDelay:3];
        }
    }];

}

@end
