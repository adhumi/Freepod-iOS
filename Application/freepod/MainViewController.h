//
//  ViewController.h
//  freepod
//
//  Created by Adrien Humilière on 07/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoverButton.h"
#import "PodcastViewController.h"
#import "PodcastsManager.h"
#import "PlayerMainViewController.h"

@interface MainViewController : UIViewController <CoverButtonDelegate> {
    UIScrollView *          _scrollView;
	UIRefreshControl *		_refreshControl;
}



@end
