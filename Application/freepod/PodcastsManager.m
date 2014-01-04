//
//  PodcastsManager.m
//  freepod
//
//  Created by Adrien Humilière on 17/02/13.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import "PodcastsManager.h"

@implementation PodcastsManager

static PodcastsManager * instance;

+ (PodcastsManager *)instance {
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    }
    return instance;
}

- (id)init {
	self = [super init];
	if (self) {
		[self update];
		
		_podcasts = [NSMutableArray array];
	}
	return self;
}

- (void)update {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:@"http://www.adhumi.fr/api/get.php?podcasts" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self parsePodcastsJSON:(NSArray *)responseObject];
		
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PODCASTS_LIST_UPDATE object:nil];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Erreur lors de la mise à jour de la liste des podcasts" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
	}];
}

- (void)updatePodcast:(Podcast *)podcast {
	NSString * requestURL = [NSString stringWithFormat:@"http://www.adhumi.fr/api/get.php?episodes=%d", [podcast podcastId]];
	
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
	[manager GET:requestURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[self parseEpisodesJSON:(NSArray *)responseObject forPodcast:podcast];
		
		
		[[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_EPISODES_LIST_UPDATE object:podcast];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Error: %@", error);
		
		UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Erreur lors de la mise à jour de la liste des épisodes" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alert show];
	}];
}

- (void)parsePodcastsJSON:(NSArray*)array {
	[_podcasts removeAllObjects];
	
	for (NSDictionary * podcastDic in array) {
		Podcast * podcast = [[Podcast alloc] initWithDictionnary:podcastDic];
		[_podcasts addObject:podcast];
	}
		
	NSLog(@"Parsing podcasts complete : %@", _podcasts);
}

- (void)parseEpisodesJSON:(NSArray*)array forPodcast:(Podcast *)podcast {
	[[podcast episodes] removeAllObjects];
		
	for (NSDictionary * episodeDic in array) {
		Episode * episode = [[Episode alloc] initWithDictionnary:episodeDic];
		[episode setPodcast:podcast];
		[episode setPodcastId:[podcast podcastId]];
		[episode setPodcastName:[podcast name]];
		
		[[podcast episodes] addObject:episode];
	}
	
	if ([[podcast episodes] count] > 0) {
		NSUInteger i = 0;
		NSUInteger j = [[podcast episodes] count] - 1;
		while (i < j) {
			[[podcast episodes] exchangeObjectAtIndex:i withObjectAtIndex:j];
			i++;
			j--;
		}
	}
	
	NSLog(@"Parsing episodes complete : %@", [podcast episodes]);
}

@end
