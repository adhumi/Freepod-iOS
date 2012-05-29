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

#import "EpisodeCell.h"

@interface DetailViewController () {
    NSMutableArray *_objects;
}
@end

@implementation DetailViewController

@synthesize detailItem = _detailItem;

#pragma mark - Managing the detail item

extern Episode *readingEpisode;

- (void)setDetailItem:(id)newDetailItem
{
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
			[newEpisode setLastUpdateFromString:[episode objectForKey:@"pubDate"]];
			
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
		//self.navigationItem.title = [self.detailItem description];
		UIImageView *tmpImgView = (UIImageView*) [self.navigationController.navigationBar viewWithTag:42];
		if(tmpImgView) {
			//tmpImgView.hidden = true;
		}
	}
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Player" style:UIBarButtonItemStylePlain target:self action:@selector(displayPlayer:)];
	self.navigationItem.rightBarButtonItem = addButton;
	
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
		[_objects insertObject:episode atIndex:0];
	}
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	
	//Banniere en haut de la NSTableView
	UIImageView *headerLabel = [[UIImageView alloc] initWithImage:[podcast getBanner:320]];
	headerLabel.contentMode = UIViewContentModeScaleAspectFill;
	self.tableView.tableHeaderView = headerLabel;
	
	self.tableView.rowHeight = 64;
	
	[self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
	UIImageView *tmpImgView = (UIImageView*) [self.navigationController.navigationBar viewWithTag:42];
	tmpImgView.hidden = false;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
		//self.title = NSLocalizedString(@"Detail", @"Detail");
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
    
    EpisodeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"EpisodeCell" owner:self options:nil];
		cell = (EpisodeCell *)[nib objectAtIndex:0];
    }
	
	Episode *object = [_objects objectAtIndex:indexPath.row];
	cell.nom.text = [object description];
	cell.date.text = [object formattedPubDate];
	UIImage *tmpJacquette = [object getJacquette:128];
	if (tmpJacquette != nil) {
		cell.jacquette.image = tmpJacquette;
	}
	cell.duration.text = [object duration];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AudioEpisodeViewController *audioViewController = [[AudioEpisodeViewController alloc]initWithNibName:@"AudioEpisodeViewController" bundle:nil];
	
	Episode *episode = [_objects objectAtIndex:indexPath.row];
	
	audioViewController.episode = episode;
	
	audioViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:audioViewController animated:YES];
}

// AFFICHE LE PLAYER
- (void)displayPlayer:(id)sender
{
	AudioEpisodeViewController *audioViewController = [[AudioEpisodeViewController alloc]initWithNibName:@"AudioEpisodeViewController" bundle:nil];
	
	audioViewController.episode = readingEpisode;
	audioViewController.precedentView = self.view;
	
	audioViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
	[self presentModalViewController:audioViewController animated:YES];
}

@end
