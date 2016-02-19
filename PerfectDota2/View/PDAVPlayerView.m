//
//  PDAVPlayerView.m
//  PerfectDota2
//
//  Created by 谈Xx on 16/2/19.
//  Copyright © 2016年 谈Xx. All rights reserved.
//

#import "PDAVPlayerView.h"

@interface PDAVPlayerView()
@end

@implementation PDAVPlayerView

+ (Class)layerClass
{
    return [AVPlayerLayer class];
}

- (AVPlayer *)player
{
    return [(AVPlayerLayer *)[self layer] player];
}

- (void)setPlayer:(AVPlayer *)player
{
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

@end
