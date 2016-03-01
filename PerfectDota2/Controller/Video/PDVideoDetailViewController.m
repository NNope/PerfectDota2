
//  PDVideoDetailViewController.m
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDVideoDetailViewController.h"

@implementation PDVideoDetailViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.titleView.title = @"视频";
    self.titleView.titleType = PDTitleTypeLikeAndShare;
    
    PDLog(@"%@",self.videoModel);
    
    // 发送请求获取视频info
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    [param setObject:@"wanmeidota2" forKey:@"appid"];
//    [param setObject:@"0daec764d638e42e70690f98e0b1bbad" forKey:@"sig"];
//    [param setObject:@"mp4" forKey:@"type"];
//    [param setObject:self.videoModel.link forKey:@"url"];
//    
//    NSString *Url = [NSString stringWithFormat:@"http://msgpush.dota2.com.cn:8282/api/public/video/youkuVideoFile"];
//    PDLog(@"%@",param);
//    AFHTTPSessionManager *mr = [[AFHTTPSessionManager alloc] init];
//    // 置空 从NSdata
//    mr.responseSerializer = [AFHTTPResponseSerializer serializer];
////    mr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", nil];
//    [mr POST:Url parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        // 先转为字符串
//        NSString *strData = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        // 解析为字典
//        NSDictionary *dict = [NSString parseJSONStringToNSDictionary:strData];
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        PDLog(@"%@",error);
//    }];

    
    // 视频url
    NSURL *videoUrl = [NSURL URLWithString:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"];
    // 创建一个item
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    // 创建player
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    // 创建layer
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //视频填充模式
    self.playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    [self.playerView.layer addSublayer:self.playerLayer];
    
    // 结束的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem]; // 监听2个属性
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];// 监听loadedTimeRanges属性 缓冲
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.playerLayer.frame = self.playerView.bounds;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
//    [self.player pause];
//    [self.player.currentItem cancelPendingSeeks];
//    [self.player.currentItem.asset cancelLoading];
//    self.player = nil;
//    self.playerItem = nil;
}

-(void)dealloc
{
    PDLog(@"dealloc");
}

#pragma mark - 监听
/**
 *  KVO监听
 *
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"])
    {
        if ([playerItem status] == AVPlayerStatusReadyToPlay)
        {
            NSLog(@"AVPlayerStatusReadyToPlay");
//            self.stateButton.enabled = YES;
            // 获取视频总长度
            CMTime duration = self.playerItem.duration;
            // 转换成秒
            CGFloat totalSecond = playerItem.duration.value / playerItem.duration.timescale;
            // 总时间 转换成时间格式字符串
//            _totalTime = [self convertTime:totalSecond];
            
            // 自定义UISlider外观
//            [self customVideoSlider:duration];
            
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            [self monitoringPlayback:self.playerItem];// 监听播放状态
        }
        else if ([playerItem status] == AVPlayerStatusFailed) // 失败
        {
            NSLog(@"AVPlayerStatusFailed");
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"])
    {
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        NSLog(@"Time Interval缓冲:%f",timeInterval);
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
//        [self.videoProgress setProgress:timeInterval / totalDuration animated:YES];
    }
}

// 计算缓冲进度
- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

// 转换成时间格式
- (NSString *)convertTime:(CGFloat)second
{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1)
    {
        [formatter setDateFormat:@"HH:mm:ss"];
    }
    else
    {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

/**
 *  monitoringPlayback用于监听每秒的状态，- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block;此方法就是关键，interval参数为响应的间隔时间，这里设为每秒都响应，queue是队列，传NULL代表在主线程执行。可以更新一个UI，比如进度条的当前时间等。
 *
 *  @param playerItem <#playerItem description#>
 */
- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
//        [self updateVideoSlider:currentSecond];
        NSString *timeString = [self convertTime:currentSecond];
//        self.timeLabel.text = [NSString stringWithFormat:@"%@/%@",timeString,_totalTime];
    }];
}

#pragma mark - 事件
- (IBAction)cacheClick:(id)sender {
    [self.player play];
}
@end
