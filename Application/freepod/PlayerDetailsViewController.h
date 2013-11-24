//
//  PlayerDetailsViewController.h
//  freepod
//
//  Created by Adrien Humilière on 24/11/2013.
//  Copyright (c) 2013 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Episode.h"

@interface PlayerDetailsViewController : UIViewController {
	Episode *		_episode;
}

- (id)initWithEpisode:(Episode *)episode;

@end
