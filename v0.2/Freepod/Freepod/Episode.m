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

-(NSString*) url {
	return self->url;
}

-(NSString*) type {
	return self->type;
}

-(NSString*) description {
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

@end
