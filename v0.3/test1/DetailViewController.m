//
//  DetailViewController.m
//  test1
//
//  Created by Adrien Humilière on 21/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "DetailViewController.h"

#import "SBJson.h"
#import "Podcast.h"
#import "Episode.h"

#import "AudioEpisodeViewController.h"

@interface DetailViewController () {
    NSMutableArray *_objects;
}
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
	NSLog(@"Appel : setDetailItem");
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
		
		Podcast *podcast = newDetailItem;
		
		[podcast initEpisodes];
		
		// Récupération de la liste des épisodes
		SBJsonParser* parser = [[SBJsonParser alloc] init];
		NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://webserv.freepod.net/get.php?episodes=%@", [NSString stringWithFormat:@"%d", [podcast idPodcast]]]]];
		NSData* response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
		NSString* jsonString = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
		NSArray* episodes = [parser objectWithString:jsonString error:nil];
		
		for (NSDictionary* episode in episodes) {
			Episode *newEpisode = [[Episode alloc] init];
			NSLog(@"%@",[episode objectForKey:@"title"]);
			
			[newEpisode setIdEpisode:[[episode objectForKey:@"id"] intValue]];
			[newEpisode setIdPodcast:[[episode objectForKey:@"id_podcast"] intValue]];
			[newEpisode setTitle:[episode objectForKey:@"title"]];
			[newEpisode setURL:[episode objectForKey:@"url"]];
			[newEpisode setType:[episode objectForKey:@"type"]];
			[newEpisode setDescription:[episode objectForKey:@"description"]];
			[newEpisode setAuthor:[episode objectForKey:@"author"]];
			[newEpisode setExplicite:[episode objectForKey:@"explicite"]];
			[newEpisode setDuration:[episode objectForKey:@"duration"]];
			[newEpisode setImage:[episode objectForKey:@"newImage"]];
			[newEpisode setKeywords:[episode objectForKey:@"keywords"]];
			
			[podcast addEpisode:newEpisode];
		}
		
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
	if (self.detailItem) {
	    self.detailDescriptionLabel.text = [self.detailItem description];
		self.navigationItem.title = [self.detailItem description];
		UIImageView *tmpImgView = (UIImageView*) [self.navigationController.navigationBar viewWithTag:42];
		if(tmpImgView) {
			tmpImgView.hidden = true;
		}
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	Podcast *podcast = _detailItem;
	
	if (!_objects) {
		_objects = [[NSMutableArray alloc] init];
	} else {
		_objects = nil;
		[self.tableView reloadData];
	}
	
	// Remplissage NSTableView
	NSEnumerator *enumerator = [[podcast getAllEpisodes] objectEnumerator];
	Episode *episode;
	while (episode = [enumerator nextObject]) {
		NSLog(@"NSTableView %@", [episode title]);
		[_objects insertObject:episode atIndex:0];
	}
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	
	//Banniere en haut de la NSTableView
	UIImageView *headerLabel = [[UIImageView alloc] initWithImage:[podcast getBanner:320]];
	headerLabel.contentMode = UIViewContentModeScaleAspectFill;
	self.tableView.tableHeaderView = headerLabel;
	
	self.tableView.rowHeight = 60;
	
	[self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	self.detailDescriptionLabel = nil;
	NSLog(@"TATA");
	UIImageView *tmpImgView = (UIImageView*) [self.navigationController.navigationBar viewWithTag:42];
	tmpImgView.hidden = false;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
    }
	
	Episode *object = [_objects objectAtIndex:indexPath.row];
	cell.textLabel.text = [object description];
	cell.imageView.image = [object getJacquette:120];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioEpisodeViewController *audioViewController = [[AudioEpisodeViewController alloc]initWithNibName:@"AudioEpisodeViewController" bundle:nil];
	
	Episode *episode = [_objects objectAtIndex:indexPath.row];
	
	audioViewController.episode = episode;
    [self.navigationController pushViewController:audioViewController animated:YES];
}



@end
