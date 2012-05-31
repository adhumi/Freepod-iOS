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

- (void)viewDidLoad
{
	
	
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
	
	if (audioPlayer.rate > 0.5) {
		timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
		
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
	// TODO : AJOUTER UNE ALERTE SI LE FICHIER N'EST PAS ACCESSIBLE
	
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
	
	playerView = [[PlayerView alloc] init];
	
	playerView.hidden = NO;
	
	NSLog(@"avant setPlayer");
	NSLog(@"%@", [playerView class]);
	[self.playerView setPlayer:audioPlayer];
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
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
	
	[audioPlayer play];
	[self.play setHidden:YES];
	[self.pause setHidden:NO];
}

- (IBAction)pauseEpisode:(id)sender {
	[audioPlayer pause];
	[timer invalidate];
	[self.play setHidden:NO];
	[self.pause setHidden:YES];
}

- (IBAction)goToTime:(id)sender {
	CMTime t = CMTimeMakeWithSeconds(self.avancement.value, 1);
	[self.audioPlayer seekToTime:t]; 
}

- (IBAction)getDetails:(id)sender {
	if (self.descriptionScrollView.hidden) {
		[self.descriptionScrollView setHidden:NO];
	} else {
		[self.descriptionScrollView setHidden:YES];
	}
}

- (IBAction)goBack:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)updateSlider {
	CMTime duration = audioPlayer.currentTime; 
	float seconds = CMTimeGetSeconds(duration); 
	int minutesDef = lroundf(seconds) / 60;
	int secondsDef = seconds - (minutesDef * 60);
	[self.avancement setValue:seconds animated:YES];
	self.tpsEcoule.text = [NSString stringWithFormat:@"%02d:%02d",minutesDef,secondsDef];
	
	int secRest = [_episode getDurationInSeconds] - seconds;
	if (secRest <= 0 || secRest == NAN || seconds == NAN) {
		self.tpsRestant.text = @"";
	} else {
		int minutesRest = secRest / 60;
		int secondsRest = secRest - (minutesRest * 60);
		self.tpsRestant.text = [NSString stringWithFormat:@"- %02d:%02d",minutesRest,secondsRest];
	}
}

//// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	// Music completed
	if (flag) {
		[timer invalidate];
		[self.play setHidden:NO];
		[self.pause setHidden:YES];
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