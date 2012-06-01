//
//  AudioEpisodeViewController.m
//  test1
//
//  Created by Adrien Humilière on 26/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "AudioEpisodeViewController.h"
#import "Episode.h"
#import "MasterViewController.h"

#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>
#import <Twitter/Twitter.h>

#import "PlayerView.h"

@interface AudioEpisodeViewController ()

@end

@implementation AudioEpisodeViewController

@synthesize episode = _episode;
@synthesize precedentView = _precedentView;

@synthesize jacquette = _jacquette;
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
@synthesize freeze = _freeze;
@synthesize howTo = _howTo;
@synthesize activity = _activity;
@synthesize tweet = _tweet;

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
	
	// Si l'épisode en cours de lecture n'est pas celui qu'on affiche
	if (_episode != readingEpisode) {
		NSURL *urlFile = [NSURL URLWithString:[_episode urlSource]];
		audioPlayer = [AVPlayer playerWithURL:urlFile];
		readingEpisode = _episode;
	}
	
	// On récupère les données de l'épisode
	_episode = readingEpisode;
	
	// Récupération de la jacquette (asynchrone)
	AsynchronousUIImage *image = [[AsynchronousUIImage alloc] init];
	[image loadImageFromURL: [NSString stringWithFormat:@"http://webserv.freepod.net/get-img-episode.php?id=%d&nom=image&width=%d", [_episode idEpisode], 640] ];
	image.tag = 2;
	image.delegate = self;
	
	// Réglage du Slider
	self.avancement.maximumValue = [_episode getDurationInSeconds];
	
	// Indication du temps de lecture restant
	int minutesDef = [_episode getDurationInSeconds] / 60;
	int secondsDef = [_episode getDurationInSeconds] - (minutesDef * 60);
	self.tpsRestant.text = [NSString stringWithFormat:@"- %02d:%02d",minutesDef,secondsDef];
	
	// Remplissage de la description
	self.descriptionLabel.text = [_episode getDescription];
	self.date.text = [_episode formattedPubDate];
	
	// Remplissage du nom de l'épisode
	_nom.text = [_episode title];
	
	// Masquer l'avertissement si le player est instancié
	if (_episode != nil) {
		_freeze.hidden = YES;
		_howTo.hidden = YES;
		_tweet.enabled = YES;
		// Mise en place du timer
		timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateSlider) userInfo:nil repeats:YES];
	}
	
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
	}
	
	UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [self.navBar addGestureRecognizer:recognizer];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	[self refreshPlayButton];
	
	[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
	[self becomeFirstResponder];
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
	jacquette = nil;
	avancement = nil;
	tpsEcoule = nil;
	tpsRestant = nil;
	descriptionLabel = nil;
	descriptionScrollView = nil;
	date = nil;
	navBar = nil;
	[timer invalidate];
	freeze = nil;
	[self setFreeze:nil];
	howTo = nil;
	[self setHowTo:nil];
	activity = nil;
	[self setActivity:nil];
	tweet = nil;
	[self setTweet:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
	[self refreshPlayButton];
}

- (IBAction)goToTime:(id)sender {
	CMTime t = CMTimeMakeWithSeconds(self.avancement.value, 1);
	[audioPlayer seekToTime:t]; 
	[self updateSlider];
	[self refreshPlayButton];
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

- (IBAction)sendTweet:(id)sender {
	if (NSClassFromString(@"TWTweetComposeViewController")) {
	// Create the view controller
	TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
	
	// Optional: set an image, url and initial text
	//[twitter addImage:[UIImage imageNamed:@"iOSDevTips.png"]];
	[twitter addURL:[NSURL URLWithString:[NSString stringWithString:@"http://www.freepod.net"]]];
	[twitter setInitialText:@"Merci de ne pas abuser de cette fonction avant publication officielle"];
	
	// Show the controller
	[self presentModalViewController:twitter animated:YES];
	
	// Called when the tweet dialog has been closed
	twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
	{
		NSString *title = @"Twitter";
		NSString *msg; 
		
		if (result == TWTweetComposeViewControllerResultCancelled)
			msg = @"L'écriture du tweet a été annulée.";
		else if (result == TWTweetComposeViewControllerResultDone)
			msg = @"Tweet correctement publié !.";
		
		// Show alert to see how things went...
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
		
		// Dismiss the controller
		[self dismissModalViewControllerAnimated:YES];
	};
	} else {
		// Show alert to see how things went...
		UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Le partage sur Twitter n'est disponible qu'à partir d'iOS 5. Mettez à jour !" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[alertView show];
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
	if (secRest <= 0 || secRest == NAN || seconds == NAN) {
		self.tpsRestant.text = @"";
	} else {
		int minutesRest = secRest / 60;
		int secondsRest = secRest - (minutesRest * 60);
		self.tpsRestant.text = [NSString stringWithFormat:@"- %02d:%02d",minutesRest,secondsRest];
	}
	
	[self refreshPlayButton];
}

-(void) imageDidLoad:(AsynchronousUIImage *)anImage {
	if (anImage.tag == 2) {
		_jacquette.image = (UIImage*) anImage;
	}
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


@end
