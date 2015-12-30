//
//  PDAdManager.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/7.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDAdManager.h"
#import "PDNetworkTool.h"
#import "UIImageView+WebCache.h"
// 新图片的路径 Doc/adnew.png 或者用stringByAppendingPathComponent
#define kCachedNewImage     ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingString:@"/adnew.png"])
// 当前图片的路径 也是旧图片的路径
#define kCachedCurrentImage ([[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingString:@"/adcurrent.png"])

static NSString *const AdImgNameKey = @"AdImgName";

@implementation PDAdManager

// 是否需要展示 就是判断本地有没有图片
+ (BOOL)isShouldDisplayAd
{
    return ([[NSFileManager defaultManager]fileExistsAtPath:kCachedCurrentImage isDirectory:NULL] || [[NSFileManager defaultManager]fileExistsAtPath:kCachedNewImage isDirectory:NULL]);
}

// 取得需要展示的图片--之前做过下载了 是有new的
+ (UIImage *)getAdImage
{
    if ([[NSFileManager defaultManager]fileExistsAtPath:kCachedNewImage isDirectory:NULL])
    {
        // 有最新的 把当前的删除--------
        [[NSFileManager defaultManager]removeItemAtPath:kCachedCurrentImage error:nil];
        // 把最新的作为当前的------------
        [[NSFileManager defaultManager]moveItemAtPath:kCachedNewImage toPath:kCachedCurrentImage error:nil];
    }
    // 返回当前的图片 其实是最新的
    return [UIImage imageWithData:[NSData dataWithContentsOfFile:kCachedCurrentImage]];
}

/**
 *  请求最新的广告图
 */
+ (void)loadLatestAdImage
{
    /*http://www.dota2.com.cn/wapnews/appUpdate.html?1449544968.27624
     "flashImage":
     {
     "url": "",
     "size_960": "http://www.dota2.com.cn/resources/jpg/151123/10251448274712770.jpg",
     "size_1136": "http://www.dota2.com.cn/resources/jpg/151123/10251448274713877.jpg",
     "size_2048": "http://www.dota2.com.cn/resources/jpg/151123/10251448274718328.jpg",
     }
     */
    // 一个时间戳参数 距离1970年多少秒
    NSInteger now = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *path = [NSString stringWithFormat:@"http://www.dota2.com.cn/wapnews/appUpdate.html?%ld/",(long)now];
    // 获取一个没有baseUrl的Manager对象
    [[[PDNetworkTool sharedNetworkToolsWithoutBaseUrl]GET:path parameters:nil success:^(NSURLSessionDataTask *task, NSDictionary* responseObject) {
        // 如果成功了
        NSDictionary *flashImg = [responseObject valueForKey:@"flashImage"];
        NSString *imgSize = [NSString stringWithFormat:@"size_%d",(int)[UIScreen mainScreen].bounds.size.height*2];
        // 好蠢 没有6的尺寸
        if (IS_Iphone6)
            imgSize = @"size_1136";
        // url
        NSString *imgUrl = flashImg[imgSize];
        NSString *imgName = [self getImgNameWithUrl:imgUrl];
        // 取到上一次下载的的img
        NSString *oldImgName = [[NSUserDefaults standardUserDefaults] stringForKey:AdImgNameKey];
        if (imgUrl && imgUrl.length > 0 && ![imgName isEqualToString:oldImgName])
        {
            // size_960 size_1136 size_2048
            // 不用每次下载
            [self downloadImage:imgUrl];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        PDLog(@"%@",error);
    }] resume];
}


/**
 *  下载图片
 *  @param imageUrl
 */
+ (void)downloadImage:(NSString *)imageUrl
{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:imageUrl]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // 写下来 作为新的
        if (data) {
            [data writeToFile:kCachedNewImage atomically:YES];
            // 记录当前已下载的图片名
            [[NSUserDefaults standardUserDefaults] setValue:[self getImgNameWithUrl:imageUrl] forKey:AdImgNameKey];
            PDLog(@"沙盒Caches目录-----%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]);
        }
    }];
    [task resume];
}

+(NSString *)getImgNameWithUrl:(NSString *)url
{
    NSArray *arr = [url componentsSeparatedByString:@"/"];
    return [arr lastObject];
}
@end
