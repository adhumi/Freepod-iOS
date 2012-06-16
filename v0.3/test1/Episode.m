//
//  Episode.m
//  Freepod
//
//  Created by Adrien Humilière on 15/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "Episode.h"

@implementation Episode

@synthesize jacquette;

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

-(void) setLastUpdateFromString:(NSString*)newDate {
	// Format Web Service : 2012-05-28 01:06:34
	
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	self->pubDate = [dateFormat dateFromString:newDate]; 
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

-(NSString*) getFormatedDuration {
	int nbSec = [self getDurationInSeconds];
		
	int hours = nbSec / 3600;
	int min = (nbSec - (3600 * hours)) / 60;
	int sec = nbSec - (3600 * hours) - (60 * min);
	
	if (nbSec == 0) {
		return @"";
	}
	
	return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, min, sec];
}

-(NSString*) getFormatedDurationHhMm {
	int nbSec = [self getDurationInSeconds];
	
	int hours = nbSec / 3600;
	int min = (nbSec - (3600 * hours)) / 60;
	int sec = nbSec - (3600 * hours) - (60 * min);
	
	if (nbSec == 0) {
		return @"";
	} else if (hours > 0) {
		return [NSString stringWithFormat:@"%dh%02d", hours, min];
	}
	return [NSString stringWithFormat:@"%dmin%02d", min, sec];
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

-(NSString*) formattedPubDate {
	NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
	[dateFormat setDateFormat:@"d MMMM yyyy"];	//@"EE, d LLLL yyyy HH:mm:ss Z"];
	return [dateFormat stringFromDate:self->pubDate]; 
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
	} else if ([split count] == 2) {
		nbSec += [[[NSString alloc] initWithString:[split objectAtIndex:0]] intValue] * 60;
		nbSec += [[[NSString alloc] initWithString:[split objectAtIndex:1]] intValue];
	}
	
	return nbSec;
}

- (BOOL) isVideo {
	NSArray *split = [self->type componentsSeparatedByString:@"/"];
	
	NSString *typeString = [split objectAtIndex:0];
	
	return ([typeString isEqualToString:@"video"] == YES || [typeString isEqualToString:@"VIDEO"] == YES || [typeString isEqualToString:@"Video"] == YES );
}

@end
