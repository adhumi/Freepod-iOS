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
	
	
	
	if (_episode != readingEpisode) {
		NSURL *urlFile = [NSURL URLWithString:[_episode urlSource]];
		audioPlayer = [AVPlayer playerWithURL:urlFile];
		readingEpisode = _episode;
	}
	
	_episode = readingEpisode;
	
	UIImage *tmpJacquette = [_episode getJacquette:640];
	if (tmpJacquette != nil) {
		[_jacquette setImage:tmpJacquette];
	}
	
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
	
	// TODO : AJOUTER UNE ALERTE SI LE FICHIER N'EST PAS ACCESSIBLE
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
	int minutesRest = secRest / 60;
	int secondsRest = secRest - (minutesRest * 60);
	self.tpsRestant.text = [NSString stringWithFormat:@"- %02d:%02d",minutesRest,secondsRest];
}

//// Stop the timer when the music is finished (Need to implement the AVAudioPlayerDelegate in the Controller header)
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
//	// Music completed
//	if (flag) {
//		[sliderTimer invalidate];
//	}
//}


@end
