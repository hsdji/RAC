//
//  videoViewController.m
//  db
//
//  Created by ekhome on 17/8/2.
//  Copyright © 2017年 xiaofei. All rights reserved.
//

#import "videoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ReactiveObjc.h"

@interface videoViewController ()
{
    AVPlayerLayer *playerLayer;
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
}
@property (nonatomic,strong)AVPlayer *avPlayer;
@end

@implementation videoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    x= self.view.frame.origin.x;
    y = self.view.frame.origin.y;
    width = self.view.frame.size.width;
    height= self.view.frame.size.height;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:)name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.str]];
    self.avPlayer = [AVPlayer playerWithPlayerItem:playerItem];
    playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = self.view.frame;
    [self.view.layer addSublayer:playerLayer];
    [self.avPlayer play];
     [[NSNotificationCenter defaultCenter] addObserver:self           selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification   object:playerItem];
}


- (void)playbackFinished:(NSNotification *)noti{
    
    self.navigationController.navigationBar.hidden= NO;
}



- (AVPlayer *)avPlayer {
	if(_avPlayer == nil) {
		_avPlayer = [[AVPlayer alloc] init];
	}
	return _avPlayer;
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.avPlayer pause];
    self.avPlayer = nil;
}

- (void)statusBarOrientationChange:(NSNotification *)notification{
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight||orientation ==UIInterfaceOrientationLandscapeLeft) {
        playerLayer.frame = CGRectMake(x, y, height, width);
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.navigationController.navigationBar.hidden= YES;
    }
    if (orientation == UIInterfaceOrientationPortraitUpsideDown||orientation == UIInterfaceOrientationPortrait){
        playerLayer.frame = CGRectMake(x,y, width, height);
        playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.navigationController.navigationBar.hidden= NO;
    }
}




@end
