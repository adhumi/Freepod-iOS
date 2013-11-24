//
//  Episode.h
//  freepod
//
//  Created by Adrien Humilière on 17/02/13.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Episode : NSObject {
	
}

@property (nonatomic, assign) int				episodeId;
@property (nonatomic, assign) int				podcastId;
@property (nonatomic, retain) NSString*			author;
@property (nonatomic, retain) NSString*			resume;
@property (nonatomic, assign) BOOL				isExplicite;
@property (nonatomic, retain) NSString*			coverURL;
@property (nonatomic, retain) NSString*			keywords;
@property (nonatomic, retain) NSString*			title;
@property (nonatomic, retain) NSString*			mimeType;
@property (nonatomic, retain) NSString*			fileURL;
@property (nonatomic, assign) float				duration;
@property (nonatomic, retain) NSDate*			pubDate;

- (id)initWithDictionnary:(NSDictionary*)dico;

@end
