//
//  VideoEpisodeViewController.h
//  test1
//
//  Created by Adrien Humilière on 31/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPMoviePlayerController.h>

#import "AsynchronousUIImage.h"
@class PlayerView;

@interface VideoEpisodeViewController : UIViewController <AsynchronousUIImageDelegate> {
	IBOutlet UILabel *nom;
	IBOutlet UIButton *play;
	IBOutlet UIButton *pause;
	IBOutlet UISlider *avancement;
	IBOutlet UILabel *tpsEcoule;
	IBOutlet UILabel *tpsRestant;
	IBOutlet UILabel *descriptionLabel;
	IBOutlet UIScrollView *descriptionScrollView;
	IBOutlet UILabel *date;
	IBOutlet UINavigationBar *navBar;
	NSTimer *timer;
	BOOL isShowingLandscapeView;
	IBOutlet PlayerView *playerView;
	IBOutlet UIButton *infos;
	IBOutlet UIActivityIndicatorView *activity;
	IBOutlet UIBarButtonItem *tweet;
}

@property AVPlayer *audioPlayer;
@property NSTimer *timer;
@property BOOL isShowingLandscapeView;

@property (nonatomic, retain) IBOutlet UILabel *nom;
@property (nonatomic, retain) IBOutlet UIButton *play;
@property (nonatomic, retain) IBOutlet UIButton *pause;
@property (nonatomic, retain) IBOutlet UISlider *avancement;
@property (nonatomic, retain) IBOutlet UILabel *tpsEcoule;
@property (nonatomic, retain) IBOutlet UILabel *tpsRestant;
@property (nonatomic, retain) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, retain) IBOutlet UIScrollView *descriptionScrollView;
@property (nonatomic, retain) IBOutlet UILabel *date;
@property (nonatomic, retain) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet PlayerView *playerView;
@property (strong, nonatomic) IBOutlet UIButton *infos;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *tweet;

@property (strong, nonatomic) id episode;

@property (strong, nonatomic) id precedentView;

- (IBAction)playEpisode:(id)sender;
- (IBAction)pauseEpisode:(id)sender;
- (IBAction)goToTime:(id)sender;
- (IBAction)getDetails:(id)sender;
- (IBAction)goBack:(id)sender;
- (IBAction)sendTweet:(id)sender;

@end
