//
//  VideoEpisodeViewController.m
//  test1
//
//  Created by Adrien Humilière on 31/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "VideoEpisodeViewController.h"

#import "Episode.h"
#import "MasterViewController.h"

#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>

#import "PlayerView.h"

@interface VideoEpisodeViewController ()

@end

@implementation VideoEpisodeViewController

@synthesize episode = _episode;
@synthesize precedentView = _precedentView;

@synthesize nom = _nom;
@synthesize play = _play;
@synthesize pause = _pause;
@synthesize audioPlayer = _audioPlayer;
@synthesize avancement = _avancement;
@synthesize timer = _timer;
@synthesize tpsEcoule = _tpsEcoule;
@synthesize tpsRestant = _tpsRestant;
@synthesize descriptionLabel = _descriptionLabel;
@synthesize descriptionScrollView = _descriptionScrollView;
@synthesize date = _date;
@synthesize navBar = _navBar;
@synthesize playerView = _playerView;
@synthesize infos = _infos;
@synthesize activity = _activity;
@synthesize isShowingLandscapeView;

extern AVPlayer *audioPlayer;
extern Episode *readingEpisode;

- (void)setEpisode:(id)newDetailItem
{
    if (_episode != newDetailItem) {
        _episode = newDetailItem;
	}
}

- (void)setPrecedentView:(id)newPrecedentView {
	if (_precedentView != newPrecedentView) {
        _precedentView = newPrecedentView;
	}
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	isShowingLandscapeView = NO;
	
	if (_episode != readingEpisode) {
		NSURL *urlFile = [NSURL URLWithString:[_episode urlSource]];
		audioPlayer = [AVPlayer playerWithURL:urlFile];
		readingEpisode = _episode;
	}
	
	_episode = readingEpisode;
	
	self.avancement.maximumValue = [_episode getDurationInSeconds];
	
	int minutesDef = [_episode getDurationInSeconds] / 60;
	int secondsDef = [_episode getDurationInSeconds] - (minutesDef * 60);
	self.tpsRestant.text = [NSString stringWithFormat:@"- %02d:%02d",minutesDef,secondsDef];
	
	self.descriptionLabel.text = [_episode getDescription];
	self.date.text = [_episode formattedPubDate];
	
	_nom.text = [_episode title];
	
	// Mise en place du timer
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
	
	if (audioPlayer.rate > 0.5) {
		CMTime duration = audioPlayer.currentTime; 
		float seconds = CMTimeGetSeconds(duration); 
		int minutesDef = lroundf(seconds) / 60;
		int secondsDef = seconds - (minutesDef * 60);
		[self.avancement setValue:seconds animated:YES];
		self.tpsEcoule.text = [NSString stringWithFormat:@"%02d:%02d",minutesDef,secondsDef];
		
		int secRest = [_episode getDurationInSeconds] - seconds;
		int minutesRest = secRest / 60;
		int secondsRest = secRest - (minutesRest * 60);
		self.tpsRestant.text = [NSString stringWithFormat:@"- %02d:%02d",minutesRest,secondsRest];
		
		[self.play setHidden:YES];
		[self.pause setHidden:NO];
	}
	
	UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.navBar addGestureRecognizer:recognizer];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
	
	playerView = [[PlayerView alloc] init];
	
	playerView.hidden = NO;
	
	NSLog(@"avant setPlayer");
	NSLog(@"%@", [playerView class]);
	[self.playerView setPlayer:audioPlayer];
	
	[self refreshPlayButton];
}

- (BOOL)canBecomeFirstResponder {
	return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlTogglePlayPause:
            if (audioPlayer.rate == 0.0) {
                [audioPlayer play];
            } else {
                [audioPlayer pause];
            }
            break;
        case UIEventSubtypeRemoteControlPlay:
            [audioPlayer play];
            break;
        case UIEventSubtypeRemoteControlPause:
            [audioPlayer pause];
            break;
        default:
            break;
    }
}

- (void)viewDidUnload
{
	avancement = nil;
	tpsEcoule = nil;
	tpsRestant = nil;
	descriptionLabel = nil;
	descriptionScrollView = nil;
	date = nil;
	navBar = nil;
	[timer invalidate];
	playerView = nil;
	[self setPlayerView:nil];
	infos = nil;
	[self setInfos:nil];
	activity = nil;
	[self setActivity:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIDeviceOrientationPortraitUpsideDown);
}

- (IBAction)playEpisode:(id)sender {
	NSLog(@"Démarrage de la lecture de %@",[_episode urlSource]);
	
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
	
	[audioPlayer play];
	[self refreshPlayButton];
}

- (IBAction)pauseEpisode:(id)sender {
	[audioPlayer pause];
	[timer invalidate];
	[self.play setHidden:NO];
	[self.pause setHidden:YES];
}

- (IBAction)goToTime:(id)sender {
	CMTime t = CMTimeMakeWithSeconds(self.avancement.value, 1);
	[audioPlayer seekToTime:t]; 
	[self updateSlider];
	[self refreshPlayButton];
}

- (IBAction)getDetails:(id)sender {
	if (self.descriptionScrollView.hidden) {
		[self.descriptionScrollView setHidden:NO];
	} else {
		[self.descriptionScrollView setHidden:YES];
	}
}

- (IBAction)goBack:(id)sender {
	[timer invalidate];
	[self dismissModalViewControllerAnimated:YES];
}

- (void) refreshPlayButton {
	if (audioPlayer.status != AVPlayerStatusUnknown) {
		if (audioPlayer.rate > 0) {
			_play.hidden = YES;
			_pause.hidden = NO;
			_activity.hidden = YES;
		} else {
			_play.hidden = NO;
			_pause.hidden = YES;
			_activity.hidden = YES;
			[timer invalidate];
		}
	} else {
		_play.hidden = YES;
		_pause.hidden = YES;
		activity.hidden = NO;
	}
}

- (void)updateSlider {
	CMTime duration = audioPlayer.currentTime; 
	float seconds = CMTimeGetSeconds(duration); 
	int minutesDef = lroundf(seconds) / 60;
	int secondsDef = seconds - (minutesDef * 60);
	[self.avancement setValue:seconds animated:YES];
	self.tpsEcoule.text = [NSString stringWithFormat:@"%02d:%02d",minutesDef,secondsDef];
	
	int secRest = [_episode getDurationInSeconds] - seconds;
	if (secRest < 0 || secRest == NAN || seconds == NAN) {
		self.tpsRestant.text = @"";
	} else {
		int minutesRest = secRest / 60;
		int secondsRest = secRest - (minutesRest * 60);
		self.tpsRestant.text = [NSString stringWithFormat:@"- %02d:%02d",minutesRest,secondsRest];
	}
	
	[self refreshPlayButton];
}

//// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	// Music completed
	[self refreshPlayButton];
	CMTime t = CMTimeMakeWithSeconds(0, 1);
	[audioPlayer seekToTime:t]; 
	[self updateSlider];
	if (flag) {
		[timer invalidate];
	}
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	NSLog(@"Changement d'orientation");
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) && !isShowingLandscapeView) {
        _nom.hidden = YES;
		_play.hidden = YES;
		_pause.hidden = YES;
		_avancement.hidden = YES;
		_tpsEcoule.hidden = YES;
		_tpsRestant.hidden = YES;
		_navBar.hidden = YES;
		_infos.hidden = YES;
		_playerView.frame = CGRectMake(0, 0, 480, 320);
        isShowingLandscapeView = YES;
		[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    } else if (UIDeviceOrientationIsPortrait(deviceOrientation) && isShowingLandscapeView) {
        _nom.hidden = NO;
		
		if (audioPlayer.rate > 0.5) {
			_play.hidden = YES;
			_pause.hidden = NO;
		} else {
			_play.hidden = NO;
			_pause.hidden = YES;
		}
		_avancement.hidden = NO;
		_tpsEcoule.hidden = NO;
		_tpsRestant.hidden = NO;
		_navBar.hidden = NO;
		_infos.hidden = NO;
		_playerView.frame = CGRectMake(0, 44, 320, 320);
        isShowingLandscapeView = NO;
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    }
}

@end