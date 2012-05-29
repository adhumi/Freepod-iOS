//
//  Episode.h
//  Freepod
//
//  Created by Adrien Humilière on 15/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episode : NSObject {
	// NSInteger
	NSInteger idEpisode;
	NSInteger idPodcast;
	
	//NSString
	NSString *title;
	NSString *url;
	NSString *type;
	NSString *description;
	NSString *author;
	NSString *explicite;
	NSString *duration;
	NSString *image;
	NSString *keywords;
	
	//NSDate
	NSDate *pubDate;
}

-(id) init;

-(void) setIdEpisode:(NSInteger)newIdEpisode;
-(void) setIdPodcast:(NSInteger)newIdPodcast;
-(void) setTitle:(NSString*)newTitle;
-(void) setURL:(NSString*)newURL;
-(void) setType:(NSString*)newType;
-(void) setDescription:(NSString*)newDescription;
-(void) setAuthor:(NSString*)newAuthor;
-(void) setExplicite:(NSString*)newExplicite;
-(void) setDuration:(NSString*)newDuration;
-(void) setImage:(NSString*)newImage;
-(void) setKeywords:(NSString*)newKeywords;
-(void) setDate:(NSDate*)newDate;
-(void) setLastUpdateFromString:(NSString*)newDate;

-(NSInteger) idEpisode;
-(NSInteger) idPodcast;
-(NSString*) title;
-(NSString*) urlSource;
-(NSString*) type;
-(NSString*) getDescription;
-(NSString*) description;
-(NSString*) author;
-(NSString*) explicite;
-(NSString*) duration;
-(NSString*) image;
-(NSString*) keywords;
-(NSDate*) pubDate;
-(NSString*) formattedPubDate;


-(id) getJacquette:(NSInteger) width;
- (int) getDurationInSeconds;

@end
