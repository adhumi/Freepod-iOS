//
//  PlayerViewController.h
//  freepod
//
//  Created by Adrien Humilière on 11/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"
#import "ProgressSlider.h"
#import "PlayerDetailsViewController.h"

@interface PlayerViewController : UIViewController {
	Player *					_player;
	
	UIImageView *				_cover;
	
    UIButton *					_playPauseButton;
    ProgressSlider *			_progressBar;
    UILabel *					_progressTime;
    UILabel *					_remainingTime;
    UIView *					_waitingView;
    UIActivityIndicatorView *	_indicator;
	
    BOOL                        _isDraggingSlider;
    BOOL                        _isClosed;
    
    UILabel*                    _episodeTitle;
    UILabel*                    _podcastName;
}

+ (PlayerViewController*)instance;

@end
