//
//  ForumViewController.m
//  freepod
//
//  Created by Adrien Humilière on 05/06/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "ForumViewController.h"
#import "Episode.h"
#import "VideoEpisodeViewController.h"
#import "AudioEpisodeViewController.h"

@interface ForumViewController ()

@end

@implementation ForumViewController
@synthesize webView;
@synthesize playerButton;
@synthesize navBar;

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
	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.freepod.net/forum"]]];
}

- (void)viewDidUnload
{
	[self setWebView:nil];
	webView = nil;
	playerButton = nil;
	[self setPlayerButton:nil];
	navBar = nil;
	[self setNavBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)displayPlayer:(id)sender {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	if ([readingEpisode isVideo]) {
		NSLog(@"VideoEpisodeViewController");
		VideoEpisodeViewController *videoViewController = [[VideoEpisodeViewController alloc]initWithNibName:@"VideoEpisodeViewController" bundle:nil];
		
		videoViewController.episode = readingEpisode;
		
		videoViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		[self presentModalViewController:videoViewController animated:YES];
	} else {
		NSLog(@"AudioEpisodeViewController");
		AudioEpisodeViewController *audioViewController = [[AudioEpisodeViewController alloc]initWithNibName:@"AudioEpisodeViewController" bundle:nil];
		
		audioViewController.episode = readingEpisode;
		
		audioViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
		[self presentModalViewController:audioViewController animated:YES];
	}
}

- (IBAction)showActionSheet:(id)sender {
	
	
	UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Vous allez quitter l'application Freepod" delegate:self cancelButtonTitle:@"Annuler" destructiveButtonTitle:@"Ouvrir dans Safari" otherButtonTitles:nil]; 
	//popupQuery.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    [popupQuery showFromTabBar:self.tabBarController.tabBar];

	//[[UIApplication sharedApplication] openURL:currentURL];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 0) {
		NSURLRequest *currentRequest = [webView request];
		NSURL *currentURL = [currentRequest URL];
		[[UIApplication sharedApplication] openURL:currentURL];
	} else if (buttonIndex == 1) {
	}
}


@end
