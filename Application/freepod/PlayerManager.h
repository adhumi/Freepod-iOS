//
//  PlayerManager.h
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Episode.h"

@protocol PlayerManagerDelegate <NSObject>

- (void)prepareNewEpisode:(Episode *)episode;

@end

@interface PlayerManager : NSObject {
	
}

@property (nonatomic, assign) id <PlayerManagerDelegate> delegate;

@property (nonatomic, retain, readonly) Episode *		activeEpisode;

+ (PlayerManager *)instance;
- (void)playEpisode:(Episode *)episode;

@end
