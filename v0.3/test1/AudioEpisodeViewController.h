//
//  AudioEpisodeViewController.h
//  test1
//
//  Created by Adrien Humilière on 26/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AudioEpisodeViewController : UIViewController {
	IBOutlet UIImageView *jacquette;
	IBOutlet UILabel *nom;
	IBOutlet UIButton *playPause;
	IBOutlet UISlider *avancement;
	IBOutlet UILabel *tpsEcoule;
	IBOutlet UILabel *tpsRestant;
	AVPlayer *audioPlayer;
	NSTimer *timer;
}

@property AVPlayer *audioPlayer;
@property NSTimer *timer;

@property (nonatomic, retain) IBOutlet UIImageView *jacquette;
@property (nonatomic, retain) IBOutlet UILabel *nom;
@property (nonatomic, retain) IBOutlet UIButton *playPause;
@property (nonatomic, retain) IBOutlet UISlider *avancement;
@property (nonatomic, retain) IBOutlet UILabel *tpsEcoule;
@property (nonatomic, retain) IBOutlet UILabel *tpsRestant;

@property (strong, nonatomic) id episode;

- (IBAction)playEpisode:(id)sender;
- (IBAction)pauseEpisode:(id)sender;

@end
