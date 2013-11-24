//
//  PodcastsManager.h
//  freepod
//
//  Created by Adrien Humilière on 17/02/13.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Podcast.h"

#define NOTIFICATION_PODCASTS_LIST_UPDATE @"podcastsListUpdate"
#define NOTIFICATION_EPISODES_LIST_UPDATE @"espisodesListUpdate"

@interface PodcastsManager : NSObject <NSURLConnectionDelegate> {
	
}

@property (nonatomic, retain) NSMutableArray * podcasts;

+ (PodcastsManager *)instance;
- (void)update;
- (void)updatePodcast:(Podcast *)podcast;

@end
