//
//  PlayerManager.m
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "PlayerManager.h"

@implementation PlayerManager

static PlayerManager * instance;

+ (PlayerManager *)instance {
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    }
    return instance;
}

- (id)init {
	self = [super init];
	if (self) {
		//
	}
	return self;
}

- (void)playEpisode:(Episode *)episode {
	_activeEpisode = episode;
	
	[_delegate prepareNewEpisode:episode];
}

@end
