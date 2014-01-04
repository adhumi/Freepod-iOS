//
//  Player.m
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "Player.h"

@implementation Player

static Player * instance;

+ (Player *)instance {
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    }
    return instance;
}

- (id)init {
	self = [super init];
	if (self) {
		[NSTimer scheduledTimerWithTimeInterval:(1.f/25.f) target:self selector:@selector(onTimerTick:) userInfo:nil repeats:YES];
	}
	return self;
}

- (void)onTimerTick:(NSTimer *)timer {
	if (!_audioPlayer) {
		[self setReadPosition:-1.f];
		[self setPlaying:NO];
		[self setReady:NO];
		
		return;
	}
	
	if ([[_audioPlayer currentItem] status] == AVPlayerItemStatusReadyToPlay) {
        NSArray * timeRangeArray = [_audioPlayer currentItem].loadedTimeRanges;
        CMTimeRange timeRange = [[timeRangeArray objectAtIndex:0] CMTimeRangeValue];
        _loadedDuration = CMTimeGetSeconds(timeRange.start) + CMTimeGetSeconds(timeRange.duration);
    }
	
	if ((!_ready && !_playing && [[_audioPlayer currentItem] status] == AVPlayerItemStatusReadyToPlay) || (!_ready && _loadedDuration - [self currentTime] > 5.0)) {
        _ready = YES;
        
        [self play];
    }
	
	if (_ready && (_loadedDuration <= ([self currentTime] + 0.5)) && !([self currentTime] >= ([self duration] - 0.5))) {
        [self play];
    }
	
	if (_ready && [self duration] <= [self currentTime]) {
        [self didFinishPlaying];
    }
}

- (void)didFinishPlaying {
	[self pause];
	[self seek:0];
}



#pragma mark - Player actions

- (void)play {
	[_audioPlayer play];
	[self setPlaying:YES];
}

- (void)pause {
	[_audioPlayer pause];
	[self setPlaying:NO];
}

- (void)seek:(float)readPosition {
	[_audioPlayer seekToTime:CMTimeMakeWithSeconds(readPosition, 1)];
}

- (void)readEpisode:(Episode *)episode {
	if (!episode) {
		return;
	}
	
	if ([_episode isEqual:episode]) {
		return;
	}
	
	_episode = episode;
	
	if (_audioPlayer) {
		[self pause];
	}
	_audioPlayer = [AVPlayer playerWithURL:[NSURL URLWithString:[_episode fileURL]]];
}



#pragma mark - Player state

- (float)loadedDuration {
	return _loadedDuration;
}

- (float)duration {
	if (_ready) {
		CMTime duration = [[_audioPlayer currentItem] duration];
		return CMTimeGetSeconds(duration);
	}
	
	return [_episode duration];
}

- (float)currentTime {
	CMTime position = [_audioPlayer currentTime];
    return CMTimeGetSeconds(position);
}

@end
