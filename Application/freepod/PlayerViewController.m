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
	
	UIBarButtonItem * infoButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PlayerInfoButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onInfoButton)];
	[self.navigationItem setLeftBarButtonItem:infoButton];
	
	UIBarButtonItem * closeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PlayerCloseButton"] style:UIBarButtonItemStyleBordered target:self action:@selector(onCloseButton)];
	[self.navigationItem setRightBarButtonItem:closeButton];
	
	self.edgesForExtendedLayout = UIRectEdgeNone;
	
	_cover = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cover.png"]];
	[_cover setFrame:CGRectMake(0, 0, 320, 320)];
	[[self view] addSubview:_cover];
	
	
	
	// Progress container
	
	UIView* progressContainer = [[UIView alloc] initWithFrame:CGRectMake([_cover frame].origin.x, [_cover frame].origin.y + [_cover frame].size.height, 320, 60)];
	[progressContainer setBackgroundColor:[UIColor whiteColor]];
	[[progressContainer layer] setShadowColor:[UIColor blackColor].CGColor];
	[[progressContainer layer] setShadowOffset:CGSizeMake(0, 0)];
	[[progressContainer layer] setShadowRadius:3.];
	[[progressContainer layer] setShadowOpacity:1.];
	[[self view] addSubview:progressContainer];
	
	_progressTime = [[UILabel alloc] initWithFrame:CGRectMake([progressContainer frame].origin.x + 5, [progressContainer frame].origin.y + 20, 100, 20)];
	[_progressTime setBackgroundColor:[UIColor clearColor]];
	[_progressTime setText:@"00:00"];
	[_progressTime setTextColor:[UIColor freepodLightBlueColor]];
	[_progressTime setTextAlignment:NSTextAlignmentLeft];
	[_progressTime setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
	[[self view] addSubview:_progressTime];
	
	_remainingTime = [[UILabel alloc] initWithFrame:CGRectMake([progressContainer frame].origin.x + [progressContainer frame].size.width - 100 - 5, [progressContainer frame].origin.y + 20, 100, 20)];
	[_remainingTime setBackgroundColor:[UIColor clearColor]];
	[_remainingTime setText:@"-00:00"];
	[_remainingTime setTextColor:[UIColor freepodLightBlueColor]];
	[_remainingTime setTextAlignment:NSTextAlignmentRight];
	[_remainingTime setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10]];
	[[self view] addSubview:_remainingTime];
	
	_progressBar = [[ProgressSlider alloc] initWithFrame:CGRectMake([progressContainer frame].origin.x + 20, [progressContainer frame].origin.y + 20, 280, 20)];
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
	
	
	
	// Player container
	
	UIView* playerContainer = [[UIView alloc] initWithFrame:CGRectMake([progressContainer frame].origin.x, [progressContainer frame].origin.y + [progressContainer frame].size.height, 320, [UIScreen mainScreen].bounds.size.height - [_cover frame].size.height - [progressContainer frame].size.height - 44 - 20)];
	[playerContainer setBackgroundColor:[UIColor whiteColor]];
	[[self view] addSubview:playerContainer];
	
	UIView* separator = [[UIView alloc] initWithFrame:CGRectMake([progressContainer frame].origin.x, [progressContainer frame].origin.y + [progressContainer frame].size.height, 320, 1)];
	[separator setBackgroundColor:[UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.1]];
	[[self view] addSubview:separator];
	
	_playPauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_playPauseButton setFrame:CGRectMake(([playerContainer frame].origin.x + [playerContainer frame].size.width - 62) * 0.5f, [playerContainer frame].origin.y + ([playerContainer frame].size.height - 62) * 0.5f, 62, 62)];
	[_playPauseButton setBackgroundImage:[UIImage imageNamed:@"PlayerButtonPlay"] forState:UIControlStateNormal];
	[_playPauseButton setBackgroundImage:[UIImage imageNamed:@"PlayerButtonPause"] forState:UIControlStateSelected];
	[_playPauseButton addTarget:self action:@selector(playButton) forControlEvents:UIControlEventTouchUpInside];
	[_playPauseButton setHidden:YES];
	[[self view] addSubview:_playPauseButton];
	
	UIButton * minus30 = [UIButton buttonWithType:UIButtonTypeCustom];
	[minus30 setFrame:CGRectMake(([playerContainer frame].origin.x + [playerContainer frame].size.width - 62) * 0.5f - 62 - 20, [playerContainer frame].origin.y + ([playerContainer frame].size.height - 62) * 0.5f, 62, 62)];
	[minus30 setBackgroundImage:[UIImage imageNamed:@"PlayerButtonBack30"] forState:UIControlStateNormal];
	[[self view] addSubview:minus30];
	
	UIButton * plus30 = [UIButton buttonWithType:UIButtonTypeCustom];
	[plus30 setFrame:CGRectMake(([playerContainer frame].origin.x + [playerContainer frame].size.width - 62) * 0.5f + 62 + 20, [playerContainer frame].origin.y + ([playerContainer frame].size.height - 62) * 0.5f, 62, 62)];
	[plus30 setBackgroundImage:[UIImage imageNamed:@"PlayerButtonForw30"] forState:UIControlStateNormal];
	[[self view] addSubview:plus30];
	
	_waitingView = [[UIImageView alloc] initWithFrame:[_playPauseButton frame]];
	[_waitingView setImage:[UIImage imageNamed:@"PlayerButtonEmpty"]];
	_indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[_indicator setFrame:CGRectMake([_waitingView frame].origin.x + ([_waitingView frame].size.width - 20) / 2.f, [_waitingView frame].origin.y + ([_waitingView frame].size.height - 20) / 2.f, 20, 20)];
	[_indicator startAnimating];
	[_waitingView addSubview:_indicator];
	[[self view] addSubview:_waitingView];
	
	
	
	
	// Top shadow
	
	UIView * shadow = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64)];
	[shadow setBackgroundColor:[UIColor whiteColor]];
	[[shadow layer] setShadowColor:[UIColor blackColor].CGColor];
	[[shadow layer] setShadowOffset:CGSizeMake(0, 0)];
	[[shadow layer] setShadowRadius:3.];
	[[shadow layer] setShadowOpacity:1.];
	[[self view] addSubview:shadow];
	
	
	
	
	UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 100, 44)];
	
	_episodeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, headerView.frame.size.width, 20)];
	[_episodeTitle setBackgroundColor:[UIColor clearColor]];
	[_episodeTitle setText:@"title"];
	[_episodeTitle setTextColor:[UIColor whiteColor]];
	[_episodeTitle setTextAlignment:NSTextAlignmentCenter];
	[_episodeTitle setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:18]];
	[_episodeTitle setNumberOfLines:1];
	[headerView addSubview:_episodeTitle];

	_podcastName = [[UILabel alloc] initWithFrame:CGRectMake(0, [_episodeTitle frame].origin.y + [_episodeTitle frame].size.height - 2, headerView.frame.size.width, 16)];
	[_podcastName setBackgroundColor:[UIColor clearColor]];
	[_podcastName setText:@"name"];
	[_podcastName setTextColor:[UIColor whiteColor]];
	[_podcastName setTextAlignment:NSTextAlignmentCenter];
	[_podcastName setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:14]];
	[_podcastName setNumberOfLines:1];
	[headerView addSubview:_podcastName];
	
	[self.navigationItem setTitleView:headerView];
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
			UIImage *image = [[UIImage alloc] initWithData:data scale:[[UIScreen mainScreen] scale]];
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
