//
//  ViewController.m
//  Freepod
//
//  Created by Adrien Humilière on 14/03/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Podcast.h"

@implementation ViewController

@synthesize myTableView;

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
	
	self.view.backgroundColor = [UIColor whiteColor];
	self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	self.myTableView.dataSource = self;
	[self.view addSubview:self.myTableView];
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

- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView {
	NSInteger result = 0;
	if ([tableView isEqual:self.myTableView]) {
		result = 1;
	}
	return result;
}

- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result = 0;
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if ([tableView isEqual:self.myTableView]) {
		result = [appDelegate->podcastsList count];
	}
	return result;
}

- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *result = nil;
	
	AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if ([tableView isEqual:self.myTableView]) {
		static NSString *TableViewCellIdentifier = @"MyCells";
		result = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
		
		if (result == nil) {
			result = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TableViewCellIdentifier];
		}
		
		result.textLabel.text = [NSString stringWithString:[[appDelegate->podcastsList objectAtIndex:indexPath.row] nom]];
	}
	return result;
}

@end
