//
//  PodcastViewController.h
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"

@interface PodcastViewController : UITableViewController<NSURLConnectionDelegate, UITableViewDelegate> {
    NSMutableData*      _jsonData;
    NSArray*			_episodes;
}

@property (nonatomic, assign) int       podcastId;

- (id)initWithPodcastId:(int)podcastId;

@end
