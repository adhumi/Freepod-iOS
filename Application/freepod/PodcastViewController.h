//
//  PodcastViewController.h
//  freepod
//
//  Created by Adrien Humilière on 09/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PodcastsManager.h"
#import "UIImage+ImageEffects.h"
#import "PlayerMainViewController.h"

@interface PodcastViewController : UITableViewController<NSURLConnectionDelegate, UITableViewDelegate> {

}

@property (nonatomic, retain) Podcast *		podcast;

- (id)initWithPodcast:(Podcast *)podcast;

@end
