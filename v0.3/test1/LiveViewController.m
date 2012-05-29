//
//  LiveViewController.m
//  test1
//
//  Created by Adrien Humilière on 29/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "LiveViewController.h"

@interface LiveViewController ()

@end

@implementation LiveViewController
@synthesize onOffAir;

extern AVPlayer *audioPlayer;

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
	
	NSString *radioURL = @"http://radio.podradio.fr:8000/adsl.m3u";
	audioPlayer = [AVPlayer playerWithURL:[NSURL URLWithString:radioURL]];
	
	if (audioPlayer.status != AVPlayerStatusFailed) {
		onOffAir.image = [UIImage imageNamed:@"on_air.png"];
	}
}

- (void)viewDidUnload
{
    [self setOnOffAir:nil];
    onOffAir = nil;
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
@end
