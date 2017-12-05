//
//  RTMPTestVC.m
//  WWL
//
//  Created by Kristoffer Yap on 5/29/17.
//  Copyright © 2017 Allfree Group LLC. All rights reserved.
//

#import "RTMPTestVC.h"
#import <IJKMediaFrameWork/IJKFFMoviePlayerController.h>

@interface RTMPTestVC ()
{
    IJKFFMoviePlayerController* player;
}
@end

@implementation RTMPTestVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
//        player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:@"rtmp://184.72.239.149/vod/BigBuckBunny_115k.mov" withOptions:[IJKFFOptions optionsByDefault]];
    player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:@"rtmp://dev-wowza1.wwl.tv:1935/audiochat/test.stream" withOptions:[IJKFFOptions optionsByDefault]];
    
//    player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:self.videoURL withOptions:[IJKFFOptions optionsByDefault]];
    player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    player.view.frame = self.view.bounds;
    player.scalingMode = IJKMPMovieScalingModeAspectFit;
    player.shouldAutoplay = YES;
    
    [self.view addSubview:player.view];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self installMovieNotificationObservers];
    [player prepareToPlay];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [player play];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [player shutdown];
    [self removeMovieNotificationObservers];
}

-(void)viewDidLayoutSubviews {
    player.view.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) onPlayerStatusUpdated:(NSNotification*) notification {
    switch (player.loadState) {
            case IJKMPMovieLoadStatePlayable:
            NSLog(@"Playable");
            break;
            case IJKMPMovieLoadStatePlaythroughOK:
            NSLog(@"Playing");
            break;
            case IJKMPMovieLoadStateStalled:
            NSLog(@"Buffering");
            break;
        default:
            NSLog(@"Default");
            break;
    }
}


- (IBAction)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:player];
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
            case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
            case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
            case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (player.playbackState)
    {
            case IJKMPMoviePlaybackStateStopped: {
                NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)player.playbackState);
                break;
            }
            case IJKMPMoviePlaybackStatePlaying: {
                NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)player.playbackState);
                break;
            }
            case IJKMPMoviePlaybackStatePaused: {
                NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)player.playbackState);
                break;
            }
            case IJKMPMoviePlaybackStateInterrupted: {
                NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)player.playbackState);
                break;
            }
            case IJKMPMoviePlaybackStateSeekingForward:
            case IJKMPMoviePlaybackStateSeekingBackward: {
                NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)player.playbackState);
                break;
            }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)player.playbackState);
            break;
        }
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end
