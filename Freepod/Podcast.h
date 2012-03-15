//
//  Podcast.h
//  Freepod
//
//  Created by Adrien Humilière on 14/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Podcast : NSObject {
		// NSInteger
	NSInteger idPodcast;
	
		//NSString
	NSString *nom;
	NSString *description;
	NSString *explicite;
	NSString *urlSite;
	NSString *urlFreepod;
	NSString *logoNormal;
	NSString *logoBanner;
	
		//NSDate
	NSDate *lastUpdate;
}

-(id) init;

-(void) setIdPodcast:(int)newIdPodcast;
-(void) setNom:(NSString*)newNom;
-(void) setDescription:(NSString*)newDescription;
-(void) setExplicite:(NSString*)newExplicite;
-(void) setUrlSite:(NSString*)newUrlSite;
-(void) setUrlFreepod:(NSString*)newUrlFreepod;
-(void) setLogoNormal:(NSString*)newLogoNormal;
-(void) setLogoBanner:(NSString*)newLogoBanner;

-(NSInteger) idPodcast;
-(NSString*) nom;
-(NSString*) description;
-(NSString*) explicite;
-(NSString*) urlSite;
-(NSString*) urlFreepod;
-(NSString*) logoNormal;
-(NSString*) logoBanner;

@end
