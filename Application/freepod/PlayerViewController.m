//
//  PlayerViewController.m
//  freepod
//
//  Created by Adrien Humilière on 11/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

static PlayerViewController* instance;

+ (PlayerViewController*)instance
{
    @synchronized(self) {
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{ instance = [[self alloc] init]; });
    }
    
    return instance;
}

- (id)init {
    self = [super init];
    if (self) {
        _player = [Player instance];
    }
    return self;
}

- (void)viewDidLoad {
	[[self view] setBackgroundColor:[UIColor whiteColor]];
	
	[[[self navigationController] navigationBar] setOpaque:YES];
	
	UIBarButtonItem * closeButton = [[UIBarButtonItem alloc] initWithTitle:@"Fermer" style:UIBarButtonItemStyleBordered target:self action:@selector(onCloseButton)];
	[self.navigationItem setRightBarButtonItem:closeButton];
	
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
	_cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover.png"]];
	[_cover setFrame:CGRectMake(0, 0, 320, 320)];
	[[self view] addSubview:_cover];
	
	UIView* titleBg = [[UIView alloc] initWithFrame:CGRectMake([_cover frame].origin.x, [_cover frame].origin.y + [_cover frame].size.height, 320, 60)];
	[titleBg setBackgroundColor:[UIColor colorWithRed:0.22 green:0.38 blue:0.47 alpha:0.9]];
	[[self view] addSubview:titleBg];
		
	_episodeTitle = [[UILabel alloc] initWithFrame:CGRectMake([titleBg frame].origin.x + 20, [titleBg frame].origin.y + 5, 280, 25)];
	[_episodeTitle setBackgroundColor:[UIColor clearColor]];
	[_episodeTitle setText:@"title"];
	[_episodeTitle setTextColor:[UIColor whiteColor]];
	[_episodeTitle setTextAlignment:NSTextAlignmentCenter];
	[_episodeTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
	[_episodeTitle setNumberOfLines:1];
	[[self view] addSubview:_episodeTitle];
	
	_podcastName = [[UILabel alloc] initWithFrame:CGRectMake([titleBg frame].origin.x + 20, [_episodeTitle frame].origin.y + [_episodeTitle frame].size.height, 280, 20)];
	[_podcastName setBackgroundColor:[UIColor clearColor]];
	[_podcastName setText:@"name"];
	[_podcastName setTextColor:[UIColor whiteColor]];
	[_podcastName setTextAlignment:NSTextAlignmentCenter];
	[_podcastName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:16]];
	[_podcastName setNumberOfLines:1];
	[[self view] addSubview:_podcastName];
	
	UIButton * info = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[info setFrame:CGRectMake([titleBg frame].origin.x + [titleBg frame].size.width - 40, [titleBg frame].origin.y + ([titleBg frame].size.height - 40) * 0.5f, 40, 40)];
	[info setTitle:@"i" forState:UIControlStateNormal];
	[info addTarget:self action:@selector(onInfoButton) forControlEvents:UIControlEventTouchUpInside];
	[[self view] addSubview:info];
	
	UIView* playerContainer = [[UIView alloc] initWithFrame:CGRectMake([titleBg frame].origin.x, [titleBg frame].origin.y + [titleBg frame].size.height, 320, [UIScreen mainScreen].bounds.size.height - [_cover frame].size.height - [titleBg frame].size.height - 44 - 20)];
	[playerContainer setBackgroundColor:[UIColor colorWithRed:0.22 green:0.38 blue:0.47 alpha:1.]];
	[[self view] addSubview:playerContainer];
	
	_progressTime = [[UILabel alloc] initWithFrame:CGRectMake([playerContainer frame].origin.x + 5, [playerContainer frame].origin.y + 15, 100, 15)];
	[_progressTime setBackgroundColor:[UIColor clearColor]];
	[_progressTime setText:@"00:00"];
	[_progressTime setTextColor:[UIColor whiteColor]];
	[_progressTime setTextAlignment:NSTextAlignmentLeft];
	[_progressTime setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
	[[self view] addSubview:_progressTime];
	
	_remainingTime = [[UILabel alloc] initWithFrame:CGRectMake([playerContainer frame].origin.x + [playerContainer frame].size.width - 100 - 5, [playerContainer frame].origin.y + 15, 100, 15)];
	[_remainingTime setBackgroundColor:[UIColor clearColor]];
	[_remainingTime setText:@"-00:00"];
	[_remainingTime setTextColor:[UIColor whiteColor]];
	[_remainingTime setTextAlignment:NSTextAlignmentRight];
	[_remainingTime setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
	[[self view] addSubview:_remainingTime];
	
	_progressBar = [[ProgressSlider alloc] initWithFrame:CGRectMake([playerContainer frame].origin.x + 20, [playerContainer frame].origin.y + 15, 280, 15)];
	[_progressBar setThumbImage:[UIImage imageNamed:@"PlayerThumb"] forState:UIControlStateNormal];
	[_progressBar setMinimumValue:0.0];
	[_progressBar setMaximumValue:1.0];
	[_progressBar setMinProgressValue:0.0];
	[_progressBar setMaxProgressValue:1.0];
	[_progressBar setProgressValue:0.5];
	[_progressBar setValue:0.0];
	[_progressBar setContinuous:true];
	[_progressBar addTarget:self action:@selector(goToPosition) forControlEvents:UIControlEventTouchUpInside];
	[_progressBar addTarget:self action:@selector(goToPosition) forControlEvents:UIControlEventTouchUpOutside];
	[_progressBar addTarget:self action:@selector(isDragging) forControlEvents:UIControlStateHighlighted];
	[_progressBar addTarget:_progressBar action:@selector(setNeedsDisplay) forControlEvents:UIControlEventValueChanged];
	[[self view] addSubview:_progressBar];
	
	_playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_playPauseButton setBackgroundColor:[UIColor greenColor]];
	[_playPauseButton setFrame:CGRectMake(([playerContainer frame].origin.x + [playerContainer frame].size.width - 40) * 0.5f, [playerContainer frame].origin.y + 35, 40, 40)];
	[_playPauseButton addTarget:self action:@selector(playButton) forControlEvents:UIControlEventTouchUpInside];
	[_playPauseButton setHidden:YES];
	[[self view] addSubview:_playPauseButton];
	
	_waitingView = [[UIView alloc] initWithFrame:[_playPauseButton frame]];
	[_waitingView setBackgroundColor:[UIColor redColor]];
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
	[_indicator setFrame:CGRectMake((40 - 20) * 0.5, (40 - 20) * 0.5, 20, 20)];
	[_indicator startAnimating];
	[_waitingView addSubview:_indicator];
	[[self view] addSubview:_waitingView];
}

- (void)onInfoButton {
	PlayerDetailsViewController * details = [[PlayerDetailsViewController alloc] initWithEpisode:[_player episode]];
	[[self navigationController] pushViewController:details animated:YES];
}

- (void)onCloseButton {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)preparePlayer {
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.adhumi.fr/api/get-img-podcast.php?id=%d&nom=logo_normal&width=%f", [[_player episode] podcastId], _cover.frame.size.width * [[UIScreen mainScreen] scale]]]];
	[NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
		if (connectionError) {
			NSLog(@"Error loading cover");
		} else {
			UIImage *image = [[UIImage alloc] initWithData:data];
			[_cover setImage:image];
		}
	}];
	
    [_episodeTitle setText:[[_player episode] title]];
}


- (void)goToPosition {
    _isDraggingSlider = NO;
    [_player seek:_progressBar.value];
}

- (void)isDragging {
    _isDraggingSlider = YES;
}

- (void)playButton {
    if ([_player isPlaying]) {
		[_player pause];
    } else {
        [_player play];
    }
	
	[_playPauseButton setSelected:[_player isPlaying]];
}

- (void)onStatusChange {
	[_progressBar setMaximumValue:[_player duration]];
	[_progressBar setMaxProgressValue:[_player duration]];
	
	if ([_player isReady]) {
		[_indicator stopAnimating];
        [_waitingView setHidden:YES];
        [_playPauseButton setHidden:NO];
	} else {
		[_indicator startAnimating];
        [_waitingView setHidden:NO];
        [_playPauseButton setHidden:YES];
	}
}

- (void)onProgressChange {
    if(_isClosed) {
		return;
    }
	
	[_progressBar setProgressValue:[_player loadedDuration]];
    
    float seconds = [_player duration];
	int minutesDef = lroundf(seconds) / 60;
	int secondsDef = seconds - (minutesDef * 60);
    NSString* txt = [NSString stringWithFormat:@"%02d:%02d",minutesDef,secondsDef];
    [_remainingTime setText:txt];
    
    seconds = [_player readPosition];
	minutesDef = lroundf(seconds) / 60;
	secondsDef = seconds - (minutesDef * 60);
    txt = [NSString stringWithFormat:@"%02d:%02d",minutesDef,secondsDef];
    [_progressTime setText:txt];
    
    if ([_player isReady] && !_isDraggingSlider) {
        [_progressBar setValue:seconds animated:YES];
    }
	
	[_progressBar setNeedsDisplay];
}

@end
