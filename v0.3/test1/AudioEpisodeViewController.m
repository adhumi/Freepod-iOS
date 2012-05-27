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
	
	//NSURL *url = [NSURL URLWithString:[_episode URL]];
	
	//NSData *data = [NSData dataWithContentsOfURL:url];
	
	//AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
	
	//[audioPlayer play];
	
}

- (void)viewDidUnload
{
	jacquette = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
