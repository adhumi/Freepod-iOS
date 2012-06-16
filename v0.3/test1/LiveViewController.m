//
//  LiveViewController.m
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "LiveViewController.h"
#import "Episode.h"
#import <Twitter/Twitter.h>

@interface LiveViewController ()

@end

@implementation LiveViewController
@synthesize onOffAir;
@synthesize navBar;
@synthesize playPause;
@synthesize tweet;
@synthesize timer;
@synthesize audioPlayer = _audioPlayer;
@synthesize playerItem;

extern AVPlayer *audioPlayer;
extern Episode *readingEpisode;

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
    // Do any additional setup after loading the view from its nib.
	
	navBar.tintColor = [UIColor colorWithRed:0.22 green:0.38 blue:0.47 alpha:1];
	UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(74, 0, 172, 44)];
	logo.image=[UIImage imageNamed:@"logo_freepod_navbar_crop.png"];
	logo.tag = 42;
	[navBar addSubview:logo];
	
	NSURL *urlFile = [NSURL URLWithString:@"http://statslive.infomaniak.com/playlist/freepod/freepod-32.aac/playlist.m3u"];
	playerItem = [AVPlayerItem playerItemWithURL:urlFile];
	audioPlayer = [AVPlayer playerWithPlayerItem:playerItem];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(checkStatus) userInfo:nil repeats:YES];
	
	readingEpisode = nil;
	
	[playPause setTitle:@"Lancer le live" forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [self setOnOffAir:nil];
    onOffAir = nil;
    navBar = nil;
    [self setNavBar:nil];
	playPause = nil;
	[self setPlayPause:nil];
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

- (IBAction)goLive:(id)sender {
	if (audioPlayer.rate > 0.5) {
		[audioPlayer pause];
		[playPause setTitle:@"Retablir le live" forState:UIControlStateNormal];
	} else {
		[audioPlayer play];
		[playPause setTitle:@"Mettre en pause" forState:UIControlStateNormal];
	}
}

- (IBAction)sendTweet:(id)sender {
	// Create the view controller
	TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
	
	// Optional: set an image, url and initial text
	//[twitter addImage:[UIImage imageNamed:@""]];
	[twitter addURL:[NSURL URLWithString:@"http://www.freepod.net/live"]];
	[twitter setInitialText:@"Freepod en live, en ce moment sur Freepod pour iOS"];
	
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
}

- (void) checkStatus {
	if (self.isViewLoaded && self.view.window) {
		if (readingEpisode != nil) {
			NSURL *urlFile = [NSURL URLWithString:@"http://statslive.infomaniak.com/playlist/freepod/freepod-32.aac/playlist.m3u"];
			playerItem = [AVPlayerItem playerItemWithURL:urlFile];
			audioPlayer = [AVPlayer playerWithPlayerItem:playerItem];
			
			readingEpisode = nil;
			
			[playPause setTitle:@"Lancer le live" forState:UIControlStateNormal];
		}
		
		NSLog(@"Status AVPlayer : %i", audioPlayer.status);
		NSLog(@"Status AVPlayerItem : %i", playerItem.status);
		
		if (audioPlayer.status == AVPlayerItemStatusReadyToPlay	&& playerItem.status == AVPlayerItemStatusReadyToPlay) {
			onOffAir.image = [UIImage imageNamed:@"on_air.png"];
			playPause.hidden = NO;
			NSLog(@"TOTO YES");
		} else {
			onOffAir.image = [UIImage imageNamed:@"off_air.png"];
			playPause.hidden = YES;
			NSLog(@"TOTO NO");
		}
	}
	

}

@end
