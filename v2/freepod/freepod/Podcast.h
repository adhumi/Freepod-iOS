//
//  Podcast.h
//  freepod
//
//  Created by Adrien Humilière on 17/02/13.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Podcast : NSObject {
	
}

@property (nonatomic, assign) int			podcastId;
@property (nonatomic, retain) NSString*		name;
@property (nonatomic, retain) NSString*		resume;
@property (nonatomic, retain) NSDate*		lastSynch;
@property (nonatomic, retain) NSDate*		lastUpdate;
@property (nonatomic, assign) BOOL			isNew;
@property (nonatomic, assign) BOOL			isExplicite;

@property (nonatomic, retain) NSString*		urlFlux;
@property (nonatomic, retain) NSString*		urlFreepod;
@property (nonatomic, retain) NSString*		urlSite;
@property (nonatomic, retain) NSString*		logoBannerURL;
@property (nonatomic, retain) NSString*		logoNormalURL;

@end
