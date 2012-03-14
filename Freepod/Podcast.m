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

-(NSInteger) getIdPodcast {
	return self->idPodcast;
}

-(NSString*) getNom {
	return self->nom;
}

-(NSString*) getDescription {
	return self->description;
}

-(NSString*) getExplicite {
	return self->explicite;
}

-(NSString*) getUrlSite {
	return self->urlSite;
}

-(NSString*) getUrlFreepod {
	return self->urlFreepod;
}

-(NSString*) getLogoNormal {
	return self->logoNormal;
}

-(NSString*) getLogoBanner {
	return self->logoBanner;
}

@end
