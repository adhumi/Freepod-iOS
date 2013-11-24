//
//  PlayerViewController.h
//  freepod
//
//  Created by Adrien Humilière on 11/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Episode.h"

@interface PlayerViewController : UIViewController {
	UIImageView *				_cover;
	
    UIButton*                   _playPauseButton;
    UISlider*                   _progressBar;
    UILabel*                    _progressTime;
    UILabel*                    _remainingTime;
    UIView*                     _waitingView;
    UIActivityIndicatorView*    _indicator;
    
    AVPlayer*                   _audioPlayer;
    
    BOOL                        _isPlaying;
    BOOL                        _isReady;
    BOOL                        _isDraggingSlider;
    BOOL                        _isClosed;
    
    NSTimer*                    _timer;
    NSTimer*                    _preTimer;
    
    UILabel*                    _episodeTitle;
    UILabel*                    _podcastName;
}

@property (nonatomic, retain, readonly) Episode *		activeEpisode;

+ (PlayerViewController*)instance;

- (void)playEpisode:(Episode *)episode;

@end
