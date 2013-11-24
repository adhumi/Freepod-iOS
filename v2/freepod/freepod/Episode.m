//
//  Episode.m
//  freepod
//
//  Created by Adrien Humilière on 17/02/13.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import "Episode.h"

@implementation Episode

- (id)initWithDictionnary:(NSDictionary*)dico {
    self = [super init];
    if (self) {
		if (dico != nil) {
			[self setEpisodeId:[[dico objectForKey:@"id"] intValue]];
			[self setPodcastId:[[dico objectForKey:@"id_podcast"] intValue]];
			[self setAuthor:[dico objectForKey:@"author"]];
			[self setResume:[dico objectForKey:@"description"]];
			[self setIsExplicite:[[dico objectForKey:@"explicite"] boolValue]];
			[self setCoverURL:[dico objectForKey:@"image"]];
			[self setKeywords:[dico objectForKey:@"keywords"]];
			[self setTitle:[dico objectForKey:@"title"]];
			[self setMimeType:[dico objectForKey:@"type"]];
			[self setFileURL:[dico objectForKey:@"url"]];
			
			NSArray *split = [[dico objectForKey:@"duration"] componentsSeparatedByString:@":"];
			float nbSec = 0;
			if ([split count] == 3) {
				nbSec += [[split objectAtIndex:0] intValue] * 60 * 60;
				nbSec += [[split objectAtIndex:1] intValue] * 60;
				nbSec += [[split objectAtIndex:2] intValue];
			} else if ([split count] == 2) {
				nbSec += [[split objectAtIndex:0] intValue] * 60;
				nbSec += [[split objectAtIndex:1] intValue];
			}
			[self setDuration:nbSec];
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			[self setPubDate:[dateFormatter dateFromString:[dico objectForKey:@"pubDate"]]];
		} else {
			NSLog(@"Error initializing podcast : %@", dico);
		}
	}
    return self;
}

- (NSString *)description {
	return _title;
}

@end
