//
//  LiveViewController.m
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "LiveViewController.h"
#import "Episode.h"

@interface LiveViewController ()

@end

@implementation LiveViewController
@synthesize onOffAir;
@synthesize navBar;
@synthesize playPause;
@synthesize timer;
@synthesize audioPlayer = _audioPlayer;

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
	
	NSURL *urlFile = [NSURL URLWithString:@"http://radio.podradio.fr:8000/adsl.m3u"];
	audioPlayer = [AVPlayer playerWithURL:urlFile];
	
	timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(checkStatus) userInfo:nil repeats:YES];
	
	readingEpisode = nil;
}

- (void)viewDidUnload
{
    [self setOnOffAir:nil];
    onOffAir = nil;
    navBar = nil;
    [self setNavBar:nil];
	playPause = nil;
	[self setPlayPause:nil];
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
	} else {
		[audioPlayer play];
	}
}

- (void) checkStatus {
	if (self.isViewLoaded && self.view.window) {
		NSLog(@"LIVE ACTIVE");
	}
	
	if (audioPlayer.status !=  AVPlayerStatusUnknown && audioPlayer.status !=  AVPlayerStatusFailed) {
		onOffAir.image = [UIImage imageNamed:@"on_air.png"];
		playPause.hidden = NO;
	}
}
@end
