//
//  PlayerViewController.m
//  freepod
//
//  Created by Adrien Humilière on 11/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

static PlayerViewController* instance;

+ (PlayerViewController*)getInstance
{
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    }
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        [[self view] setBackgroundColor:[UIColor whiteColor]];
        
        UINavigationBar* navbar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 44)];
        [[self view] addSubview:navbar];
        
        navbar.topItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithTitle:@"Player" style:UIBarButtonItemStyleBordered target:self action:@selector(onClickCloseButton)];
        
        UIView* titleBg = [[UIView alloc] initWithFrame:CGRectMake(15 + 65 + 5, 60, 323, 67)];
        [titleBg addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mixTitleBg.png"]]];
        [[self view] addSubview:titleBg];
        
        _episodeTitle = [[UILabel alloc] initWithFrame:CGRectMake([titleBg frame].origin.x + 10, 70, 300, 20)];
        [_episodeTitle setBackgroundColor:[UIColor clearColor]];
        [_episodeTitle setText:@"title"];
        [_episodeTitle setTextColor:[UIColor darkTextColor]];
        [_episodeTitle setTextAlignment:UITextAlignmentLeft];
        [_episodeTitle setFont:[UIFont boldSystemFontOfSize:16]];
        [_episodeTitle setFont:[[_episodeTitle font] fontWithSize:22]];
        [_episodeTitle setNumberOfLines:1];
        [[self view] addSubview:_episodeTitle];
        
        _podcastName = [[UILabel alloc] initWithFrame:CGRectMake([titleBg frame].origin.x + 10 + 30, 95, 300, 20)];
        [_podcastName setBackgroundColor:[UIColor clearColor]];
        [_podcastName setText:@"name"];
        [_podcastName setTextColor:[UIColor orangeColor]];
        [_podcastName setTextAlignment:UITextAlignmentLeft];
        [_podcastName setFont:[[_podcastName font] fontWithSize:18]];
        [_podcastName setNumberOfLines:1];
        [[self view] addSubview:_podcastName];
        
        UIView* playerContainer = [[UIView alloc] initWithFrame:CGRectMake(15, 135, 393, 67)];
        [playerContainer addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mixPlayerPlayerBg.png"]]];
        [[self view] addSubview:playerContainer];
        
        _progressBar = [[UISlider alloc] initWithFrame:CGRectMake([playerContainer frame].origin.x + 60, [playerContainer frame].origin.y + ([playerContainer frame].size.height - 10) * 0.5 - 8, 322, 10)];
        [_progressBar setThumbImage:[UIImage imageNamed:@"mixSliderThumb.png"] forState:UIControlStateNormal];
        [_progressBar setMinimumTrackImage:[[UIImage imageNamed:@"mixSliderTrack.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] forState:UIControlStateNormal];
        [_progressBar setMaximumTrackImage:[[UIImage imageNamed:@"mixSliderTrack2.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0] forState:UIControlStateNormal];
        [_progressBar setMinimumValue:0.0];
        [_progressBar setMaximumValue:0.0];
        [_progressBar setValue:0.0];
        [_progressBar setContinuous:true];
        [_progressBar addTarget:self action:@selector(goToPosition) forControlEvents:UIControlEventTouchUpInside];
        [_progressBar addTarget:self action:@selector(goToPosition) forControlEvents:UIControlEventTouchUpOutside];
        [_progressBar addTarget:self action:@selector(isDragging) forControlEvents:UIControlStateHighlighted];
        [[self view] addSubview:_progressBar];
        
        _remainingTime = [[UILabel alloc] initWithFrame:CGRectMake([playerContainer frame].origin.x + 217 + 60, [playerContainer frame].origin.y + ([playerContainer frame].size.height - 10) * 0.5 + 8, 100, 20)];
        [_remainingTime setBackgroundColor:[UIColor clearColor]];
        [_remainingTime setText:@"- 00:00"];
        [_remainingTime setTextColor:[UIColor darkTextColor]];
        [_remainingTime setFont:[[_remainingTime font] fontWithSize:13]];
        [_remainingTime setTextAlignment:UITextAlignmentRight];
        [[self view] addSubview:_remainingTime];
        
        _progressTime = [[UILabel alloc] initWithFrame:CGRectMake([playerContainer frame].origin.x + 65, [playerContainer frame].origin.y + ([playerContainer frame].size.height - 10) * 0.5 + 8, 100, 20)];
        [_progressTime setBackgroundColor:[UIColor clearColor]];
        [_progressTime setText:@"00:00"];
        [_progressTime setTextColor:[UIColor darkTextColor]];
        [_progressTime setTextAlignment:UITextAlignmentLeft];
        [_progressTime setFont:[[_progressTime font] fontWithSize:13]];
        [[self view] addSubview:_progressTime];
        
        _playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playPauseButton setBackgroundImage:[UIImage imageNamed:@"mixPlayButton.png"] forState:UIControlStateNormal];
        [_playPauseButton setBackgroundImage:[UIImage imageNamed:@"mixPauseButton.png"] forState:UIControlStateSelected];
        [_playPauseButton setFrame:CGRectMake([playerContainer frame].origin.x + 10, [playerContainer frame].origin.y + ([playerContainer frame].size.height - 40) * 0.5, 40, 40)];
        [_playPauseButton addTarget:self action:@selector(playButton) forControlEvents:UIControlEventTouchUpInside];
        [_playPauseButton setHidden:YES];
        [[self view] addSubview:_playPauseButton];
        
        _waitingView = [[UIView alloc] initWithFrame:CGRectMake([playerContainer frame].origin.x + 10, [playerContainer frame].origin.y + ([playerContainer frame].size.height - 40) * 0.5, 40, 40)];
        [_waitingView addSubview:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mixWaitingButton.png"]]];
        _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        [_indicator setFrame:CGRectMake((40 - 20) * 0.5, (40 - 20) * 0.5, 20, 20)];
        [_indicator startAnimating];
        [_waitingView addSubview:_indicator];
        [[self view] addSubview:_waitingView];
    }
    return self;
}

- (void)preparePlayer:(NSDictionary*)episode {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:@"URL"];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        UIImageView* cover = [[UIImageView alloc] initWithImage:img];
        [cover setFrame:CGRectMake(15, 60, 65, 65)];
        [[self view] addSubview:cover];
    });
    
    [self initPlayer];
}


- (void)goToPosition {
    _isDraggingSlider = NO;
    CMTime t = CMTimeMakeWithSeconds(_progressBar.value, 1);
	[_audioPlayer seekToTime:t];
	[self updatePlayer];
}

- (void)isDragging {
    _isDraggingSlider = YES;
}

- (void)initPlayer {
    _audioPlayer = [AVPlayer playerWithURL:[NSURL URLWithString:@""]];
    _preTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updatePlayer) userInfo:nil repeats:YES];
}

- (void)interruptPlayer {
    if(_isPlaying) {
        [self playButton];
    }
    
    if (_preTimer != nil) [_preTimer invalidate];
    _preTimer = nil;
}

- (void)playButton {
    if (_isPlaying) {
        [_playPauseButton setSelected:NO];
        [_audioPlayer pause];
        _isPlaying = NO;
        if (_timer != nil) [_timer invalidate];
        _timer = nil;
    } else {
        [_playPauseButton setSelected:YES];
        [_audioPlayer play];
        _isPlaying = YES;
        _timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/25.0) target:self selector:@selector(updatePlayer) userInfo:nil repeats:YES];
    }
}

- (void)updatePlayer {
    
    if(_isClosed)           return;
    if(!_audioPlayer)       return;
    
    double loadedDuration = 0;
    double startDuration = 0;
    
    if ([[_audioPlayer currentItem] status] == AVPlayerItemStatusReadyToPlay) {
        NSArray * timeRangeArray = [_audioPlayer currentItem].loadedTimeRanges;
        CMTimeRange timeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        loadedDuration = CMTimeGetSeconds(timeRange.duration);
        startDuration = CMTimeGetSeconds(timeRange.start);
    }
    
    if ((!_isReady &&
         !_isPlaying &&
         [[_audioPlayer currentItem] status] == AVPlayerItemStatusReadyToPlay &&
         [[_audioPlayer currentItem] isPlaybackLikelyToKeepUp]) || (
                                                                    !_isReady && loadedDuration > 5.0))
    {
        [_progressBar setMaximumValue:CMTimeGetSeconds([[_audioPlayer currentItem] duration])];
        
        _isReady = YES;
        
        if (_preTimer != nil) [_preTimer invalidate];
        _preTimer = nil;
        
        [_indicator stopAnimating];
        [_waitingView setHidden:YES];
        [_playPauseButton setHidden:NO];
        
        [self playButton];
    }
    
    CMTime duration = [[_audioPlayer currentItem] duration];
    float seconds = CMTimeGetSeconds(duration);
	int minutesDef = lroundf(seconds) / 60;
	int secondsDef = seconds - (minutesDef * 60);
    NSString* txt = [NSString stringWithFormat:@"%02d:%02d",minutesDef,secondsDef];
    [_remainingTime setText:txt];
    
    CMTime current = [_audioPlayer currentTime];
    seconds = CMTimeGetSeconds(current);
	minutesDef = lroundf(seconds) / 60;
	secondsDef = seconds - (minutesDef * 60);
    txt = [NSString stringWithFormat:@"%02d:%02d",minutesDef,secondsDef];
    [_progressTime setText:txt];
    
    if (_isReady && !_isDraggingSlider) {
        [_progressBar setValue:seconds animated:NO];
    }
    
    if (_isReady && ((loadedDuration + startDuration) <= (CMTimeGetSeconds(current) + 0.5)) && !(CMTimeGetSeconds(current) >= (CMTimeGetSeconds(duration) - 0.5))) {
        [self playButton];
    }
    
    if (_isReady && CMTimeGetSeconds(duration) <= CMTimeGetSeconds(current)) {
        [self itemDidFinishPlaying];
    }
}

-(void)itemDidFinishPlaying {
    if (_timer != nil) [_timer invalidate];
    _timer = nil;
    _isPlaying = NO;
    [_playPauseButton setSelected:NO];
	CMTime t = CMTimeMakeWithSeconds(0, 1);
	[_audioPlayer pause];
    [_audioPlayer seekToTime:t];
	[self updatePlayer];
}

@end
