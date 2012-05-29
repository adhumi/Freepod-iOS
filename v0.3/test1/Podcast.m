//
//  Podcast.m
//  Freepod
//
//  Created by Adrien Humilière on 14/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "Podcast.h"
#import "Episode.h"

@implementation Podcast

@synthesize idPodcast;


-(id) init {
	self = [super init];
	return self;
}

// Setters

-(void) setIdPodcast:(int)newIdPodcast {
	self->idPodcast = newIdPodcast;
}

-(void) setNom:(NSString*)newNom {
	self->nom = newNom;
}

-(void) setDescription:(NSString*)newDescription {
	self->description = newDescription;
}

-(void) setExplicite:(NSString*)newExplicite {
	self->explicite = newExplicite;
}

-(void) setUrlSite:(NSString*)newUrlSite {
	self->urlSite = newUrlSite;
}

-(void) setUrlFreepod:(NSString*)newUrlFreepod {
	self->urlFreepod = newUrlFreepod;
}

-(void) setLogoNormal:(NSString*)newLogoNormal {
	self->logoNormal = newLogoNormal;
}

-(void) setLogoBanner:(NSString*)newLogoBanner {
	self->logoBanner = newLogoBanner;
}

-(void) setLastUpdateFromString:(NSString*)newDate {
	// "Tue, 25 May 2010 12:53:58 +0000";
	// Format Web Service : 2012-05-28 01:06:34
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];	//@"EE, d LLLL yyyy HH:mm:ss Z"];
	self->lastUpdate = [dateFormat dateFromString:newDate]; 
}


// Getters

-(int) idPodcast {
	return self->idPodcast;
}

-(NSString*) nom {
	return self->nom;
}

-(NSString*) getDescription {
	return self->description;
}

-(NSString*) explicite {
	return self->explicite;
}

-(NSString*) urlSite {
	return self->urlSite;
}

-(NSString*) urlFreepod {
	return self->urlFreepod;
}

-(NSString*) logoNormal {
	return self->logoNormal;
}

-(NSString*) logoBanner {
	return self->logoBanner;
}

// Methodes

-(void) addEpisode:(Episode*)newEpisode {
	[episodes addObject:newEpisode];
}

-(NSString*) description {
	return [NSString stringWithFormat:@"%@", self->nom];
}

-(id) getAllEpisodes {
	return self->episodes;
}

-(id) getJacquette:(NSInteger) width {
	NSLog(@"http://webserv.freepod.net/get-img-podcast.php?id=%d&nom=logo_normal&width=%d", self->idPodcast, width);
	NSString *urlImage = [NSString stringWithFormat:@"http://webserv.freepod.net/get-img-podcast.php?id=%d&nom=logo_normal&width=%d", self->idPodcast, width];
	NSURL *url = [NSURL URLWithString:urlImage];
	NSData *data = [NSData dataWithContentsOfURL:url];
	return [[UIImage alloc] initWithData:data];
}

-(id) getBanner:(NSInteger) width {
	NSLog(@"http://webserv.freepod.net/get-img-podcast.php?id=%d&nom=logo_banner&width=%d", self->idPodcast, width);
	NSString *urlImage = [NSString stringWithFormat:@"http://webserv.freepod.net/get-img-podcast.php?id=%d&nom=logo_banner&width=%d", self->idPodcast, width];
	NSURL *url = [NSURL URLWithString:urlImage];
	NSData *data = [NSData dataWithContentsOfURL:url];
	return [[UIImage alloc] initWithData:data];
}

-(void) initEpisodes {
	self->episodes = [[NSMutableArray alloc] init];
}

@end
