//
//  Podcast.m
//  Freepod
//
//  Created by Adrien Humilière on 14/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "Podcast.h"

@implementation Podcast

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

	// Getters

-(NSInteger) idPodcast {
	return self->idPodcast;
}

-(NSString*) nom {
	return self->nom;
}

-(NSString*) description {
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

@end
