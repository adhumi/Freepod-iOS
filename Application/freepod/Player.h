//
//  Player.h
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Episode.h"

@class Player;

@interface Player : NSObject {
    AVPlayer *		_audioPlayer;

	float			_loadedDuration;
}

@property (nonatomic, retain, readonly) Episode *		episode;

@property (nonatomic, assign) float						readPosition;
@property (nonatomic, assign, getter = isPlaying) BOOL	playing;
@property (nonatomic, assign, getter = isReady) BOOL	ready;

+ (Player *)instance;

// Player actions
- (void)play;
- (void)pause;
- (void)seek:(float)readPosition;
- (void)readEpisode:(Episode *)episode;

// Player state
- (float)loadedDuration;
- (float)duration;


@end
