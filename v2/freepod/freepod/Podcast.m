//
//  Podcast.m
//  freepod
//
//  Created by Adrien Humilière on 17/02/13.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import "Podcast.h"

@implementation Podcast

- (id)initWithDictionnary:(NSDictionary*)dico {
    self = [super init];
    if (self) {
		if (dico != nil) {
			[self setPodcastId:[[dico objectForKey:@"id"] intValue]];
			[self setName:[dico objectForKey:@"nom"]];
			[self setResume:[dico objectForKey:@"description"]];
			[self setIsNew:[[dico objectForKey:@"isNew"] boolValue]];
			[self setIsExplicite:[[dico objectForKey:@"explicite"] boolValue]];
			[self setUrlFlux:[dico objectForKey:@"url_flux"]];
			[self setUrlFreepod:[dico objectForKey:@"url_freepod"]];
			[self setUrlSite:[dico objectForKey:@"url_site"]];
			[self setLogoBannerURL:[dico objectForKey:@"logo_banner"]];
			[self setLogoNormalURL:[dico objectForKey:@"logo_normal"]];
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
			[self setLastSynch:[dateFormatter dateFromString:[dico objectForKey:@"lastSynch"]]];
			[self setLastUpdate:[dateFormatter dateFromString:[dico objectForKey:@"lastUpdate"]]];
		} else {
			NSLog(@"Error initializing podcast : %@", dico);
		}
	}
    return self;
}

@end
