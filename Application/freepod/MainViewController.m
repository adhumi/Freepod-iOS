//
//  ViewController.m
//  freepod
//
//  Created by Adrien Humilière on 07/12/12.
//  Copyright (c) 2012 Freepod. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)init {
    self = [super init];
    if (self) {
		[PlayerMainViewController instance];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPodcastsListUpdate) name:NOTIFICATION_PODCASTS_LIST_UPDATE object:nil];
	}
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[self view] setBackgroundColor:[UIColor whiteColor]];
    
	[[[self navigationController] navigationBar] setOpaque:YES];
    [[[self navigationController] navigationBar] setBarTintColor:[UIColor freepodLightBlueColor]];
        
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height - 44 - 20)];
    [_scrollView setContentSize:CGSizeMake(320, [[self view] bounds].size.height - 64)];
	
	_refreshControl = [[UIRefreshControl alloc] init];
    [_refreshControl addTarget:[PodcastsManager instance] action:@selector(update) forControlEvents:UIControlEventValueChanged];
	[_refreshControl setTintColor:[UIColor colorWithRed:255/225.f green:186/255.f blue:2/255.f alpha:1]];
    [_scrollView addSubview:_refreshControl];
	
    [[self view] addSubview:_scrollView];

	UIView * shadow = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64)];
	[shadow setBackgroundColor:[UIColor clearColor]];
	[[shadow layer] setShadowColor:[UIColor blackColor].CGColor];
	[[shadow layer] setShadowOffset:CGSizeMake(0, 0)];
	[[shadow layer] setShadowRadius:3.];
	[[shadow layer] setShadowOpacity:1.];
	[[self view] addSubview:shadow];
	
    //[self displayPodcastsList];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)onPodcastsListUpdate {
	[_refreshControl endRefreshing];
	
	[self displayPodcastsList];
}

- (void)displayPodcastsList {
	for (UIView * subview in [_scrollView subviews]) {
		[subview removeFromSuperview];
	}
	
	PodcastsManager * podManager = [PodcastsManager instance];
	
    if ([podManager podcasts] == nil) return;
    if ([[podManager podcasts] count] == 0) return;
    
    int scrollViewHeight = (ceil([[podManager podcasts] count] / 2.) * 160);
        
    if (scrollViewHeight > [[self view] bounds].size.height) {
        [_scrollView setContentSize:CGSizeMake(320, scrollViewHeight)];
    }
    
    int i = 0;
    for (Podcast* podcast in [podManager podcasts]) {
        int row = floor(i / 2); // de 0 à infinity
        int col = i % 2; // 0 ou 1
        
        CoverButton* newCover = [[CoverButton alloc] initWithFrame:CGRectMake(col * 160, row * 160, 160, 160) andPodcast:podcast];
        [newCover setDelegate:self];
        [_scrollView addSubview:newCover];
        
        ++i;
    }
}

- (void)displayPlayer {
    [self presentViewController:[PlayerMainViewController instance] animated:YES completion:^{
        //
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - delegate CoverButton

- (void)coverTouched:(Podcast *)podcast {
    // La cover a été touchée, afficher le détail du podcast
    NSLog(@"Load podcast %@", podcast);
    
    PodcastViewController* podcastViewController = [[PodcastViewController alloc] initWithPodcast:podcast];
    [self.navigationController pushViewController:podcastViewController animated:YES];
}



@end
