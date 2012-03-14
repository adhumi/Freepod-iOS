//
//  ViewController.m
//  Freepod
//
//  Created by Adrien Humilière on 14/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "ViewController.h"
#import "SBJson.h"
#import "Podcast.h"

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.navigationItem.title = @"Freepod";
	
	SBJsonParser* parser = [[SBJsonParser alloc] init];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://webserv.freepod.net/get.php?podcasts"]];
	NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
	NSString* jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		//NSLog(@"%@", jsonString);
	NSArray* podcasts = [parser objectWithString:jsonString error:nil];
	
	for (NSDictionary* podcast in  podcasts) {
		Podcast *newPodcast = [[Podcast alloc] init];
		
		[newPodcast setIdPodcast:[[podcast objectForKey:@"id"] intValue]];
		[newPodcast setNom:[podcast objectForKey:@"nom"]];
		[newPodcast setDescription:[podcast objectForKey:@"description"]];
		[newPodcast setExplicite:[podcast objectForKey:@"explicite"]];
		[newPodcast setUrlSite:[podcast objectForKey:@"url_site"]];
		[newPodcast setUrlFreepod:[podcast objectForKey:@"url_freepod"]];
		[newPodcast setLogoNormal:[podcast objectForKey:@"logo_normal"]];
		[newPodcast setLogoBanner:[podcast objectForKey:@"logo_banner"]];
		
		[podcastsList addObject:newPodcast];
	}
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	} else {
	    return YES;
	}
}

@end
