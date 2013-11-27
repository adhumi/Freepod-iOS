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
    [_scrollView setContentSize:CGSizeMake(320, [[self view] bounds].size.height)];
	[_scrollView setShowsVerticalScrollIndicator:YES];
    [[self view] addSubview:_scrollView];
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(onUpdateContent) forControlEvents:UIControlEventValueChanged];
	[_scrollView addSubview:refreshControl];

	UIView * shadow = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64)];
	[shadow setBackgroundColor:[UIColor whiteColor]];
	[[shadow layer] setShadowColor:[UIColor blackColor].CGColor];
	[[shadow layer] setShadowOffset:CGSizeMake(0, 0)];
	[[shadow layer] setShadowRadius:3.];
	[[shadow layer] setShadowOpacity:1.];
	[[self view] addSubview:shadow];
	
    //[self displayPodcastsList];
}

- (void)onUpdateContent {
	[[PodcastsManager instance] update];
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
        int row = floor(i / 2);
        int col = i % 2;
        
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
