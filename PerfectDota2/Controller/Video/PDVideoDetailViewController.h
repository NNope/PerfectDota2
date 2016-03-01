//
//  PDVideoDetailViewController.h
//  PerfectDota2
//
//  Created by 谈Xx on 15/12/17.
//  Copyright © 2015年 谈Xx. All rights reserved.
//

#import "PDBaseViewController.h"
#import "PDAVPlayerView.h"
#import "PDNewestVideoModel.h"

@interface PDVideoDetailViewController : PDBaseViewController
@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic ,strong) AVPlayerLayer *playerLayer;
@property (weak, nonatomic) IBOutlet UIView *playerView;

@property (nonatomic, strong) PDNewestVideoModel *videoModel;



- (IBAction)cacheClick:(id)sender;
@end
