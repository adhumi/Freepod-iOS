//
//  Episode.m
//  Freepod
//
//  Created by Adrien Humilière on 15/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "Episode.h"

@implementation Episode

- (id)init {
    self = [super init];
    return self;
}

// Setters

-(void) setIdEpisode:(NSInteger)newIdEpisode {
	self->idEpisode = newIdEpisode;
}

-(void) setIdPodcast:(NSInteger)newIdPodcast {
	self->idPodcast = newIdPodcast;
}

-(void) setTitle:(NSString*)newTitle {
	self->title = newTitle;
}

-(void) setURL:(NSString*)newURL {
	self->url = newURL;
}

-(void) setType:(NSString*)newType {
	self->type = newType;
}

-(void) setDescription:(NSString*)newDescription {
	self->description = newDescription;
}

-(void) setAuthor:(NSString*)newAuthor {
	self->author = newAuthor;
}

-(void) setExplicite:(NSString*)newExplicite {
	self->explicite = newExplicite;
}

-(void) setDuration:(NSString*)newDuration {
	self->duration = newDuration;
}

-(void) setImage:(NSString*)newImage {
	self->image = newImage;
}

-(void) setKeywords:(NSString*)newKeywords {
	self->keywords = newKeywords;
}

-(void) setDate:(NSDate*)newDate {
	self->pubDate = newDate;
}

// Getters

-(NSInteger) idEpisode {
	return self->idEpisode;
}

-(NSInteger) idPodcast {
	return self->idPodcast;
}

-(NSString*) title {
	return self->title;
}

-(NSString*) urlSource {
	return self->url;
}

-(NSString*) type {
	return self->type;
}

-(NSString*) getDescription {
	return self->description;
}

-(NSString*) author {
	return self->author;
}

-(NSString*) explicite {
	return self->explicite;
}

-(NSString*) duration {
	return self->duration;
}

-(NSString*) image {
	return self->image;
}

-(NSString*) keywords {
	return self->keywords;
}

-(NSDate*) pubDate {
	return self->pubDate;
}


// Méthodes

-(NSString*) description {
	return self->title;
}

-(id) getJacquette:(NSInteger) width {
	NSLog(@"http://webserv.freepod.net/get-img-episode.php?id=%d&nom=logo_normal&width=%d", self->idEpisode, width);
	NSString *urlImage = [NSString stringWithFormat:@"http://webserv.freepod.net/get-img-episode.php?id=%d&nom=image&width=%d", self->idEpisode, width];
	NSURL *urlJacquette = [NSURL URLWithString:urlImage];
	NSData *data = [NSData dataWithContentsOfURL:urlJacquette];
	return [[UIImage alloc] initWithData:data];
}

- (int) getDurationInSeconds {
	NSArray *split = [self->duration componentsSeparatedByString:@":"];
	int nbSec = 0;

	if ([split count] == 3) {
		nbSec += [[[NSString alloc] initWithString:[split objectAtIndex:0]] intValue] * 60 * 60;
		nbSec += [[[NSString alloc] initWithString:[split objectAtIndex:1]] intValue] * 60;
		nbSec += [[[NSString alloc] initWithString:[split objectAtIndex:2]] intValue];
	}
	
	return nbSec;
}

@end
