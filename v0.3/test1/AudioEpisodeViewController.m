//
//  AudioEpisodeViewController.m
//  test1
//
//  Created by Adrien Humilière on 26/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "AudioEpisodeViewController.h"
#import "Episode.h"

@interface AudioEpisodeViewController ()

@end

@implementation AudioEpisodeViewController

@synthesize episode = _episode;
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

extern AVPlayer *audioPlayer;

- (void)setEpisode:(id)newDetailItem
{
    if (_episode != newDetailItem) {
        _episode = newDetailItem;
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
	UIImage *tmpJacquette = [_episode getJacquette:640];
	if (tmpJacquette != nil) {
		[_jacquette setImage:tmpJacquette];
	}
	
	_nom.text = [_episode title];
    [super viewDidLoad];
	
	self.avancement.maximumValue = [_episode getDurationInSeconds];
	
	int minutesDef = [_episode getDurationInSeconds] / 60;
	int secondsDef = [_episode getDurationInSeconds] - (minutesDef * 60);
	self.tpsRestant.text = [NSString stringWithFormat:@"- %02d:%02d",minutesDef,secondsDef];
	
	self.descriptionLabel.text = [_episode getDescription];
	
	NSURL *urlFile = [NSURL URLWithString:[_episode urlSource]];
	audioPlayer = [AVPlayer playerWithURL:urlFile];

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

- (void)updateSlider {
	CMTime duration = audioPlayer.currentTime; 
	float seconds = CMTimeGetSeconds(duration); 
	int minutesDef = seconds / 60;
	int secondsDef = seconds - (minutesDef * 60);
	NSLog(@"Temps écoulé : %.2f", seconds); 
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
