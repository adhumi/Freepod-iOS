//
//  EpisodesRecentsViewController.m
//  test1
//
//  Created by Adrien Humilière on 28/05/12.
//  Copyright (c) 2012 home. All rights reserved.
//

#import "EpisodesRecentsViewController.h"

#import "SBJson.h"
#import "Podcast.h"
#import "Episode.h"

#import "AudioEpisodeViewController.h"
#import "EpisodeControllerJacquetteDownloader.h"
#import "EpisodeCell.h"

#import "AudioEpisodeViewController.h"

@interface EpisodesRecentsViewController () {
    NSMutableArray *_objects;
}
@end

@implementation EpisodesRecentsViewController

@synthesize detailItem = _detailItem;
@synthesize imageDownloadsInProgress;
@synthesize banner;

extern Episode *readingEpisode;

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
	self.tableView.rowHeight = 64;
	
	[super viewDidLoad];
	
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Player" style:UIBarButtonItemStylePlain target:self action:@selector(displayPlayer:)];
	self.navigationItem.rightBarButtonItem = addButton;
	
	
	//self.navigationItem.title = @"Freepod";
	
	self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.22 green:0.38 blue:0.47 alpha:1];
	UIImageView *logo=[[UIImageView alloc]initWithFrame:CGRectMake(74, 0, 172, 44)];
	logo.image=[UIImage imageNamed:@"logo_freepod_navbar_crop.png"];
	logo.tag = 42;
	[self.navigationController.navigationBar addSubview:logo];
	
	// Récupération de la liste des épisodes
	SBJsonParser* parser = [[SBJsonParser alloc] init];
	NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://webserv.freepod.net/get.php?episode_recent=15"]]];
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
		
		if (!_objects) {
			_objects = [[NSMutableArray alloc] init];
		}
		[_objects addObject:newEpisode];
	}
	
	NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
	[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	
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
	if (!object.jacquette) {
		if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
			[self startJacquetteDownload:object forIndexPath:indexPath andWith:128];
		}
		// if a download is deferred or in progress, return a placeholder image
		cell.jacquette.image = [UIImage imageNamed:@"jacquette_default_64.png"];                
	}
	else
	{
		cell.jacquette.image = object.jacquette;
	}
	
	cell.duration.text = [object duration];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
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

- (void)jacquetteEpisodeDidLoad:(NSIndexPath *)indexPath
{
    EpisodeControllerJacquetteDownloader *jacquetteDownloader = [imageDownloadsInProgress objectForKey:indexPath];
    if (jacquetteDownloader != nil) {
        EpisodeCell *cell = (EpisodeCell*) [self.tableView cellForRowAtIndexPath:jacquetteDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.jacquette.image  = jacquetteDownloader.episode.jacquette;
	}
	
	[self.tableView reloadData];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

- (void)startJacquetteDownload:(Episode *)episode forIndexPath:(NSIndexPath *)indexPath andWith:(int) width{
    if ([_objects count] > indexPath.row) {
		EpisodeControllerJacquetteDownloader *jacquetteDownloader = [imageDownloadsInProgress objectForKey:indexPath];
		if (jacquetteDownloader == nil) {
			jacquetteDownloader = [[EpisodeControllerJacquetteDownloader alloc] init];
			jacquetteDownloader.episode = episode;
			jacquetteDownloader.indexPathInTableView = indexPath;
			jacquetteDownloader.delegate = self;
			[imageDownloadsInProgress setObject:jacquetteDownloader forKey:indexPath];
			[jacquetteDownloader startDownload:width];
		}
	}
}

- (void)loadImagesForOnscreenRows {
	if ([_objects count] > 0) {
		NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
		for (NSIndexPath *indexPath in visiblePaths) {
			if ([_objects count] > indexPath.row) {
				Episode *episode = [_objects objectAtIndex:indexPath.row];
				if (!episode.jacquette) {
					[self startJacquetteDownload:episode forIndexPath:indexPath andWith:128];
				}
			}
		}
	}
}

-(void) imageDidLoad:(AsynchronousUIImage *)anImage {
	if (anImage.tag == 1) {
		banner.image = (UIImage*) anImage;
	}
	[self.tableView reloadData];
}

@end
